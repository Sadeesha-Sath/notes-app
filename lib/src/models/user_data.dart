
class UserData {
  String email;
  String name;
  String? profileUrl;

  UserData({required this.email, required this.name, this.profileUrl});

  UserData.fromDocumentSnapshot(dynamic documentSnapshot)
      : email = documentSnapshot['email'],
        name = documentSnapshot['name'],
        profileUrl = documentSnapshot['profileUrl'];

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'profileUrl': profileUrl};
  }
}
