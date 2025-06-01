const db = require('../config/db'); // conexión mysql2

const Transportacion = {
  findAll: async () => {
    const [rows] = await db.promise().query(`
      SELECT rt.*, zt.nombre AS zona_nombre, tst.nombre AS tipo_servicio_nombre
      FROM reservas_transportacion rt
      JOIN zonas_transportacion zt ON rt.zona_id = zt.id
      JOIN tipos_servicio_transportacion tst ON rt.tipo_servicio_id = tst.id
      ORDER BY rt.created_at DESC
    `);
    return rows;
  },

  findById: async (id) => {
    const [rows] = await db.promise().query(`SELECT * FROM reservas_transportacion WHERE id = ?`, [id]);
    return rows[0];
  },

  create: async (data) => {
    const [result] = await db.promise().query(`INSERT INTO reservas_transportacion SET ?`, [data]);
    return result.insertId;
  },

  update: async (id, data) => {
    await db.promise().query(`UPDATE reservas_transportacion SET ? WHERE id = ?`, [data, id]);
  },

  delete: async (id) => {
    await db.promise().query(`DELETE FROM reservas_transportacion WHERE id = ?`, [id]);
  }
};

module.exports = Transportacion;
