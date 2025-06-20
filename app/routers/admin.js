const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../middlewares/auth');
const AdminController = require('../controllers/adminController');


router.get('/admin', requireAdmin, AdminController.mostrarDashboard);
router.use('/admin/usuarios', require('./admin/usuarios'));
router.use('/admin/reservas', require('./admin/reservas'));
router.use('/admin/tours', require('./admin/tours'));
router.use('/admin/transportacion', require('./admin/transportacion'));
router.use('/admin/hotels', require('./admin/hotels'));
router.use('/admin/zones', require('./admin/zones'));
router.use('/admin/transfer-rates', require('./admin/transfer-rates'));

module.exports = router;