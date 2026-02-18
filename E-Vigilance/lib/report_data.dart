class ReportData {
  String? evidencePath; // photo / video path
  String? vehicleType;
  String? vehicleNumber;
  String? vehicleModel;
  DateTime? dateTime;
  String? issueType;
  String? location; // later you can use LatLng instead
  String? additionalDetails;

  ReportData({
    this.evidencePath,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleModel,
    this.dateTime,
    this.issueType,
    this.location,
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
  additionalDetails: $additionalDetails,
)
''';
  }
}
