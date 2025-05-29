const bcrypt = require('bcrypt');
//const db = require('../../db'); // ajusta según la ubicación
const reservasModel = require('../../models/reservasModel');
const TourModel = require('../../models/TourModel');

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

exports.MostrarFormulario = async (req, res) => {
    const [tours] = await TourModel.getAll();
    res.render('admin/reservas/new', { 
      tours,layout: 'layouts/admin',
        title: 'Admin | Reservaciones',
        botones: [] 
    });
};

  // Crear reservación y generar link
exports.crearReservacion = async (req, res) => {
    const data = req.body;

    const token_pago = crypto.randomBytes(16).toString('hex');
    const costo_unitario = parseFloat(data.costo_unitario || 0);
    const total_pagado = costo_unitario * parseInt(data.cantidad_personas);

    await reservasModel.crear({
      tour_id: data.tour_id,
      nombre_cliente: data.nombre_cliente,
      email: data.email,
      telefono: data.telefono,
      fecha_reserva: data.fecha_reserva,
      cantidad_personas: data.cantidad_personas,
      costo_unitario,
      total_pagado,
      punto_encuentro: data.punto_encuentro,
      peticiones_especiales: data.peticiones_especiales,
      estado: 'pendiente',
      metodo_pago: 'stripe',
      token_pago,
    });

    const linkPago = `${process.env.BASE_URL}/reservar/pago_token/${token_pago}`;
    req.flash('success', `Reservación creada. Link de pago: ${linkPago}`);
    res.redirect('/admin/reservas');
};
