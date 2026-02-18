const ReportService = require('../services/reportService');

class ReportController {
  // Create new report
  static createReport(req, res) {
    try {
      const userId = req.user.id; // From auth middleware
      const result = ReportService.createReport(userId, req.body);
      res.status(201).json({ success: true, ...result });
    } catch (error) {
      console.error('Create report error:', error);
      res.status(error.status || 500).json({
        success: false,
        message: error.message || 'Failed to create report'
      });
    }
  }

  // Get user's reports
 static getUserReports(req, res) {
  try {
    const userId = req.user.id; // Use test user ID
      const result = ReportService.getUserReports(userId);
      res.status(200).json({ success: true, ...result });
    } catch (error) {
      console.error('Get reports error:', error);
      res.status(error.status || 500).json({
        success: false,
        message: error.message || 'Failed to get reports'
      });
    }
  }

  // Get single report
  static getReportById(req, res) {
    try {
      const userId = req.user.id;
      const reportId = parseInt(req.params.id);
      const result = ReportService.getReportById(reportId, userId);
      res.status(200).json({ success: true, ...result });
    } catch (error) {
      console.error('Get report error:', error);
      res.status(error.status || 500).json({
        success: false,
        message: error.message || 'Failed to get report'
      });
    }
  }

  // Get user statistics
static getUserStats(req, res) {
  try {
    const userId = req.user.id; // Use test user ID
      const result = ReportService.getUserStats(userId);
      res.status(200).json({ success: true, ...result });
    } catch (error) {
      console.error('Get stats error:', error);
      res.status(error.status || 500).json({
        success: false,
        message: error.message || 'Failed to get statistics'
      });
    }
  }
}

module.exports = ReportController;