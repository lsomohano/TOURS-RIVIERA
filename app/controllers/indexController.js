const TourModel = require('../models/TourModel');

exports.index = async (req, res) => {
  try {
    const idioma = ['es', 'en'].includes(req.getLocale()) ? req.getLocale() : 'en'; // i18n debe estar bien configurado para esto
    const [tours] = await TourModel.getAll(idioma);
    res.render('index', {
      tours,
      locale: idioma,
      currentUrl: req.originalUrl
    });
  } catch (err) {
    console.error('Error al obtener tours:', err);
    res.status(500).send('Error interno');
  }
};