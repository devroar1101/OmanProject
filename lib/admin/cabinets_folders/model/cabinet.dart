class Cabinet {
  final int id;
  String name;

  Cabinet({required this.id, required this.name});

  // Convert from Map to Cabinet
  factory Cabinet.fromMap(Map<String, dynamic> map) {
    return Cabinet(
      id: map['id'],
      name: map['name'],
    );
  }

  // Convert from Cabinet to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static List<Map<String, dynamic>> cabinetsToListOfMaps(
      List<Cabinet> cabinets) {
    return cabinets.map((cabinet) => cabinet.toMap()).toList();
  }
}
