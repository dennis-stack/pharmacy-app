class Customer {
  int id;
  String firstName;
  String lastName;
  String phoneNo;
  String email;
  String password;

  Customer(
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNo,
    this.email,
    this.password,
  );

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'firstName': firstName,
        'lastName': lastName,
        'phoneNo': phoneNo,
        'email': email,
        'password': password,
      };
}
