const db = require('../config/db');

const PrecioPrivado = {
  obtenerPorTour: async (tour_id) => {
    const [rows] = await db.promise().query(
      'SELECT * FROM tour_precios_privados WHERE tour_id = ? LIMIT 1',
      [tour_id]
    );
    return rows[0] || null;
  },

  guardar: async (tour_id, datos) => {
    const existente = await PrecioPrivado.obtenerPorTour(tour_id);

    if (existente) {
      // UPDATE
      await db.promise().query(
        `UPDATE tour_precios_privados 
         SET personas_max = ?, precio_base = ?, incremento_pct = ?, aplica_desde = ?, activo = ? 
         WHERE tour_id = ?`,
        [
          datos.personas_max,
          datos.precio_base,
          datos.incremento_pct || null,
          datos.aplica_desde || null,
          datos.activo ? 1 : 0,
          tour_id
        ]
      );
    } else {
      // INSERT
      await db.promise().query(
        `INSERT INTO tour_precios_privados 
         (tour_id, personas_max, precio_base, incremento_pct, aplica_desde, activo)
         VALUES (?, ?, ?, ?, ?, ?)`,
        [
          tour_id,
          datos.personas_max,
          datos.precio_base,
          datos.incremento_pct || null,
          datos.aplica_desde || null,
          datos.activo ? 1 : 0
        ]
      );
    }
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

module.exports = PrecioPrivado;
