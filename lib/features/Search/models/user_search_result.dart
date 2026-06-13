class UserSearchResult {
  final String name;
  final String image;

  UserSearchResult({required this.name, required this.image});

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image};
  }
}
