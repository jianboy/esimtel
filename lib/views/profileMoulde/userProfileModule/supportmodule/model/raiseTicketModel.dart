class RaiseTicketModel {
  bool? success;
  Data? data;
  String? message;

  RaiseTicketModel({this.success, this.data, this.message});

  factory RaiseTicketModel.fromJson(Map<String, dynamic> json) =>
      RaiseTicketModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  int? userId;
  String? subject;
  String? status;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  List<Message>? nmessages;

  Data({
    this.userId,
    this.subject,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.nmessages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    subject: json["subject"],
    status: json["status"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
    nmessages: json["messages"] == null
        ? []
        : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "subject": subject,
    "status": status,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
    "messages": nmessages == null
        ? []
        : List<dynamic>.from(nmessages!.map((x) => x.toJson())),
  };
}

class Message {
  int? id;
  int? supportTicketId;
  int? userId;
  String? message;
  String? senderType;
  int? isRead;
  DateTime? createdAt;
  DateTime? updatedAt;

  Message({
    this.id,
    this.supportTicketId,
    this.userId,
    this.message,
    this.senderType,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    supportTicketId: json["support_ticket_id"],
    userId: json["user_id"],
    message: json["message"],
    senderType: json["sender_type"],
    isRead: json["is_read"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "support_ticket_id": supportTicketId,
    "user_id": userId,
    "message": message,
    "sender_type": senderType,
    "is_read": isRead,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
