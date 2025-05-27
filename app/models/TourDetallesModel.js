const db = require('../config/db');

const TourDetallesModel = {
  // Detalles

    getDetalles: (tourId) => {
        return db.promise().query('SELECT * FROM tour_detalles WHERE tour_id = ?', [tourId]);
    },
    createDetalles: (tourId, data) => {
        const {
        duracion,
        lenguaje,
        incluye,
        no_incluye,
        porque_hacerlo,
        que_esperar,
        recomendaciones
        } = data;

        const sql = `
        INSERT INTO tour_detalles
        (tour_id, duracion, lenguaje, incluye, no_incluye, porque_hacerlo, que_esperar, recomendaciones)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `;

        return db.promise().query(sql, [
        tourId,
        duracion,
        lenguaje,
        incluye,
        no_incluye,
        porque_hacerlo,
        que_esperar,
        recomendaciones
        ]);
    },

    updateDetalles: (tourId, data) => {
        const {
        duracion,
        lenguaje,
        incluye,
        no_incluye,
        porque_hacerlo,
        que_esperar,
        recomendaciones
        } = data;

        const sql = `
        UPDATE tour_detalles
        SET duracion = ?, lenguaje = ?, incluye = ?, no_incluye = ?, porque_hacerlo = ?, que_esperar = ?, recomendaciones = ?
        WHERE tour_id = ?
        `;

        return db.promise().query(sql, [
        duracion,
        lenguaje,
        incluye,
        no_incluye,
        porque_hacerlo,
        que_esperar,
        recomendaciones,
        tourId
        ]);
    },

  
};

module.exports = TourDetallesModel;