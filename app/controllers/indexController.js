const TourModel = require('../models/TourModel');
const ZonesModel = require('../models/ZoneModel');

exports.index = async (req, res) => {
  try {
    const idioma = ['es', 'en'].includes(req.getLocale()) ? req.getLocale() : 'en'; // i18n debe estar bien configurado para esto
    const [tours] = await TourModel.getAll(idioma);
    const zones = await ZonesModel.findTop();
    res.render('index', {
      layout: 'layouts/dorne_home', 
      tours,
      zones,
      locale: idioma,
      currentUrl: req.originalUrl
    });
  } catch (err) {
    console.error('Error al obtener tours:', err);
    res.status(500).send('Error interno');
  }
};