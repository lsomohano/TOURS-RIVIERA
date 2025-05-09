const express = require('express');
const router = express.Router();
const toursController = require('../controllers/toursController');

// Ruta principal
router.get('/tours', toursController.index);
router.get('/tours/:id', toursController.detalle); // Nueva ruta

module.exports = router;