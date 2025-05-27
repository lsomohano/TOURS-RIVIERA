const db = require('../config/db');

const TourItinerariosModel = {
  // Itinerario

  getItinerario: (tourId) => {
    return db.promise().query('SELECT * FROM tour_itinerario WHERE tour_id = ? ORDER BY paso_numero ASC', [tourId]);
  },

  createItinerarioPaso: (tourId, paso) => {
    const { paso_numero, descripcion, hora_aprox } = paso;

    const sql = `
      INSERT INTO tour_itinerario (tour_id, paso_numero, descripcion, hora_aprox)
      VALUES (?, ?, ?, ?)
    `;

    return db.promise().query(sql, [
      tourId,
      paso_numero,
      descripcion,
      hora_aprox
    ]);
  },

  updateItinerarioPaso: (id, paso) => {
    const { paso_numero, descripcion, hora_aprox } = paso;

    const sql = `
      UPDATE tour_itinerario
      SET paso_numero = ?, descripcion = ?, hora_aprox = ?
      WHERE id = ?
    `;

    return db.promise().query(sql, [
      paso_numero,
      descripcion,
      hora_aprox,
      id
    ]);
  },

  deleteItinerarioPaso: (id) => {
    return db.promise().query('DELETE FROM tour_itinerario WHERE id = ?', [id]);
  }

};

module.exports = TourItinerariosModel;