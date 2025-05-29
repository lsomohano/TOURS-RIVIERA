const db = require('../config/db');

const FechasModel = {
  getFechasByTourId: (tourId) => {
    return db.promise().query('SELECT * FROM tour_fechas_disponibles WHERE tour_id = ?', [tourId]);
  },

  agregarFecha: (tourId, fecha, cupoMaximo) => {
    return db.promise().query(
      'INSERT INTO tour_fechas_disponibles (tour_id, fecha, cupo_maximo) VALUES (?, ?, ?)',
      [tourId, fecha, cupoMaximo || null]
    );
  },

  eliminarFecha: (id) => {
    return db.promise().query('DELETE FROM tour_fechas_disponibles WHERE id = ?', [id]);
  }
};

module.exports = FechasModel;
