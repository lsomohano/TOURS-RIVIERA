const bcrypt = require('bcrypt');
//const db = require('../../db'); // ajusta según la ubicación
const crypto = require('crypto');
const reservasModel = require('../../models/reservasModel');
const TourModel = require('../../models/TourModel');
const fs = require('fs');
const path = require('path');

exports.listarReservas = async (req, res) => {
  try {
    const [reservas] = await reservasModel.getReservaConTourLista();
    res.render('admin/reservas/index', { 
        reservas,
        layout: 'layouts/admin',
        title: 'Admin | Reservaciones',
        botones: [
          {href: '/admin/reservas/new', class: 'btn-primary', text: 'Nueva Reserva', icon: 'fas fa-plus' }
        ]
    });
  } catch (error) {
    console.error(error);
    req.flash('error', 'Error al cargar reservaciones');
    res.redirect('/admin');
  }
};

//Nueva Reservación 
exports.MostrarFormulario = async (req, res) => {
    const [tours] = await TourModel.getAllAdmin();
    res.render('admin/reservas/new', { 
        tours,
        layout: 'layouts/admin',
        title: 'Admin | Reservaciones',
        botones: [
          { href: '/admin/reservas', class: 'btn-secondary', text: 'Regresar', icon: 'fas fa-arrow-left' }
        ]
    });
};

  // Crear reservación y generar link
exports.crearReservacion = async (req, res) => {
  try {
    const data = req.body;

    // Generar token de pago y cálculos
    const token_pago = crypto.randomBytes(16).toString('hex');
    const costo_unitario = parseFloat(data.costo_unitario || 0);
    const cantidad_personas = parseInt(data.cantidad_personas);
    const total_pagado = costo_unitario * cantidad_personas;
    // Calcular fecha de vencimiento 48 horas después de ahora
    const fechaVencimiento = new Date(Date.now() + 48 * 60 * 60 * 1000);

    // Guardar en la base de datos
    await reservasModel.crear({
      tour_id: data.tour_id,
      nombre_cliente: data.nombre_cliente,
      email: data.email,
      telefono: data.telefono,
      fecha_reserva: data.fecha_reserva,
      cantidad_personas,
      costo_unitario,
      total_pagado,
      punto_encuentro: data.punto_encuentro,
      peticiones_especiales: data.peticiones_especiales,
      estado: 'pendiente',
      metodo_pago: 'stripe',
      token_pago,
      fecha_vencimiento: fechaVencimiento,
    });

    const tour = await TourModel.getById(data.tour_id);
    const nombre_tour = tour ? tour.nombre : 'Tour reservado';

    // Generar link de pago
    const linkPago = `${process.env.DOMAIN}/reservar/pagar/${token_pago}`;

    // Enviar correo
    const transporter = req.app.locals.transporter;
    const plantilla = fs.readFileSync(
      path.join(__dirname, '../../views/emails/reserva_creada.html'),
      'utf-8'
    );

    // Reemplazar variables en plantilla
    const contenidoHtml = plantilla
      .replace(/{{nombre}}/g, data.nombre_cliente || '')
      .replace(/{{codigo}}/g, token_pago || '')
      .replace(/{{nombre_tour}}/g, nombre_tour || 'Tour reservado')
      .replace(/{{fecha}}/g, data.fecha_reserva || '')
      .replace(/{{personas}}/g, cantidad_personas || '')
      .replace(/{{link_pago}}/g, linkPago);

    const mailOptions = {
      from: `"Riviera Tours" <${process.env.MAIL_USER}>`,
      to: data.email,
      subject: 'Confirmación de reservación',
      html: contenidoHtml
    };

    await transporter.sendMail(mailOptions);

    // Mensaje de éxito en backend
    req.flash('success', `Reservación creada. Link de pago: ${linkPago}`);
    res.redirect('/admin/reservas');
  } catch (error) {
    console.error('Error al crear la reserva:', error);
    req.flash('error', 'Hubo un problema al crear la reservación.');
    res.redirect('/admin/reservas');
  }
};

exports.editarVista = async (req, res) => {
  const reservaId = req.params.id;
  try {
    const [reservas] = await reservasModel.getReservaById(reservaId);
    if (reservas.length === 0) {
      return res.status(404).send('Reservación no encontrada');
    }

    const [tours] = await TourModel.getAllAdmin(); // si necesitas el select
    res.render('admin/reservas/edit', {
      layout: 'layouts/admin',
      reserva: reservas,
      tours,
      title: 'Admin | Reservaciones',
      botones: [
        { href: '/admin/reservas', class: 'btn-secondary', text: 'Regresar', icon: 'fas fa-arrow-left' }
      ]
    });
  } catch (error) {
    console.error('Error al cargar la edición de la reserva:', error);
    res.status(500).send('Error interno');
  }
};

exports.editarGuardar = async (req, res) => {
  const reservaId = req.params.id;
  const {
    nombre_cliente,
    email,
    telefono,
    cantidad_personas,
    fecha_reserva,
    metodo_pago,
    estado,
    punto_encuentro,
    peticiones_especiales
  } = req.body;

  // 🟡 Obtener datos actuales de la reserva
  const [reservaActual] = await reservasModel.getReservaById(reservaId);
  if (!reservaActual || reservaActual.length === 0) {
      req.flash('error', 'Reserva no encontrada');
      return res.redirect('/admin/reservas');
  }

  const estadoAnterior = reservaActual.estado;

  try {
    await reservasModel.actualizarReserva(reservaId, {
      nombre_cliente,
      email,
      telefono,
      cantidad_personas,
      fecha_reserva,
      metodo_pago,
      estado,
      punto_encuentro,
      peticiones_especiales
    });

    // Si fue cancelada, enviar correo
    if (estadoAnterior !== 'cancelado' && estado === 'cancelado') {
      const transporter = req.app.locals.transporter;

      const plantilla = fs.readFileSync(
        path.join(__dirname, '../../views/emails/reserva_cancelada.html'),
        'utf-8'
      );

      // Reemplazar variables
      const contenidoHtml = plantilla
        .replace(/{{nombre}}/g, nombre_cliente || '')
        .replace(/{{codigo}}/g, reservaActual.reserva_codigo || '')
        .replace(/{{nombre_tour}}/g, reservaActual.nombre_tour || '')
        .replace(/{{fecha}}/g, fecha_reserva || '')
        .replace(/{{personas}}/g, cantidad_personas || '');
        
      const mailOptions = {
        from: `"Riviera Tours" <${process.env.MAIL_USER}>`,
        to: email,
        subject: 'Tu reservación ha sido cancelada',
        html: contenidoHtml
      };

      await transporter.sendMail(mailOptions);
    }

    req.flash('success', 'Reservación actualizada correctamente');
    res.redirect('/admin/reservas');
  } catch (error) {
    console.error('Error al actualizar reserva:', error);
    req.flash('error', 'Error al actualizar la reserva');
    res.redirect(`/admin/reservas/${reservaId}/edit`);
  }
};
