class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? lastname;

  UserModel({this.uid, this.email, this.firstname, this.lastname});

  //receiving the data from server
  // The fromMap() function converts the Firestore document data
  //(a Map<String, dynamic>) into a UserModel object by mapping the values to the corresponding properties in the model class.
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstname: map['firstname'],
        lastname: map['lastname']);
  }

  //sending data to our server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'lastname': lastname
    };
  }
}
