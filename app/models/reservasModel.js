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
      tour_id, nombre, email, telefono, fecha_reserva,
      personas, reserva_codigo, costo_unitario, costo_pagado
    } = datos;

    return db.promise().query(`
      INSERT INTO reservas (
        tour_id, nombre, email, telefono, fecha_reserva, personas,
        pago_confirmado, reserva_codigo, costo_unitario, costo_pagado
      )
      VALUES (?, ?, ?, ?, ?, ?, FALSE, ?, ?, ?)`,
      [
        tour_id,
        nombre,
        email,
        telefono,
        fecha_reserva,
        personas,
        reserva_codigo,
        costo_unitario,
        costo_pagado
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
      'UPDATE reservas SET pago_confirmado = TRUE WHERE id = ?',
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