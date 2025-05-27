const db = require('../config/db');

const TourImagenesModel = {
    // Detalles
    getImagenes: (tourId) => {
        return db.promise().query('SELECT * FROM tour_imagenes WHERE tour_id = ? ORDER BY orden', [tourId]);
    },
    crear: async (tourId, url_imagen, descripcion) => {
        const sql = `
        INSERT INTO tour_imagenes (tour_id, url_imagen, descripcion)
        VALUES (?, ?, ?)
        `;
        return db.promise().query(sql, [tourId, url_imagen, descripcion]);
    },
    eliminar: async (id) => {
        const sql = `
        DELETE FROM tour_imagenes
        WHERE id = ?
        `;
        return db.promise().query(sql, [id]);
    },
    obtenerPorId: async (id) => {
        const sql = `SELECT * FROM tour_imagenes WHERE id = ?`;
        const [rows] = await db.promise().query(sql, [id]);
        return rows[0];
    },
};

module.exports = TourImagenesModel;