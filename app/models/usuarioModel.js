const db = require('../config/db');
const bcrypt = require('bcrypt');

function crearUsuario(nombre, email, rol, password) {
  return new Promise((resolve, reject) => {
    db.query(
    'INSERT INTO usuarios (nombre, email, rol, password) VALUES (?, ?, ?, ?)',
    [nombre, email, rol, password], (err, results) => {
      if (err) return reject(err);
      resolve(results[0]);
    });
  });
}

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

function obtenerTodos() {
  return new Promise((resolve, reject) => {
    db.query('SELECT id, nombre, email, rol FROM usuarios', (err, results) => {
      if (err) return reject(err);
      resolve(results);
    });
  });
}

function findById(id) {
  return new Promise((resolve, reject) => {
    db.query('SELECT * FROM usuarios WHERE id = ?', [id], (err, results) => {
      if (err) return reject(err);
      resolve(results[0]);
    });
  });
}

function updateById(id, nombre, email, rol) {
  return new Promise((resolve, reject) => {
    db.query('UPDATE usuarios SET nombre = ?, email = ?, rol = ? WHERE id = ?', [nombre, email, rol, id], (err, result) => {
      if (err) return reject(err);
      resolve(result);
    });
  });
}

function deleteById(id) {
  return new Promise((resolve, reject) => {
    db.query('DELETE FROM usuarios WHERE id = ?', [id], (err, result) => {
      if (err) return reject(err);
      resolve(result);
    });
  });
}

module.exports = {
  crearUsuario,
  findByEmail,
  comparePassword,
  obtenerTodos,
  findById,
  updateById,
  deleteById
};
