const db = require('../config/db');

const Zone = {
  async findAll() {
    const [rows] = await db.promise().query('SELECT * FROM zones ORDER BY name');
    return rows;
  },
  // (opcional para CRUD completo)
  async findById(id) {
    const [rows] = await db.promise().query('SELECT * FROM zones WHERE id = ?', [id]);
    return rows[0];
  },
  async create(name) {
    const [res] = await db.promise().query('INSERT INTO zones (name) VALUES (?)', [name]);
    return res.insertId;
  },
  async update(id, name) {
    await db.promise().query('UPDATE zones SET name = ? WHERE id = ?', [name, id]);
  },
  async delete(id) {
    await db.promise().query('DELETE FROM zones WHERE id = ?', [id]);
  }
};

module.exports = Zone;
