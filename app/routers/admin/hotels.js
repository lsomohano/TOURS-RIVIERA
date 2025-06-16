const express = require('express');
const router = express.Router();
const { requireAdmin } = require('../../middlewares/auth');
const hotelController = require('../../controllers/admin/hotelController');


router.get('/', requireAdmin, hotelController.list);
router.get('/new', requireAdmin, hotelController.showForm);
router.get('/:id/edit', requireAdmin, hotelController.showForm);
router.post('/save', requireAdmin, hotelController.save);
router.get('/:id/delete', requireAdmin, hotelController.delete);
router.post('/import', requireAdmin, hotelController.importarHoteles);
router.post('/importArea', requireAdmin, hotelController.importarHotelsByArea);

module.exports = router;
