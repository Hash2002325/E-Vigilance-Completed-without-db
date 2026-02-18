const express = require('express');
const ReportController = require('../controllers/reportController');
const AuthMiddleware = require('../middlewares/authMiddleware');

const router = express.Router();

// All report routes require authentication
router.use(AuthMiddleware.verifyToken);

// Report routes
router.post('/', ReportController.createReport);
router.get('/', ReportController.getUserReports);
router.get('/stats', ReportController.getUserStats);
router.get('/:id', ReportController.getReportById);

module.exports = router;