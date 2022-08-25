import 'package:hive/hive.dart';
part 'User.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  final String UID;
  @HiveField(1)
  final String? city;
  @HiveField(2)
  final String fullName;
  @HiveField(3)
  final String? streetAddress;
  @HiveField(4)
  final String? phoneNumber;
  @HiveField(5)
  final List<String>? occupation;
  @HiveField(6)
  final String? description;
  @HiveField(7)
  final double? rate;
  @HiveField(8)
  final int? reviewsNumber;
  @HiveField(9)
  final int? recommendationNumber;
  @HiveField(10)
  final String? profilePicture;
  @HiveField(11)
  final String? primaryOccupation;
  @HiveField(12)
  final List<String>? favorites;

  UserData(
      {required this.UID,
      this.city,
      required this.fullName,
      this.streetAddress,
      this.phoneNumber,
      this.occupation,
      this.description,
      this.rate = 0,
      this.reviewsNumber,
      this.recommendationNumber,
      this.profilePicture,
      this.primaryOccupation,
      this.favorites});
  Map<String, dynamic> toMap() {
    return {
      'UID': UID,
      'fullName': fullName,
      'city': city,
      'streetAddress': streetAddress,
      'phoneNumber': phoneNumber,
      'occupation': occupation,
      'rate': rate,
      'reviewsNumber': reviewsNumber,
      'recommendationNumber': recommendationNumber,
      'profilePicture': profilePicture,
      'primaryOccupation': primaryOccupation
    };
  }

  UserData.fromMap(Map<String, dynamic> map)
      : UID = map["UID"],
        city = map["city"],
        fullName = map["fullName"],
        streetAddress = map["streetAddress"],
        phoneNumber = map["phoneNumber"],
        occupation = (((map["occupation"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList()),
        description = map["description"],
        rate = ((map["rate"]) ?? 0).toDouble(),
        reviewsNumber = map["reviewsNumber"],
        recommendationNumber = map["recommendationNumber"],
        profilePicture = map["profilePicture"],
        favorites = (((map["favorites"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList()),
        primaryOccupation = map["primaryOccupation"];
}
