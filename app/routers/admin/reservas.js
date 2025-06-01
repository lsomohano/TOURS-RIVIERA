const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../../middlewares/auth');
const reservasController = require('../../controllers/admin/reservasController');


router.get('/', requireAdmin, reservasController.listarReservas);
router.get('/new', requireAdmin, reservasController.MostrarFormulario);
router.post('/create', requireAdmin, reservasController.crearReservacion);
router.get('/:id/edit', requireAdmin, reservasController.editarVista);
router.post('/:id/edit', requireAdmin, reservasController.editarGuardar);
module.exports = router;
