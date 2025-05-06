// Página principal que muestra los tours
//const db = require('../config/db'); // Conexión a la base de datos
const TourModel = require('../models/TourModel');


exports.index = async (req, res) => {
    try {
      const [tours] = await TourModel.getAll();
      res.render('tours', {
        tours,
        locale: req.getLocale(),
        currentUrl: req.originalUrl
      });
    } catch (err) {
      console.error('Error al obtener tours:', err);
      res.status(500).send('Error interno');
    }
};

/*exports.index = (req, res) => {
    const sql = 'SELECT * FROM tours';
    db.query(sql, (err, results) => {
      if (err) return res.status(500).send("Error en la base de datos");
  
      res.render('index', {
        tours: results,
        locale: req.getLocale(), // Pas el idioma actual a la vista
        currentUrl: req.originalUrl // Pasa la URL original al frontend
      });
    });
};*/
  