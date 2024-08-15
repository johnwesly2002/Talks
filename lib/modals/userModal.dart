class Users {
  final int? usrId;
  final String usrName;
  final String usrPassword;
  final String usrPhoneNumber;

  Users({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
    required this.usrPhoneNumber,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        usrName: json["usrName"],
        usrPassword: json["usrPassword"],
        usrPhoneNumber: json["usrPhoneNumber"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "usrName": usrName,
        "usrPassword": usrPassword,
        "usrPhoneNumber": usrPhoneNumber,
      };
}
