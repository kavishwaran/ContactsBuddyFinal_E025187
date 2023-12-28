class ContactsModel {
  final int? id;
  final String name;
  final int number;

  ContactsModel({
    this.id,
    required this.name,
    required this.number,
  });

  factory ContactsModel.fromMap(Map<String, dynamic> json) => ContactsModel(
    id: json["id"],
    name: json["name"],
    number: json["number"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "number": number,
  };
}
