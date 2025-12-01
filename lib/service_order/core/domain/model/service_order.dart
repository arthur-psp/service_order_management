class ServiceOrder {
  int? id;
  String? name;
  DateTime? createdDate;
  DateTime? startedDate;
  DateTime? finalizedDate;
  String? description;
  String? imageUrl;
  String? status;
  bool? active;
  String? adress;

  ServiceOrder({
    this.id,
    required this.name,
    required this.createdDate,
    required this.startedDate,
    required this.finalizedDate,
    required this.description,
    required this.imageUrl,
    required this.active,
    this.status,
    this.adress
  });

  // Método toMap convertendo DateTime para String (ISO)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_date': createdDate?.toIso8601String(),
      'started_date': startedDate?.toIso8601String(),
      'finalized_date': finalizedDate?.toIso8601String(),
      'description': description,
      'image_url': imageUrl,
      'active': active == true ? 1 : 0, // SQLite não tem bool nativo
      'status': status,
      'address': adress,
    };
  }

  // Factory fromMap convertendo String para DateTime
  factory ServiceOrder.fromMap(Map<String, dynamic> map) {
    return ServiceOrder(
      id: map['id'],
      name: map['name'],
      createdDate: map['created_date'] != null 
          ? DateTime.parse(map['created_date']) 
          : null,
      startedDate: map['started_date'] != null 
          ? DateTime.parse(map['started_date']) 
          : null,
      finalizedDate: map['finalized_date'] != null 
          ? DateTime.parse(map['finalized_date']) 
          : null,
      description: map['description'],
      imageUrl: map['image_url'],
      active: map['active'] == 1, // Convertendo de int para bool
      status: map['status'],
      adress: map['address'],
    );
  }

  // Método copyWith
  ServiceOrder copyWith({
    int? id,
    String? name,
    DateTime? createdDate,
    DateTime? startedDate,
    DateTime? finalizedDate,
    String? description,
    String? imageUrl,
    String? status,
    bool? active,
    String? adress,
  }) {
    return ServiceOrder(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      startedDate: startedDate ?? this.startedDate,
      finalizedDate: finalizedDate ?? this.finalizedDate,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      active: active ?? this.active,
      adress: adress ?? this.adress,
    );
  }
}

