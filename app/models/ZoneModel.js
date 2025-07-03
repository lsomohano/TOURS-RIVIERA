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
  },
  async findTop() {
    const [rows] = await db.promise().query('SELECT z.id, z.`name`, MIN(t.one_way_price) AS desde, z.imagen FROM zones z INNER JOIN transfer_rates t ON  t.zone_id = z.id GROUP BY z.id');
    return rows;
  }
};

module.exports = Zone;
