const db = require('../config/db');

const TransferRate = {
  async findAll() {
    const [rows] = await db.promise().query(`
      SELECT 
        tr.id,
        z.name AS zone_name,
        vt.name AS vehicle_type,
        vt.pax_min,
        vt.pax_max,
        tr.zone_id,
        tr.vehicle_type_id,
        tr.one_way_price,
        tr.round_trip_price
      FROM transfer_rates tr
      JOIN zones z ON tr.zone_id = z.id
      JOIN vehicle_types vt ON tr.vehicle_type_id = vt.id
      ORDER BY z.name, vt.pax_min
    `);
    return rows;
  },

  async findById(id) {
    const [rows] = await db.promise().query(`
      SELECT * FROM transfer_rates WHERE id = ?
    `, [id]);
    return rows[0];
  },

  async create({ zone_id, vehicle_type_id, one_way_price, round_trip_price }) {
    const [result] = await db.promise().query(`
      INSERT INTO transfer_rates (zone_id, vehicle_type_id, one_way_price, round_trip_price)
      VALUES (?, ?, ?, ?)
    `, [zone_id, vehicle_type_id, one_way_price, round_trip_price]);
    return result.insertId;
  },

  async update(id, { zone_id, vehicle_type_id, one_way_price, round_trip_price }) {
    await db.promise().query(`
      UPDATE transfer_rates
      SET zone_id = ?, vehicle_type_id = ?, one_way_price = ?, round_trip_price = ?
      WHERE id = ?
    `, [zone_id, vehicle_type_id, one_way_price, round_trip_price, id]);
  },

  async delete(id) {
    await db.promise().query(`
      DELETE FROM transfer_rates WHERE id = ?
    `, [id]);
  }
};

module.exports = TransferRate;
