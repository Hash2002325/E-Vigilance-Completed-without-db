const ReportModel = require('../models/reportModel');

class ReportService {
  // Create new report
  static createReport(userId, reportData) {
    console.log('📍 RECEIVED REPORT DATA:', JSON.stringify(reportData, null, 2));
    const {
      evidencePath,
      vehicleType,
      vehicleNumber,
      vehicleModel,
      dateTime,
      issueType,
      location,
      latitude,        
      longitude, 
      additionalDetails
    } = reportData;

    // Validation
    // Validation
if (!vehicleType || !vehicleNumber || !dateTime || !issueType) {
  throw { status: 400, message: 'Required fields: vehicleType, vehicleNumber, dateTime, issueType' };
}

    const report = ReportModel.createReport({
      userId,
      evidencePath,
      vehicleType,
      vehicleNumber,
      vehicleModel,
      dateTime,
      issueType,
      location,
      latitude,        
      longitude,
      additionalDetails
    });

    return {
      message: 'Report created successfully',
      report
    };
  }

  // Get user's reports
  static getUserReports(userId) {
    const reports = ReportModel.getUserReports(userId);
    return {
      message: 'Reports retrieved successfully',
      count: reports.length,
      reports
    };
  }

  // Get single report
  static getReportById(reportId, userId) {
    const report = ReportModel.getReportById(reportId);
    
    if (!report) {
      throw { status: 404, message: 'Report not found' };
    }

    // Check if report belongs to user
    if (report.userId !== userId) {
      throw { status: 403, message: 'Access denied' };
    }

    return {
      message: 'Report retrieved successfully',
      report
    };
  }

  // Get user statistics
  static getUserStats(userId) {
    const stats = ReportModel.getUserStats(userId);
    return {
      message: 'Statistics retrieved successfully',
      stats
    };
  }
}

module.exports = ReportService;