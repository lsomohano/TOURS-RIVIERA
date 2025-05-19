const Usuario = require('../models/usuarioModel');

async function mostrarLogin(req, res) {
  res.render(
    'login', { 
      title: 'Iniciar sesión', 
      layout: 'layouts/login',
      error: null 
    });
}

async function procesarLogin(req, res) {
  console.log('Procesando login para:', req.body.email);
  const usuario = await Usuario.findByEmail(req.body.email);
  if (!usuario) {
    console.log('Usuario no encontrado');
    return res.render('login', { title: 'Iniciar sesión', layout: 'layouts/login', error: 'Credenciales inválidas' });
  }

  const valido = await Usuario.comparePassword(req.body.password, usuario.password);
  if (!valido) {
    console.log('Password inválido');
    return res.render('login', { title: 'Iniciar sesión', layout: 'layouts/login', error: 'Credenciales inválidas' });
  }

  req.session.usuario = {
    id: usuario.id,
    nombre: usuario.nombre,
    rol: usuario.rol
  };
  console.log('Login exitoso, redirigiendo...');
  return res.redirect('/admin');
}

async function logout(req, res) {
  req.session.destroy(err => {
    if (err) {
      console.error('Error cerrando sesión:', err);
      return res.status(500).send('Error al cerrar sesión');
    }
    res.redirect('/login'); // Redirige después de cerrar sesión
  });
}

module.exports = { mostrarLogin, procesarLogin, logout };
