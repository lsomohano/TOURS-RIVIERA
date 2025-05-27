const db = require('../config/db');

const TourPoliticas = {
  obtenerPorTour: async (tour_id) => {
    const [rows] = await db.promise().query(
      'SELECT * FROM tour_politicas_cancelacion WHERE tour_id = ?',
      [tour_id]
    );
    return rows[0] || null;
  },

  guardar: async (tour_id, politicas) => {
    const existe = await TourPoliticas.obtenerPorTour(tour_id);
    if (existe) {
      await db.promise().query(
        'UPDATE tour_politicas_cancelacion SET politicas = ? WHERE tour_id = ?',
        [politicas, tour_id]
      );
    } else {
      await db.promise().query(
        'INSERT INTO tour_politicas_cancelacion (tour_id, politicas) VALUES (?, ?)',
        [tour_id, politicas]
      );
    }
  }
};

module.exports = TourPoliticas;
