const express = require('express');
const router = express.Router();
const transportController = require('../controllers/transportController');

// GET: Mostrar el formulario
router.get('/transportacion', transportController.formulario);

// POST: Procesar formulario
router.post('/transportacion', transportController.procesarReservacion);

module.exports = router;