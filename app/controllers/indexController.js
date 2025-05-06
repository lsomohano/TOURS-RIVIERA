// controllers/indexController.js
const TourModel = require('../models/TourModel');

exports.index = async (req, res) => {
  try {
    const [tours] = await TourModel.getAll();
    res.render('index', {
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
      locale: req.getLocale(),
      currentUrl: req.originalUrl
    });
  });
};*/