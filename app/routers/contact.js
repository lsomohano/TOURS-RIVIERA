// routes/contac.js
const express = require('express');
const router = express.Router();
const contactController = require('../controllers/contactController');

router.get('/contact', contactController.index);
router.post('/contact', contactController.sendMessage);

module.exports = router;