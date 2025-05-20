const UsuarioModel = require('../models/usuarioModel');
const bcrypt = require('bcrypt');


async function mostrarDashboard(req, res) {
  try {
    res.render('admin/dashboard', {
      layout: 'layouts/admin',
      title: 'Panel de Administración',
      botones: []
    });
  } catch (err) {
    console.error('Error al obtener usuarios:', err);
    res.status(500).send('Error al obtener usuarios');
  }
}

module.exports = { 
  mostrarDashboard
};