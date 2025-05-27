const db = require('../config/db'); // o tu conector a MySQL

const PuntoEncuentro = {
  getPuntoEncuentro: (tourId) => {
    return db.promise().query('SELECT * FROM tour_puntos_encuentro WHERE tour_id = ?', [tourId]);
  },

  crear: ({ tour_id, direccion, coordenadas, hora }) => {
    return db.promise().query(
      `INSERT INTO tour_puntos_encuentro (tour_id, direccion, coordenadas, hora)
       VALUES (?, ?, ?, ?)`,
      [tour_id, direccion, coordenadas, hora]
    );
    //return result.insertId;
  },

  eliminar: (id) => {
    return db.promise().query(
      `DELETE FROM tour_puntos_encuentro WHERE id = ?`,
      [id]
    );
    //return result.affectedRows;
  },

  listarPorTour: async (tour_id) => {
  return db.promise().query(
    `SELECT * FROM tour_puntos_encuentro WHERE tour_id = ? ORDER BY hora`,
    [tour_id]
  );
  //return rows;
}
};

module.exports = PuntoEncuentro;
