// In-memory data storage (replaces database)

const storage = {
  users: [
    // Example user (for testing)
    {
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      nic: '123456789V',
      password: '$2a$10$YourHashedPasswordHere', // "test123" hashed
      role: 'citizen',
      createdAt: new Date().toISOString()
    }
  ],
  
  reports: [
    // Example report (for testing)
    {
      id: 1,
      userId: 1,
      evidencePath: null,
      vehicleType: 'Car',
      vehicleNumber: 'ABC-1234',
      vehicleModel: 'Toyota',
      dateTime: new Date().toISOString(),
      issueType: 'A vehicle was parked illegally',
      location: 'Colombo, Sri Lanka',
      additionalDetails: 'Test report',
      status: 'In Progress',
      createdAt: new Date().toISOString()
    }
  ],
  
  // Auto-increment IDs
  nextUserId: 2,
  nextReportId: 2
};

module.exports = storage;