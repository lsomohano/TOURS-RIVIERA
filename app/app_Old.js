require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const i18n = require('i18n');
const path = require('path');
const expressLayouts = require('express-ejs-layouts');
const cookieParser = require('cookie-parser'); // Importa cookie-parser
const session = require('express-session');
const flash = require('express-flash');
const Stripe = require('stripe');

const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

const app = express();

// Layout base
app.use(expressLayouts);
app.set('layout', 'layout');

// Motor de vistas EJS
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// Usa cookie-parser
app.use(cookieParser());


app.use(session({
  secret: 'tu_clave_secreta',
  resave: false,
  saveUninitialized: true,
}));

app.use(flash());

// Configuración i18n
i18n.configure({
  locales: ['es', 'en'],
  defaultLocale: 'en',
  directory: path.join(__dirname, 'locales'),
  objectNotation: true,
  updateFiles: false
});
app.use(i18n.init);

// Middleware para cambiar idioma usando cookies
app.use((req, res, next) => {
  const lang = req.query.lang || req.cookies.lang || 'en'; // Primero verifica la URL, luego cookies, por último el predeterminado
  if (['es', 'en'].includes(lang)) {
    res.setLocale(lang);
    res.cookie('lang', lang, { maxAge: 900000, httpOnly: true }); // Guarda el idioma en cookies por 15 minutos
  }
  next();
});

// Conexión a la base de datos
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

db.connect((err) => {
  if (err) {
    console.error('Error al conectar a la BD:', err);
  } else {
    console.log('Conectado a la base de datos');
  }
});

// Ruta principal
app.get('/', (req, res) => {
  const sql = 'SELECT * FROM tours';
  db.query(sql, (err, results) => {
    if (err) return res.status(500).send("Error en la base de datos");

    res.render('index', { 
      tours: results,
      locale: req.getLocale(), // Esto pasa el idioma actual a la vista
      currentUrl: req.originalUrl // Pasa la URL original al frontend
    });
  });
});

// Ruta para mostrar tours
app.get('/tours', (req, res) => {
  const sql = 'SELECT * FROM tours';
  db.query(sql, (err, results) => {
    if (err) return res.status(500).send("Error en la base de datos");

    res.render('tours', { 
      tours: results,
      locale: req.getLocale(), // También pasamos el idioma aquí
      currentUrl: req.originalUrl
    });
  });
});

const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: true }));

// GET: de la reserva. 
app.get('/reservar/:id', (req, res) => {
  const tourId = req.params.id;
  const sql = 'SELECT * FROM tours WHERE id = ?';

  db.query(sql, [tourId], (err, results) => {
    if (err || results.length === 0) {
      return res.status(404).send('Tour no encontrado');
    }

    res.render('reservar', {
      tour: results[0],
      locale: req.getLocale(),
      currentUrl: req.originalUrl,
      message: req.flash('success'),
      success: req.flash('success'),
      error:   req.flash('error')
    });
  });
});

// POST: Crear reserva + sesión de pago
app.post('/reservar', async (req, res) => {
  try {
    const { tour_id, nombre, email, telefono, fecha_reserva, personas } = req.body;

    if (!tour_id || !nombre || !email || !telefono || !fecha_reserva || !personas) {
      return res.status(400).send('Faltan campos en el formulario');
    }

    // Obtener precio del tour desde la BD
    const [tours] = await db.promise().query('SELECT precio FROM tours WHERE id = ?', [tour_id]);
    if (tours.length === 0) {
      return res.status(404).send('Tour no encontrado');
    }

    const precioPorPersona = tours[0].precio;
    const total = precioPorPersona * parseInt(personas, 10) * 100; // Convertir a centavos

    // 🔢 Generar código único de reserva
    const [countRows] = await db.promise().query('SELECT COUNT(*) AS total FROM reservas');
    const reservaCodigo = `RSV-${String(countRows[0].total + 1).padStart(6, '0')}`;

    // Insertar reserva en la base de datos
    const insertSql = `
      INSERT INTO reservas (
        tour_id, nombre, email, telefono, fecha_reserva, personas, pago_confirmado, 
        reserva_codigo, costo_unitario, costo_pagado
      )
      VALUES (?, ?, ?, ?, ?, ?, FALSE, ?, ?, ?)
      `;

      const [result] = await db.promise().query(insertSql, [
        tour_id,
        nombre,
        email,
        telefono,
        fecha_reserva,
        personas,
        reservaCodigo,
        precioPorPersona,
        (precioPorPersona * parseInt(personas, 10))
      ]);
    const reservaId = result.insertId;

    // Crear sesión de Stripe
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'mxn',
          product_data: {
            name: `Reserva Tour #${reservaId}`,
          },
          unit_amount: Math.round(total), // en centavos
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: `${process.env.DOMAIN}/reservar_success?session_id={CHECKOUT_SESSION_ID}&reservaId=${reservaId}`,
      cancel_url: `${process.env.DOMAIN}/reservar_cancel?reservaId=${reservaId}`,
    });

    // Guardar el session ID en la BD
    await db.promise().query(
      'UPDATE reservas SET stripe_session_id = ? WHERE id = ?',
      [session.id, reservaId]
    );

    // Redirigir al checkout
    res.redirect(303, session.url);

  } catch (error) {
    console.error('Error al procesar reserva:', error);
    res.status(500).send('Ocurrió un error al procesar la reserva');
  }
});

