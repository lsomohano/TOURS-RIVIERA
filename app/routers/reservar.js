const express = require('express');
const router = express.Router();
const reservarController = require('../controllers/reservarController');

router.get('/reservar/:id', reservarController.getReserva);
router.post('/reservar', reservarController.postReserva);
router.get('/reservar_success', reservarController.reservaSuccess);
router.get('/reservar_cancel', reservarController.reservaCancel);

module.exports = router;