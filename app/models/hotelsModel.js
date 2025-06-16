const db = require('../config/db'); // conexión MySQL

const Hotel = {
  async findAll() {
    const [rows] = await db.promise().query('SELECT * FROM hotels ORDER BY name');
    return rows;
  },

  async findById(id) {
    const [rows] = await db.promise().query('SELECT * FROM hotels WHERE id = ?', [id]);
    return rows[0];
  },

  async create({ name, zone_id, latitude, longitude }) {
    const [result] = await db.promise().query(
      'INSERT INTO hotels (name, zone_id, latitude, longitude) VALUES (?, ?, ?, ?)',
      [name, zone, latitude, longitude]
    );
    return result.insertId;
  },

  async update(id, { name, zone_id, latitude, longitude }) {
    await db.promise().query(
      'UPDATE hotels SET name = ?, zone_id = ?, latitude = ?, longitude = ? WHERE id = ?',
      [name, zone, latitude, longitude, id]
    );
  },

  async delete(id) {
    await db.promise().query('DELETE FROM hotels WHERE id = ?', [id]);
  }
};

module.exports = Hotel;
