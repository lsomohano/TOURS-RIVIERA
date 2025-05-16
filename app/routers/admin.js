const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../middlewares/auth');
const pool = require('../config/db');

router.get('/admin', requireAdmin, (req, res) => {
  pool.getConnection((err, conn) => {
    if (err) {
      console.error('Error al obtener conexión:', err);
      return res.status(500).send('Error de conexión a la base de datos');
    }

    conn.query('SELECT id, nombre, email, rol FROM usuarios', (err, results) => {
      conn.release(); // liberar conexión

      if (err) {
        console.error('Error en la consulta:', err);
        return res.status(500).send('Error al consultar usuarios');
      }

      res.render('admin/usuarios', { usuarios: results });
    });
  });
});

module.exports = router;
