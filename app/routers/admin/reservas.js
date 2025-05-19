const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../../middlewares/auth');
const reservasController = require('../../controllers/admin/reservasController');


router.get('/', requireAdmin, reservasController.listarReservas);

module.exports = router;
