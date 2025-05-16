const Usuario = require('../models/usuarioModel');

async function mostrarLogin(req, res) {
  res.render('login', { error: null });
}

async function procesarLogin(req, res) {
  const { email, password } = req.body;
  const usuario = await Usuario.findByEmail(email);

  if (!usuario) {
    return res.render('login', { error: 'Credenciales inválidas' });
  }

  const valido = await Usuario.comparePassword(password, usuario.password);
  if (!valido) {
    return res.render('login', { error: 'Credenciales inválidas' });
  }

  req.session.usuario = {
    id: usuario.id,
    nombre: usuario.nombre,
    rol: usuario.rol
  };

  res.redirect('/admin');
}

module.exports = { mostrarLogin, procesarLogin };
