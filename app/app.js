require('dotenv').config();
const express = require('express');
const path = require('path');
const i18n = require('i18n');
const expressLayouts = require('express-ejs-layouts');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const flash = require('express-flash');

const app = express();

app.use(expressLayouts);
app.set('layout', 'layout');
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.static(path.join(__dirname, 'public')));
app.use(cookieParser());

app.use(session({
  secret: 'secreto123',
  resave: false,
  saveUninitialized: false,
}));

app.use(flash());

// Configuración i18n
i18n.configure({
  locales: ['es', 'en'],
  defaultLocale: 'en',
  directory: path.join(__dirname, 'locales'),
  objectNotation: true,
  updateFiles: false,
  queryParameter: 'lang',         // ✅ permite cambiar con ?lang=es
  cookie: 'lang'                  // ✅ permite guardar el idioma en cookie
});
app.use(i18n.init);

// Middleware para cambiar idioma usando cookies
app.use((req, res, next) => {
  const lang = req.query.lang || req.cookies.lang || 'en';
  if (['es', 'en'].includes(lang)) {
    res.setLocale(lang);
    res.cookie('lang', lang, { maxAge: 900000, httpOnly: true });
  }
  next();
});

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Rutas
const routes = require('./routers/index');
const contactRoutes = require('./routers/contact');
const tourRoutes = require('./routers/tours');
const reservaRoutes = require('./routers/reservar');
const legalRoutes = require('./routers/legal');
//const adminRoutes = require('./routers/admin');
//const authRoutes = require('./routers/auth');

app.use(routes);
app.use(contactRoutes);
app.use(tourRoutes);
app.use(reservaRoutes);
app.use(legalRoutes);
//app.use('/admin', adminRoutes);
//app.use('/admin', authRoutes); // rutas como /login, /logout

// Inicializar Stripe y arrancar el servidor
const Stripe = require('stripe');
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
app.locals.stripe = stripe;

app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});