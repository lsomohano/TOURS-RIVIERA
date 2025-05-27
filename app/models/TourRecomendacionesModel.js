const db = require('../config/db');

const TourRecomendacionesModel = {
    // Detalles
    getRecomendaciones: (tourId) => {
        return db.promise().query('SELECT * FROM tour_recomendaciones WHERE tour_id = ? ORDER BY FIELD(momento, "antes", "durante", "despues")', [tourId]);
    },
    agregarRecomendacion: (tourId, momento, recomendacion) => {
        return db.promise().query(
            "INSERT INTO tour_recomendaciones (tour_id, momento, recomendacion) VALUES (?, ?, ?)",
            [tourId, momento, recomendacion]
        );
    },
    eliminarRecomendacion: (id) => {
        return db.promise().query("DELETE FROM tour_recomendaciones WHERE id = ?", [id]);
    }
    
};

module.exports = TourRecomendacionesModel;