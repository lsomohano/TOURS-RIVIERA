const ReservaModel = require('../models/reservasModel');
const TourModel = require('../models/TourModel');

// GET: Página para reservar un tour
exports.getReserva = async (req, res) => {
  const tourId = req.params.id;

  try {
    const [results] = await TourModel.getById(tourId);

    if (results.length === 0) {
      return res.status(404).send('Tour no encontrado');
    }

    res.render('reservar', {
      tour: results[0],
      locale: req.getLocale(),
      currentUrl: req.originalUrl,
      message: req.flash('success'),
      success: req.flash('success'),
      error: req.flash('error')
    });

  } catch (err) {
    console.error('Error al obtener tour:', err);
    res.status(500).send('Error al cargar la página de reserva');
  }
};

// POST: Crear reserva y redirigir a Stripe
exports.postReserva = async (req, res) => {
  try {
    const { tour_id, nombre_cliente, email, telefono, fecha_reserva, cantidad_personas, metodo_pago, total_pagado } = req.body;

    // Validación de campos obligatorios
    if (!tour_id || !nombre_cliente || !email || !telefono || !fecha_reserva || !cantidad_personas || !metodo_pago) {
      return res.status(400).send('Faltan campos en el formulario');
    }

    if (isNaN(cantidad_personas) || parseInt(cantidad_personas, 10) <= 0) {
      return res.status(400).send('El número de personas debe ser un valor positivo');
    }

    const [tours] = await ReservaModel.getTourPrecioById(tour_id);
    if (tours.length === 0) {
      return res.status(404).send('Tour no encontrado');
    }

    const precioPorPersona = tours[0].precio;
    const cantidad = parseInt(cantidad_personas, 10);
    const totalCalculado = precioPorPersona * cantidad;

    const [countRows] = await ReservaModel.getTotalReservas();
    const reservaCodigo = `RSV-${String(countRows[0].total + 1).padStart(6, '0')}`;

    const [result] = await ReservaModel.crearReserva({
      tour_id,
      nombre_cliente,
      email,
      telefono,
      fecha_reserva,
      cantidad_personas: cantidad,
      metodo_pago,
      reserva_codigo: reservaCodigo,
      costo_unitario: precioPorPersona,
      total_pagado: totalCalculado
    });

    const reservaId = result.insertId;
    console.log(process.env.DOMAIN);
    const stripe = req.app.locals.stripe;

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'mxn',
          product_data: {
            name: `Reserva Tour #${reservaId}`,
          },
          unit_amount: Math.round(totalCalculado * 100),
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: `${process.env.DOMAIN}/reservar_success?session_id={CHECKOUT_SESSION_ID}&reservaId=${reservaId}`,
      cancel_url: `${process.env.DOMAIN}/reservar_cancel?reservaId=${reservaId}`,
    });

    await ReservaModel.actualizarStripeSessionId(reservaId, session.id);

    req.flash('success', 'Reserva realizada correctamente');
    res.redirect(303, session.url);

  } catch (error) {
    console.error('Error al procesar reserva:', error);
    res.status(500).send('Ocurrió un error al procesar la reserva');
  }
};

// GET: Página de éxito
exports.reservaSuccess = async (req, res) => {
  const { session_id, reservaId } = req.query;

  // Validación de parámetros
  if (!session_id || !reservaId) {
    return res.status(400).send('Faltan parámetros necesarios');
  }

  try {
    const stripe = req.app.locals.stripe;
    const stripeSession = await stripe.checkout.sessions.retrieve(session_id);

    if (stripeSession.payment_status === 'paid') {
      await ReservaModel.confirmarPago(reservaId);
    }

    const [reservas] = await ReservaModel.getReservaConTour(reservaId);

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
};

// GET: Cancelación
exports.reservaCancel = async (req, res) => {
  const { reservaId } = req.query;

  // Validación de parámetro
  if (!reservaId) {
    return res.status(400).send('Falta el parámetro reservaId');
  }

  try {
    const [reservas] = await ReservaModel.getReservaConTour(reservaId);

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
}