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

exports.postReserva = async (req, res) => {
  try {
    const {
      tour_id,
      nombre_cliente,
      email,
      telefono,
      fecha_reserva,
      cantidad_personas,
      metodo_pago,
      modalidad,
      punto_encuentro,
      peticiones_especiales
    } = req.body;

    // Validación de campos obligatorios
    if (!tour_id || !nombre_cliente || !email || !telefono || !fecha_reserva || !cantidad_personas || !metodo_pago) {
      return res.status(400).send('Faltan campos en el formulario');
    }

    const cantidad = parseInt(cantidad_personas, 10);
    if (isNaN(cantidad) || cantidad <= 0) {
      return res.status(400).send('El número de personas debe ser un valor positivo');
    }

    if (modalidad !== 'privado' && modalidad !== 'grupo') {
      return res.status(400).send('Tipo de tour inválido');
    }

    // Obtener datos del tour
    const [tours] = await ReservaModel.getTourPrecioById(tour_id);
    if (tours.length === 0) {
      return res.status(404).send('Tour no encontrado');
    }

    let precioPorPersona;
    let totalCalculado;
    console.log('Modalidad recibida:', modalidad);
    if (modalidad === 'privado') {
      // Precio total calculado por grupo (privado)
      totalCalculado = await ReservaModel.getPrecioPrivado(tour_id, cantidad);
      precioPorPersona = totalCalculado / cantidad;
      
    } else {
      // Precio por persona (grupo)
      precioPorPersona = tours[0].precio;
      totalCalculado = precioPorPersona * cantidad;
    }

    if (isNaN(precioPorPersona) || isNaN(totalCalculado)) {
      return res.status(500).send('Error al calcular el precio');
    }

    // Generar código de reserva
    const [countRows] = await ReservaModel.getTotalReservas();
    const reservaCodigo = `RSV-${String(countRows[0].total + 1).padStart(6, '0')}`;

    // Crear reserva en base de datos
    const [result] = await ReservaModel.crearReserva({
      tour_id,
      nombre_cliente,
      email,
      telefono,
      fecha_reserva,
      cantidad_personas: cantidad,
      punto_encuentro,
      peticiones_especiales,
      metodo_pago,
      reserva_codigo: reservaCodigo,
      costo_unitario: precioPorPersona,
      total_pagado: totalCalculado,
    });

    const reservaId = result.insertId;

    const stripe = req.app.locals.stripe;
    const stripeAmount = Math.round(Number(totalCalculado) * 100);
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'mxn',
          product_data: {
            name: `Reserva Tour #${reservaId}`,
          },
          unit_amount: stripeAmount, // en centavos
          //unit_amount: Math.round(totalCalculado * 100), // en centavos
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: `${process.env.DOMAIN}/reservar_success?session_id={CHECKOUT_SESSION_ID}&reservaId=${reservaId}`,
      cancel_url: `${process.env.DOMAIN}/reservar_cancel?reservaId=${reservaId}`,
    });

    // Actualizar session ID en base de datos
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