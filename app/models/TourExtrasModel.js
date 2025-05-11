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
  },

  getPreciosPorPersonas: (tourId) => {
    return db.promise().query(
      'SELECT personas_max, precio_base FROM tour_precios_privados WHERE tour_id = ? ',
      [tourId]
    );
  },

  getPreciosPrivadosCalculados: async (tourId) => {
    const [rows] = await db.promise().query(`
      SELECT personas_max, precio_base, incremento_pct, aplica_desde
      FROM tour_precios_privados
      WHERE tour_id = ? AND activo = 1
    `, [tourId]);

    const resultados = [];

    rows.forEach(row => {
      const precioBase = Number(row.precio_base);
      const incrementoPct = Number(row.incremento_pct);
      const aplicaDesde = Number(row.aplica_desde);
      const personasMax = Number(row.personas_max);

      for (let i = 1; i <= personasMax; i++) {
        let total = 0;

        if (i <= aplicaDesde) {
          total = precioBase;
        } else {
          total = precioBase + (precioBase * incrementoPct / 100 * (i - aplicaDesde));
        }

        resultados.push({
          personas: i,
          precio_total: Number(total.toFixed(2)),
          precio_por_persona: Number((total / i).toFixed(2))
        });
      }
    });

    return resultados;
  }
  
};

module.exports = TourExtrasModel;