const express = require('express');
const router = express.Router();
const reservarController = require('../controllers/reservarController');

router.get('/reservar/:id', reservarController.getReserva);
router.post('/reservar', reservarController.postReserva);
router.get('/reservar_success', reservarController.reservaSuccess);
router.get('/reservar_cancel', reservarController.reservaCancel);
router.get('/reservar_instrucciones', reservarController.getInstruccionesPago);

// Mostrar formulario de pago
router.get('/reservar/pagar/:token', reservarController.getInstruccionesPagoToken);
router.post('/reservar/pagar/:token', reservarController.mostrarPagoConStripe);
module.exports = router;