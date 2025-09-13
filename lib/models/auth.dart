class Auth {
  Staff? staff;
  String? token;

  Auth({this.staff, this.token});

  Auth.fromJson(Map<String, dynamic> json) {
    staff = json['staff'] != null ? Staff.fromJson(json['staff']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (staff != null) {
      data['staff'] = staff!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class Staff {
  int id;
  String fullName;
  String contact;
  int position;
  String shift;
  int restaurantId;
  String expiredAt;
  String restaurantUsername;

  Staff({
    required this.id,
    required this.fullName,
    required this.contact,
    required this.position,
    required this.shift,
    required this.restaurantId,
    required this.expiredAt,
    required this.restaurantUsername,
  });

  Staff.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'],
        contact = json['contact'],
        position = json['position'],
        shift = json['shift'],
        restaurantId = json['restaurantId'],
        expiredAt = json['expiredAt'],
        restaurantUsername = json['restaurantUsername'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['contact'] = contact;
    data['position'] = position;
    data['shift'] = shift;
    data['restaurantId'] = restaurantId;
    data['expiredAt'] = expiredAt;
    data['restaurantUsername'] = restaurantUsername;
    return data;
  }
}
