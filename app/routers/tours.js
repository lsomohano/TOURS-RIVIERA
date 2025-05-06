const express = require('express');
const router = express.Router();
const tourController = require('../controllers/toursController');

// Ruta principal
router.get('/tours', tourController.index);

module.exports = router;