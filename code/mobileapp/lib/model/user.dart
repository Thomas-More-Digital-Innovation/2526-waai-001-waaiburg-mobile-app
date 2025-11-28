class User {
  final int id;
  final int userTypeId;
  final String firstName;
  final String surname;
  final String? birthdate;
  final String email;
  final String? emailVerifiedAt;
  final String? phoneNumber;
  final String? gender;
  final String? street;
  final String? houseNumber;
  final String? city;
  final String? zipcode;
  final String? survey;
  final String? createdAt;
  final String? updatedAt;

  const User({
    required this.id,
    required this.userTypeId,
    required this.firstName,
    required this.surname,
    required this.email,
    this.birthdate,
    this.emailVerifiedAt,
    this.phoneNumber,
    this.gender,
    this.street,
    this.houseNumber,
    this.city,
    this.zipcode,
    this.survey,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        userTypeId: json['user_type_id'],
        firstName: json['firstname'],
        surname: json['surname'],
        birthdate: json['birthdate'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'],
        phoneNumber: json['phoneNumber'],
        gender: json['gender'],
        street: json['street'],
        houseNumber: json['houseNumber'],
        city: json['city'],
        zipcode: json['zipcode'],
        survey: json['survey'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
