const db = require('../config/db');

const TourModel = {
  getAll: (idioma = 'en') => {
    return db.promise().query('SELECT * FROM tours WHERE idioma = ?', [idioma]);
  },

  getById: (id) => {
    return db.promise().query('SELECT * FROM tours WHERE id = ?', [id]);
  },

  // Si necesitas crear, actualizar o eliminar tours:
  create: (data) => {
    const { nombre, descripcion, precio } = data;
    return db.promise().query(
      'INSERT INTO tours (nombre, descripcion, precio) VALUES (?, ?, ?)',
      [nombre, descripcion, precio]
    );
  }
};

module.exports = TourModel;