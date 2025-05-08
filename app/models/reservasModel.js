const db = require('../config/db');

const ReservaModel = {
  getTourById: (id) => {
    return db.promise().query('SELECT * FROM tours WHERE id = ?', [id]);
  },

  getTourPrecioById: (id) => {
    return db.promise().query('SELECT precio FROM tours WHERE id = ?', [id]);
  },

  getTotalReservas: () => {
    return db.promise().query('SELECT COUNT(*) AS total FROM reservas');
  },

  crearReserva: (datos) => {
    const {
      tour_id,
      usuario_id,
      reserva_codigo = null,
      nombre_cliente,
      email = null,
      telefono = null,
      cantidad_personas,
      fecha_reserva,
      metodo_pago = 'stripe',
      costo_unitario = null,
      total_pagado = null,
      stripe_session_id = null,
      estado = 'pendiente'
    } = datos;

    return db.promise().query(`
      INSERT INTO reservas (
        tour_id,
        usuario_id,
        reserva_codigo,
        nombre_cliente,
        email,
        telefono,
        cantidad_personas,
        fecha_reserva,
        estado,
        metodo_pago,
        stripe_session_id,
        costo_unitario,
        total_pagado
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        tour_id,
        usuario_id,
        reserva_codigo,
        nombre_cliente,
        email,
        telefono,
        cantidad_personas,
        fecha_reserva,
        estado,
        metodo_pago,
        stripe_session_id,
        costo_unitario,
        total_pagado
      ]
    );
  },

  actualizarStripeSessionId: (reservaId, sessionId) => {
    return db.promise().query(
      'UPDATE reservas SET stripe_session_id = ? WHERE id = ?',
      [sessionId, reservaId]
    );
  },

  confirmarPago: (reservaId) => {
    return db.promise().query(
      'UPDATE reservas SET estado = "pagado" WHERE id = ?',
      [reservaId]
    );
  },

  getReservaConTour: (reservaId) => {
    return db.promise().query(`
      SELECT r.*, t.nombre AS tour_nombre
      FROM reservas r
      JOIN tours t ON t.id = r.tour_id
      WHERE r.id = ?`,
      [reservaId]
    );
  }
};

module.exports = ReservaModel;