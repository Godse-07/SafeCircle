class UserModel {
  String? id;
  String? name;
  String? number;
  String? child_mail;
  String? parent_email;

  UserModel({this.name, this.number, this.child_mail, this.parent_email, this.id});

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'mail': child_mail,
        'gemail': parent_email,
        'id': id,
      };
}
