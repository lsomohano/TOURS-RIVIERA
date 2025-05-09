const db = require('../config/db');

const TourExtrasModel = {
  getDetalles: (tourId) => {
    return db.promise().query('SELECT * FROM tour_detalles WHERE tour_id = ?', [tourId]);
  },

  getImagenes: (tourId) => {
    return db.promise().query('SELECT * FROM tour_imagenes WHERE tour_id = ? ORDER BY orden', [tourId]);
  },

  getFechasDisponibles: (tourId) => {
    return db.promise().query('SELECT * FROM tour_fechas_disponibles WHERE tour_id = ? ORDER BY fecha', [tourId]);
  },

  getPuntoEncuentro: (tourId) => {
    return db.promise().query('SELECT * FROM tour_puntos_encuentro WHERE tour_id = ?', [tourId]);
  },

  getPoliticas: (tourId) => {
    return db.promise().query('SELECT * FROM tour_politicas_cancelacion WHERE tour_id = ?', [tourId]);
  },

  getItinerario: (tourId) => {
    return db.promise().query('SELECT * FROM tour_itinerario WHERE tour_id = ? ORDER BY paso_numero', [tourId]);
  },

  getRecomendaciones: (tourId) => {
    return db.promise().query('SELECT * FROM tour_recomendaciones WHERE tour_id = ? ORDER BY FIELD(momento, "antes", "durante", "despues")', [tourId]);
  }
};

module.exports = TourExtrasModel;