function requireLogin(req, res, next) {
  if (!req.session.usuario) {
    return res.redirect('/login');
  }
  next();
}

function requireAdmin(req, res, next) {
  const usuario = req.session.usuario;
  if (!usuario || usuario.rol !== 'admin') {
    req.flash('error', 'Debes iniciar sesión como administrador');
    return res.redirect('/login');
  }
  next();
}

module.exports = { requireLogin, requireAdmin };
