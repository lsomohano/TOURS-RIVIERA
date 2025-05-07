const mysql = require('mysql2');

const db = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

// Verificación de conexión (opcional, pero correcta)
db.getConnection((err, connection) => {
  if (err) {
    console.error('Error al conectar a la BD:', err);
  } else {
    console.log('Conectado a la base de datos');
    connection.release(); // liberar conexión
  }
});

module.exports = db;
