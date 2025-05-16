const { Usuario } = require('../models');

exports.mostrarUsuarios = async (req, res) => {
  const usuarios = await Usuario.findAll();
  res.render('admin/usuarios', { usuarios });
};