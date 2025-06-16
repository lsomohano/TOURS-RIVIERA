const express = require('express');
const router = express.Router();
const zonesCtrl = require('../../controllers/admin/zonesController');
const { requireAdmin } = require('../../middlewares/auth');

router.get('/',requireAdmin, zonesCtrl.list);
router.get('/new', requireAdmin, zonesCtrl.showForm);
router.get('/:id/edit', requireAdmin, zonesCtrl.showForm);
router.post('/save', requireAdmin, zonesCtrl.save);
router.get('/:id/delete', requireAdmin, zonesCtrl.delete);

module.exports = router;
