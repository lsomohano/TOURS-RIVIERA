// controllers/indexController.js
const db = require('../config/db'); // Conexión a la base de datos

exports.legalPP = (req, res) => {
    res.render('politica-privacidad', {
        locale: req.getLocale(),
        currentUrl: req.originalUrl
    });
};

exports.legalTC = (req, res) => {
    res.render('terminos-condiciones', {
        locale: req.getLocale(),
        currentUrl: req.originalUrl
    });
};