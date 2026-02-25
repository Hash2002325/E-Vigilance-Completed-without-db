class ReportData {
  String? evidencePath; // photo / video path
  String? vehicleType;
  String? vehicleNumber;
  String? vehicleModel;
  DateTime? dateTime;
  String? issueType;
  String? location; // text location or "Current location"
  double? latitude;  // ADD THIS
  double? longitude; // ADD THIS
  String? additionalDetails;

  ReportData({
    this.evidencePath,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleModel,
    this.dateTime,
    this.issueType,
    this.location,
    this.latitude,
    this.longitude,
    this.additionalDetails,
  });

  @override
  String toString() {
    return '''
ReportData(
  evidencePath: $evidencePath,
  vehicleType: $vehicleType,
  vehicleNumber: $vehicleNumber,
  vehicleModel: $vehicleModel,
  dateTime: $dateTime,
  issueType: $issueType,
  location: $location,
  latitude: $latitude,
  longitude: $longitude,
  additionalDetails: $additionalDetails,
)
''';
  }
}