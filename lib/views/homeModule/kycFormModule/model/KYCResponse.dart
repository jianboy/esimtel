class KYCResponse {
  final bool success;
  final KYCData data;
  final String message;

  KYCResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory KYCResponse.fromJson(Map<String, dynamic> json) {
    return KYCResponse(
      success: json['success'],
      data: KYCData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class KYCData {
  final int userId;
  final String fullName;
  final String dob;
  final String address;
  final String identityCard;
  final String pancard;
  final String photo;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  KYCData({
    required this.userId,
    required this.fullName,
    required this.dob,
    required this.address,
    required this.identityCard,
    required this.pancard,
    required this.photo,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory KYCData.fromJson(Map<String, dynamic> json) {
    return KYCData(
      userId: json['user_id'],
      fullName: json['full_name'],
      dob: json['dob'],
      address: json['address'],
      identityCard: json['identity_card'],
      pancard: json['pancard'],
      photo: json['photo'],
      status: json['status'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
    );
  }
}
