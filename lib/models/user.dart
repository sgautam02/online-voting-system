import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? avatar;
  String? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? role;
  String? image;
  FaceFeatures? faceFeatures;
  List<dynamic>? ownedElections;

  UserModel(
      {this.avatar,
      this.id,
      this.name,
      this.phoneNumber,
      this.email,
      this.role,
        this.image,
        this.faceFeatures,
      this.ownedElections
      });

  UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
    UserModel _user = UserModel();
    _user.id = doc.id;
    _user.email = doc['email'];
    _user.name = doc['name'];
    _user.phoneNumber = doc['phonenumber'];
    _user.ownedElections = doc['owned_elections'];
    _user.avatar = doc['avatar'];
    _user.role = doc['role'];
    _user.image= doc['image'];
    _user.faceFeatures = FaceFeatures.fromJson(doc["faceFeatures"]);
    return _user;
  }
  UserModel fromJson(Map<String, dynamic> doc) {
    UserModel _user = UserModel();
    _user.id = doc['id'];
    _user.email = doc['email'];
    _user.name = doc['name'];
    _user.phoneNumber = doc['phoneNumber'];
    _user.ownedElections = doc['owned_elections'];
    _user.avatar = doc['avatar'];
    _user.role = doc['role'];
    _user.image= doc['image'];
    _user.faceFeatures = FaceFeatures.fromJson(doc["faceFeatures"]);
    return _user;
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar': avatar,
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'role': role,
      'image': image,
      'faceFeatures': faceFeatures?.toJson(),
      'owned_elections': ownedElections,
    };
  }
}

class FaceFeatures {
  Points? rightEar;
  Points? leftEar;
  Points? rightEye;
  Points? leftEye;
  Points? rightCheek;
  Points? leftCheek;
  Points? rightMouth;
  Points? leftMouth;
  Points? noseBase;
  Points? bottomMouth;

  FaceFeatures({
    this.rightMouth,
    this.leftMouth,
    this.leftCheek,
    this.rightCheek,
    this.leftEye,
    this.rightEar,
    this.leftEar,
    this.rightEye,
    this.noseBase,
    this.bottomMouth,
  });

  factory FaceFeatures.fromJson(Map<String, dynamic> json) => FaceFeatures(
    rightMouth: Points.fromJson(json["rightMouth"]),
    leftMouth: Points.fromJson(json["leftMouth"]),
    leftCheek: Points.fromJson(json["leftCheek"]),
    rightCheek: Points.fromJson(json["rightCheek"]),
    leftEye: Points.fromJson(json["leftEye"]),
    rightEar: Points.fromJson(json["rightEar"]),
    leftEar: Points.fromJson(json["leftEar"]),
    rightEye: Points.fromJson(json["rightEye"]),
    noseBase: Points.fromJson(json["noseBase"]),
    bottomMouth: Points.fromJson(json["bottomMouth"]),
  );

  Map<String, dynamic> toJson() => {
    "rightMouth": rightMouth?.toJson() ?? {},
    "leftMouth": leftMouth?.toJson() ?? {},
    "leftCheek": leftCheek?.toJson() ?? {},
    "rightCheek": rightCheek?.toJson() ?? {},
    "leftEye": leftEye?.toJson() ?? {},
    "rightEar": rightEar?.toJson() ?? {},
    "leftEar": leftEar?.toJson() ?? {},
    "rightEye": rightEye?.toJson() ?? {},
    "noseBase": noseBase?.toJson() ?? {},
    "bottomMouth": bottomMouth?.toJson() ?? {},
  };
}

class Points {
  int? x;
  int? y;

  Points({
    required this.x,
    required this.y,
  });

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    x: (json['x'] ?? 0) as int,
    y: (json['y'] ?? 0) as int,
  );

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}
