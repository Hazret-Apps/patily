class ReportedPetModel {
  final String? imagePath;
  final String description;
  final String phoneNumber;
  final bool adopt;
  final String lat;
  final String long;
  final String currentEmail;
  final String currentUid;
  final String currentName;

  ReportedPetModel({
    this.imagePath,
    required this.description,
    required this.phoneNumber,
    required this.adopt,
    required this.long,
    required this.currentEmail,
    required this.currentUid,
    required this.currentName,
    required this.lat,
  });
}
