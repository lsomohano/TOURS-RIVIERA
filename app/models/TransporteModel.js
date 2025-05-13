const db = require('../config/db');

const TransporteModel = {
  async obtenerTarifas() {
    const [rows] = await db.promise().query(`
      SELECT id, origen, destino, tipo_servicio, precio, max_pasajeros
      FROM tarifas_transporte
      WHERE activo = 1
      ORDER BY destino ASC
    `);
    return rows;
  },

  async obtenerTarifaPor({ origen, destino, tipo_servicio }) {
    const [rows] = await db.promise().query(`
      SELECT * FROM tarifas_transporte
      WHERE origen = ? AND destino = ? AND tipo_servicio = ? AND activo = 1
      LIMIT 1
    `, [origen, destino, tipo_servicio]);
    return rows[0] || null;
  },

  async obtenerDestinos() {
    const [rows] = await db.promise().query(`
        SELECT DISTINCT destino FROM tarifas_transporte
        WHERE activo = 1
        ORDER BY destino
    `);
    return rows.map(r => r.destino);
  },

  async obtenerTiposDeServicio() {
    const [rows] = await db.promise().query(`
        SHOW COLUMNS FROM tarifas_transporte LIKE 'tipo_servicio'
    `);

    if (rows.length === 0) return [];

    const enumStr = rows[0].Type; // ejemplo: "enum('privado','compartido')"

    // Extraer los valores del ENUM usando regex
    const matches = enumStr.match(/enum\((.*)\)/);
    if (!matches) return [];

    return matches[1]
        .split(',')
        .map(val => val.trim().replace(/^'|'$/g, '')); // Quita comillas
    }
};

module.exports = TransporteModel;