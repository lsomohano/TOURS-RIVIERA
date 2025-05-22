const db = require('../config/db');

const TourModel = {
  create: (data) => {
    const sql = `
      INSERT INTO tours (
        nombre, descripcion, lugar_salida, lugar_destino, duracion,
        cupo_maximo, precio, tipo, modalidad, idioma,
        fecha_inicio, fecha_fin, disponible, publicado, imagen_destacada
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const values = [
      data.nombre,
      data.descripcion,
      data.lugar_salida,
      data.lugar_destino,
      data.duracion,
      data.cupo_maximo,
      data.precio,
      data.tipo,
      data.modalidad,
      data.idioma,
      data.fecha_inicio,
      data.fecha_fin,
      data.disponible,
      data.publicado,
      data.imagen_destacada
    ];

    return db.promise().query(sql, values);
  },
  update: (id, datos) => {
    return db.promise().query('UPDATE tours SET ? WHERE id = ?', [datos, id]);
  },
  getAllAdmin: () => {
    return db.promise().query('SELECT * FROM tours');
  },

  getAll: (idioma = 'en') => {
    return db.promise().query('SELECT * FROM tours WHERE idioma = ?', [idioma]);
  },

  getById: (id) => {
    return db.promise().query('SELECT * FROM tours WHERE id = ?', [id]);
  },
  getFiltered: (filters, idioma = 'es') => {
    const { nombre, precio, duracion, tipo } = filters;

    let where = 'WHERE idioma = ?';
    const params = [idioma];

    if (nombre) {
      where += ' AND nombre LIKE ?';
      params.push(`%${nombre}%`);
    }

    if (precio) {
      if (precio === '1') {
        where += ' AND precio < ?';
        params.push(500);
      } else if (precio === '2') {
        where += ' AND precio BETWEEN ? AND ?';
        params.push(500, 1000);
      } else if (precio === '3') {
        where += ' AND precio > ?';
        params.push(1000);
      }
    }

    if (duracion) {
      if (duracion === 'corto') {
        where += ' AND duracion BETWEEN ? AND ?';
        params.push(1, 3);
      } else if (duracion === 'medio') {
        where += ' AND duracion BETWEEN ? AND ?';
        params.push(4, 8);
      } else if (duracion === 'largo') {
        where += ' AND duracion > ?';
        params.push(8);
      }
    }

    if (tipo) {
      where += ' AND tipo = ?';
      params.push(tipo);
    }

    const query = `SELECT * FROM tours ${where} ORDER BY nombre ASC`;

    // Asegúrate de que devuelves el array de resultados correctamente.
    return db.promise().query(query, params).then(([rows]) => rows);
  },

  getPaginated: (filters = {}, page = 1, limit = 9, idioma = 'en') => {
    // Asegúrate de que los valores de page y limit son números válidos y positivos
    page = Math.max(1, parseInt(page)); // Si page es menor que 1, lo ajustamos a 1
    limit = Math.max(1, parseInt(limit)); // Si limit es menor que 1, lo ajustamos a 1
    const offset = (page - 1) * limit;

    let where = 'WHERE idioma = ?';
    const params = [idioma];

    // Filtro por nombre
    if (filters.nombre) {
        where += ' AND nombre LIKE ?';
        params.push(`%${filters.nombre}%`);
    }

    // Filtro por precio
    if (filters.precio) {
        if (filters.precio === '1') {
            where += ' AND precio < ?';
            params.push(500);
        } else if (filters.precio === '2') {
            where += ' AND precio BETWEEN ? AND ?';
            params.push(500, 1000);
        } else if (filters.precio === '3') {
            where += ' AND precio > ?';
            params.push(1000);
        }
    }

    // Filtro por duración
    if (filters.duracion) {
        if (filters.duracion === 'corto') {
            where += ' AND duracion BETWEEN ? AND ?';
            params.push(1, 3);
        } else if (filters.duracion === 'medio') {
            where += ' AND duracion BETWEEN ? AND ?';
            params.push(4, 8);
        } else if (filters.duracion === 'largo') {
            where += ' AND duracion > ?';
            params.push(8);
        }
    }

    // Filtro por tipo
    if (filters.tipo) {
        where += ' AND tipo = ?';
        params.push(filters.tipo);
    }

    // Filtro por modalidad
    if (filters.modalidad) {
      where += ' AND modalidad = ?';
      params.push(filters.modalidad);
    }

    // Construir la consulta final
    const query = `SELECT * FROM tours ${where} ORDER BY nombre ASC LIMIT ? OFFSET ?`;
    params.push(limit, offset);

    // Depuración de la consulta SQL generada
    console.log('SQL Query:', query);  // Imprime la consulta
    console.log('Params:', params);    // Imprime los parámetros

    // Ejecutar la consulta
    return db.promise().query(query, params);
  },

  getCount: (filters = {}, idioma = 'en') => {
    let where = 'WHERE idioma = ?';
    const params = [idioma];

    if (filters.nombre) {
      where += ' AND nombre LIKE ?';
      params.push(`%${filters.nombre}%`);
    }
    // Repite misma lógica de arriba para precio, duracion y tipo...

    const query = `SELECT COUNT(*) AS total FROM tours ${where}`;
    return db.promise().query(query, params);
  }
};

module.exports = TourModel;