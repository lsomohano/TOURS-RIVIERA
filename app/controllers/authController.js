const bcrypt = require('bcryptjs');
const Usuario = require('../models/usuarioModel');

module.exports = {
  showLogin: (req, res) => {
    res.render('login', { 
      layout: 'layouts/login',
      title: 'Iniciar sesión'
    });
  },
  login: async (req, res) => {
    const { username, password } = req.body;
    const user = await Usuario.findByUsername(username);
    
    if (user && bcrypt.compareSync(password, user.password)) {
      req.session.user = { id: user.id, username: user.username, role: user.role };
      return res.redirect('/admin');
    }
    
    res.render('login', {
      layout: 'layouts/login',
      error: 'Credenciales inválidas'
    });
  },
  logout: (req, res) => {
    req.session.destroy(() => res.redirect('/admin/login'));
  }
};