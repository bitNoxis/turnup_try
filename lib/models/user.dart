class User {
  String id;
  String name;
  double points;

  User({
    this.id = '',
    required this.name,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'points': points,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        points: json['points'],
      );
}
