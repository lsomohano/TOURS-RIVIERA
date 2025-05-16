const db = require('../config/db');
const bcrypt = require('bcrypt');

function findByEmail(email) {
  return new Promise((resolve, reject) => {
    db.query('SELECT * FROM usuarios WHERE email = ?', [email], (err, results) => {
      if (err) return reject(err);
      resolve(results[0]);
    });
  });
}

async function comparePassword(password, hash) {
  return bcrypt.compare(password, hash);
}

module.exports = { findByEmail, comparePassword };