// GET: Éxito del pago
app.get('/reservar_success', async (req, res) => {
  const { session_id, reservaId } = req.query;

  try {
    const stripeSession = await stripe.checkout.sessions.retrieve(session_id);

    if (stripeSession.payment_status === 'paid') {
      await db.promise().query(
        'UPDATE reservas SET pago_confirmado = TRUE WHERE id = ?',
        [reservaId]
      );
    }

    const [reservas] = await db.promise().query(`
      SELECT r.*, t.nombre AS tour_nombre
      FROM reservas r
      JOIN tours t ON t.id = r.tour_id
      WHERE r.id = ?
    `, [reservaId]);

    if (reservas.length === 0) {
      return res.status(404).send('Reserva no encontrada');
    }

    res.render('reservar_success', {
      reserva: reservas[0],
      locale: req.getLocale(),
      currentUrl: req.originalUrl
    });

  } catch (error) {
    console.error('Error en /reservar_success:', error);
    res.status(500).send('Error al confirmar la reserva');
  }
});

// GET: Cancelar pago
app.get('/reservar_cancel', async (req, res) => {
  const { reservaId } = req.query;

  try {
    const [reservas] = await db.promise().query(`
      SELECT r.*, t.nombre AS tour_nombre
      FROM reservas r
      JOIN tours t ON t.id = r.tour_id
      WHERE r.id = ?
    `, [reservaId]);

    if (reservas.length === 0) {
      return res.status(404).send('Reserva no encontrada');
    }

    res.render('reservar_cancel', { 
      reserva: reservas[0],
      locale: req.getLocale(),
      currentUrl: req.originalUrl 
    });

  } catch (error) {
    console.error('Error en /reservar_cancel:', error);
    res.status(500).send('Error al mostrar cancelación');
  }
});

// GET: muestra la página con mensaje flash si existe
app.get('/contact', (req, res) => {
  res.render('contact', {
    locale: req.getLocale(),
    currentUrl: req.originalUrl,
    success: req.flash('success'),
    error: req.flash('error')
  });
});

// POST: guarda o procesa el mensaje, y redirige
app.post('/contact', (req, res) => {
  const { name, email, message } = req.body;

  // Inserta en la tabla contactos
  const sql = `
    INSERT INTO contactos (nombre, email, mensaje)
    VALUES (?, ?, ?)
  `;
  db.query(sql, [name, email, message], (err, result) => {
    if (err) {
      console.error('Error al guardar contacto:', err);
      req.flash('error', res.__('contact.saveError'));
      return res.redirect('/contact');
    }

    // Mensaje de éxito traducido
    req.flash('success', res.__('contact.thankYou'));
    res.redirect('/contact');
  });
});

app.get('/terminos-condiciones', (req, res) => {
  res.render('terminos-condiciones', {
    locale: req.getLocale(),
    currentUrl: req.originalUrl
  });
});

app.get('/politica-privacidad', (req, res) => {
  res.render('politica-privacidad', {
    locale: req.getLocale(),
    currentUrl: req.originalUrl
  });
});
// Rutas para servir el CSS y las banderas
//app.use('/flags', express.static(path.join(__dirname, 'node_modules/flag-icon-css/css')));
//app.use('/flags-flags', express.static(path.join(__dirname, 'node_modules/flag-icon-css/flags')));

// Iniciar el servidor
app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});

