const db = require('../config/db');

// GET: muestra la página con mensaje flash si existe
exports.index = (req, res) => {
  res.render('contact', {
    locale: req.getLocale(),
    currentUrl: req.originalUrl,
    success: req.flash('success'),
    error: req.flash('error')
  });
};

// POST: guarda o procesa el mensaje, y redirige
exports.sendMessage = (req, res) => {
  const { name, email, message } = req.body;

  const sql = `
    INSERT INTO contactos (nombre, email, mensaje)
    VALUES (?, ?, ?)
  `;
  db.query(sql, [name, email, message], (err, result) => {
    if (err) {
      console.error('Error al guardar contacto:', err);
      req.flash('error', res.__('contact.saveError'));
      return res.redirect('/contact');
    }

    req.flash('success', res.__('contact.thankYou'));
    res.redirect('/contact');
  });
};