class User {
  String id;
  String name;
  double points;
  String photoUrl;

  User({
    this.id = '',
    required this.name,
    required this.points,
    this.photoUrl = ''});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'points': points,
        'photoURL': photoUrl
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      points: json['points'],
      photoUrl: json['photoURL']);
}
