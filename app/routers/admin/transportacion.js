const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../../middlewares/auth');
const controller = require('../../controllers/admin/transportacionController');

// CRUD
router.get('/', requireAdmin, controller.listarTransportaciones);
router.get('/new', requireAdmin, controller.formNueva);
router.post('/create', requireAdmin, controller.crear);
router.get('/:id/edit', requireAdmin, controller.formEditar);
router.post('/:id/update', requireAdmin, controller.actualizar);
router.post('/:id/delete', requireAdmin, controller.eliminar);

module.exports = router;
