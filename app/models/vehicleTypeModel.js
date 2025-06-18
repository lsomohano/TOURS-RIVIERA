const db = require('../config/db');

const VehicleType = {
  async findAll() {
    const [rows] = await db.promise().query('SELECT * FROM vehicle_types ORDER BY pax_min');
    return rows;
  },

  async findById(id) {
    const [rows] = await db.promise().query('SELECT * FROM vehicle_types WHERE id = ?', [id]);
    return rows[0];
  },

  async create({ name, pax_min, pax_max }) {
    const [result] = await db.promise().query(
      'INSERT INTO vehicle_types (name, pax_min, pax_max) VALUES (?, ?, ?)',
      [name, pax_min, pax_max]
    );
    return result.insertId;
  },

  async update(id, { name, pax_min, pax_max }) {
    await db.promise().query(
      'UPDATE vehicle_types SET name = ?, pax_min = ?, pax_max = ? WHERE id = ?',
      [name, pax_min, pax_max, id]
    );
  },

  async delete(id) {
    await db.promise().query('DELETE FROM vehicle_types WHERE id = ?', [id]);
  }
};

module.exports = VehicleType;
