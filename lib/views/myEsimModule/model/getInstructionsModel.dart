class ESimInstructionsModel {
  bool success;
  Data data;
  String message;

  ESimInstructionsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ESimInstructionsModel.fromJson(Map<String, dynamic> json) =>
      ESimInstructionsModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  Instructions instructions;

  Data({required this.instructions});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(instructions: Instructions.fromJson(json["instructions"]));

  Map<String, dynamic> toJson() => {"instructions": instructions.toJson()};
}

class Instructions {
  String language;
  List<Io> ios;
  List<Android> android;

  Instructions({
    required this.language,
    required this.ios,
    required this.android,
  });

  factory Instructions.fromJson(Map<String, dynamic> json) => Instructions(
    language: json["language"],
    ios: List<Io>.from(json["ios"].map((x) => Io.fromJson(x))),
    android: List<Android>.from(
      json["android"].map((x) => Android.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "language": language,
    "ios": List<dynamic>.from(ios.map((x) => x.toJson())),
    "android": List<dynamic>.from(android.map((x) => x.toJson())),
  };
}

class Android {
  dynamic model;
  dynamic version;
  InstallationViaQrCode installationViaQrCode;
  AndroidInstallationManual installationManual;
  NetworkSetup networkSetup;

  Android({
    required this.model,
    required this.version,
    required this.installationViaQrCode,
    required this.installationManual,
    required this.networkSetup,
  });

  factory Android.fromJson(Map<String, dynamic> json) => Android(
    model: json["model"],
    version: json["version"],
    installationViaQrCode: InstallationViaQrCode.fromJson(
      json["installation_via_qr_code"],
    ),
    installationManual: AndroidInstallationManual.fromJson(
      json["installation_manual"],
    ),
    networkSetup: NetworkSetup.fromJson(json["network_setup"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "version": version,
    "installation_via_qr_code": installationViaQrCode.toJson(),
    "installation_manual": installationManual.toJson(),
    "network_setup": networkSetup.toJson(),
  };
}

class AndroidInstallationManual {
  Map<String, String> steps;
  String smdpAddressAndActivationCode;

  AndroidInstallationManual({
    required this.steps,
    required this.smdpAddressAndActivationCode,
  });

  factory AndroidInstallationManual.fromJson(Map<String, dynamic> json) =>
      AndroidInstallationManual(
        steps: Map.from(
          json["steps"],
        ).map((k, v) => MapEntry<String, String>(k, v)),
        smdpAddressAndActivationCode: json["smdp_address_and_activation_code"],
      );

  Map<String, dynamic> toJson() => {
    "steps": Map.from(steps).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "smdp_address_and_activation_code": smdpAddressAndActivationCode,
  };
}

class InstallationViaQrCode {
  Map<String, String> steps;
  String qrCodeData;
  String qrCodeUrl;

  InstallationViaQrCode({
    required this.steps,
    required this.qrCodeData,
    required this.qrCodeUrl,
  });

  factory InstallationViaQrCode.fromJson(Map<String, dynamic> json) =>
      InstallationViaQrCode(
        steps: Map.from(
          json["steps"],
        ).map((k, v) => MapEntry<String, String>(k, v)),
        qrCodeData: json["qr_code_data"],
        qrCodeUrl: json["qr_code_url"],
      );

  Map<String, dynamic> toJson() => {
    "steps": Map.from(steps).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "qr_code_data": qrCodeData,
    "qr_code_url": qrCodeUrl,
  };
}

class NetworkSetup {
  Map<String, String> steps;
  String apnType;
  String apnValue;
  bool isRoaming;

  NetworkSetup({
    required this.steps,
    required this.apnType,
    required this.apnValue,
    required this.isRoaming,
  });

  factory NetworkSetup.fromJson(Map<String, dynamic> json) => NetworkSetup(
    steps: Map.from(
      json["steps"],
    ).map((k, v) => MapEntry<String, String>(k, v)),
    apnType: json["apn_type"],
    apnValue: json["apn_value"],
    isRoaming: json["is_roaming"],
  );

  Map<String, dynamic> toJson() => {
    "steps": Map.from(steps).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "apn_type": apnType,
    "apn_value": apnValue,
    "is_roaming": isRoaming,
  };
}

class Io {
  dynamic model;
  String? version;
  String directAppleInstallationUrl;
  InstallationViaQrCode installationViaQrCode;
  IoInstallationManual installationManual;
  NetworkSetup networkSetup;

  Io({
    required this.model,
    required this.version,
    required this.directAppleInstallationUrl,
    required this.installationViaQrCode,
    required this.installationManual,
    required this.networkSetup,
  });

  factory Io.fromJson(Map<String, dynamic> json) => Io(
    model: json["model"],
    version: json["version"],
    directAppleInstallationUrl: json["direct_apple_installation_url"],
    installationViaQrCode: InstallationViaQrCode.fromJson(
      json["installation_via_qr_code"],
    ),
    installationManual: IoInstallationManual.fromJson(
      json["installation_manual"],
    ),
    networkSetup: NetworkSetup.fromJson(json["network_setup"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "version": version,
    "direct_apple_installation_url": directAppleInstallationUrl,
    "installation_via_qr_code": installationViaQrCode.toJson(),
    "installation_manual": installationManual.toJson(),
    "network_setup": networkSetup.toJson(),
  };
}

class IoInstallationManual {
  Map<String, String> steps;
  String smdpAddressAndActivationCode;
  String smdpAddress;
  String activationCode;

  IoInstallationManual({
    required this.steps,
    required this.smdpAddressAndActivationCode,
    required this.smdpAddress,
    required this.activationCode,
  });

  factory IoInstallationManual.fromJson(Map<String, dynamic> json) =>
      IoInstallationManual(
        steps: Map.from(
          json["steps"],
        ).map((k, v) => MapEntry<String, String>(k, v)),
        smdpAddressAndActivationCode: json["smdp_address_and_activation_code"],
        smdpAddress: json["smdp_address"],
        activationCode: json["activation_code"],
      );

  Map<String, dynamic> toJson() => {
    "steps": Map.from(steps).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "smdp_address_and_activation_code": smdpAddressAndActivationCode,
    "smdp_address": smdpAddress,
    "activation_code": activationCode,
  };
}
