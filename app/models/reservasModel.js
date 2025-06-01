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
      punto_encuentro = null,
      peticiones_especiales = null,
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
        punto_encuentro,
        peticiones_especiales,
        stripe_session_id,
        costo_unitario,
        total_pagado
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
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
        punto_encuentro,
        peticiones_especiales,
        stripe_session_id,
        costo_unitario,
        total_pagado
      ]
    );
  },

  actualizarReserva: (id, data) => {
    return db.promise().query('UPDATE reservas SET ? WHERE id = ?', [data, id]);
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
  },

  getReservaConTourLista: () => {
    return db.promise().query(`
      SELECT r.*, t.nombre AS tour_nombre
      FROM reservas r
      JOIN tours t ON t.id = r.tour_id`
    );
  },

  getPrecioPrivado: async (tourId, cantidadPersonas) => {
    try {
      const [rows] = await db.promise().query(
        `SELECT calcular_precio_privado(?, ?) AS totalCalculado`,
        [tourId, cantidadPersonas]
      );
  
      const total = rows[0]?.totalCalculado;
      //console.log('Valor:', total, 'Tipo:', typeof total); // string
      const totalNum = parseFloat(total);
      //console.log('Total como número:', totalNum, 'Tipo:', typeof totalNum); // number

      if (isNaN(totalNum)) {
        throw new Error('Precio calculado no es un número válido');
      }

      return totalNum;
    } catch (error) {
      console.error('Error en getPrecioPrivado:', error);
      throw error;
    }
  },

  getReservaById: async (reservaId) => {
    const [rows] = await db.promise().query(
      'SELECT r.*, t.nombre AS nombre_tour FROM reservas r INNER JOIN tours t ON r.tour_id = t.id WHERE r.id = ?',
      [reservaId]
    );
    return rows; // Retorna directamente el arreglo de filas
  }, 

  getByToken: (token) => {
    return db.promise().query('SELECT * FROM reservas WHERE token_pago = ?', [token]);
  },

  marcarComoPagada: (token) => {
    return db.promise().query(
      'UPDATE reservas SET estado = "pagado", updated_at = NOW() WHERE token_pago = ?',
      [token]
    );
  },
  
  crear: (data) => {
    const campos = Object.keys(data).join(',');
    const placeholders = Object.keys(data).map(() => '?').join(',');
    const valores = Object.values(data);

    return db.promise().query(`INSERT INTO reservas (${campos}) VALUES (${placeholders})`, valores);
  }
};

module.exports = ReservaModel;