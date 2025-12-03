import 'dart:convert';

class ServiceOrder {
  int? id;
  String? name;
  DateTime? createdDate;
  DateTime? startedDate;
  DateTime? finalizedDate;
  String? description;
  List<String>? images;
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
    this.images,
    required this.active,
    this.status,
    this.adress
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_date': createdDate?.toIso8601String(),
      'started_date': startedDate?.toIso8601String(),
      'finalized_date': finalizedDate?.toIso8601String(),
      'description': description,
      'images': images != null ? jsonEncode(images) : null,
      'active': active == true ? 1 : 0,
      'status': status,
      'address': adress,
    };
  }

  factory ServiceOrder.fromMap(Map<String, dynamic> map) {
    List<String>? imagesList;
    if(map['images'] != null ) {
      try {
        imagesList = List<String>.from(jsonDecode(map['images']));
      } catch (e) {
        print('Erro no decode das imagens');
        imagesList = null;
      }
    }
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
      images: imagesList,
      active: map['active'] == 1, 
      status: map['status'],
      adress: map['address'],
    );
  }

  ServiceOrder copyWith({
    int? id,
    String? name,
    DateTime? createdDate,
    DateTime? startedDate,
    DateTime? finalizedDate,
    String? description,
    List<String>? images,
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
      images: images ?? this.images,
      status: status ?? this.status,
      active: active ?? this.active,
      adress: adress ?? this.adress,
    );
  }
}

