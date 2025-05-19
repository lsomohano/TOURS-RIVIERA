const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../../middlewares/auth');
const usuarioController = require('../../controllers/admin/usuarioController');


router.get('/', requireAdmin, usuarioController.listarUsuarios);
router.get('/new', requireAdmin, usuarioController.formNuevoUsuario);
router.post('/new', requireAdmin, usuarioController.crearUsuario);
router.get('/:id/edit', requireAdmin, usuarioController.editarUsuario);
router.post('/:id/edit', requireAdmin, usuarioController.actualizarUsuario);
router.post('/:id/delete', requireAdmin, usuarioController.eliminarUsuario);

module.exports = router;
