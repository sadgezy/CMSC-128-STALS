class User {
  final String id; //note
  final String firstName;
  final String lastName;
  final String? middleInitial;
  final String? suffix;
  final String username;
  final String email;
  final String userType;
  final bool verified;
  final bool archived;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.middleInitial,
    this.suffix,
    required this.username,
    required this.email,
    required String userType, //!
    required this.verified,
    required this.archived,
  }) : userType =
            userType.substring(0, 1).toUpperCase() + userType.substring(1); //!

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleInitial: json['middle_initial'],
      suffix: json['suffix'],
      username: json['username'],
      email: json['email'],
      userType: json['user_type'],
      verified: json['verified'],
      archived: json['archived'],
    );
  }
}



// class User {
//   final String first_name;
//   final String last_name;

//   User({required this.first_name, required this.last_name});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
      
//       first_name: json['first_name'],
//       last_name: json['last_name'],
//     );
//   }
// }


/*
    first_name
    last_name
    middle_initial
    suffix

    user_type

    username
    email 
    

    verified
    archived

*/