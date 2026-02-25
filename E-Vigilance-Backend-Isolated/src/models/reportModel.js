const storage = require('../data/storage');

class ReportModel {
  // Create new report
  static createReport(reportData) {
    const newReport = {
      id: storage.nextReportId++,
      userId: reportData.userId,
      evidencePath: reportData.evidencePath || null,
      vehicleType: reportData.vehicleType,
      vehicleNumber: reportData.vehicleNumber,
      vehicleModel: reportData.vehicleModel || null,
      dateTime: reportData.dateTime,
      issueType: reportData.issueType,
      location: reportData.location,
      latitude: reportData.latitude || null,       
      longitude: reportData.longitude || null, 
      additionalDetails: reportData.additionalDetails || null,
      status: 'In Progress', // Default status
      createdAt: new Date().toISOString()
    };
    
    storage.reports.push(newReport);
    return newReport;
  }

  // Get all reports for a user
  static getUserReports(userId) {
    return storage.reports
      .filter(report => report.userId === userId)
      .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  }

  // Get single report by ID
  static getReportById(reportId) {
    return storage.reports.find(report => report.id === reportId);
  }

  // Get user statistics
  static getUserStats(userId) {
    const userReports = storage.reports.filter(r => r.userId === userId);
    
    return {
      total: userReports.length,
      completed: userReports.filter(r => r.status === 'Completed').length,
      inProgress: userReports.filter(r => r.status === 'In Progress').length,
      rejected: userReports.filter(r => r.status === 'Rejected').length
    };
  }

  // Update report status (for testing)
  static updateStatus(reportId, status) {
    const report = storage.reports.find(r => r.id === reportId);
    if (report) {
      report.status = status;
      return report;
    }
    return null;
  }
}

module.exports = ReportModel;