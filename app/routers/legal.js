const express = require('express');
const router = express.Router();
const legalController = require('../controllers/legalController');

router.get('/politica-privacidad', legalController.legalPP);
router.get('/terminos-condiciones', legalController.legalTC);

module.exports = router;