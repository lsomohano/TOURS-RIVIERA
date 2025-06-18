const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../../middlewares/auth');
const transferRatesController = require('../../controllers/admin/transferRatesController');

router.get('/', requireAdmin, transferRatesController.list); // listar tarifas
router.get('/new', requireAdmin, transferRatesController.form); // mostrar formulario nuevo
router.post('/create', requireAdmin, transferRatesController.create); // guardar nueva tarifa
router.get('/:id/edit', requireAdmin, transferRatesController.edit); // mostrar formulario edición
router.post('/:id/update', requireAdmin, transferRatesController.update); // actualizar tarifa
router.get('/:id/delete', requireAdmin, transferRatesController.delete); // eliminar tarifa

module.exports = router;
