class Project {
  String name;
  String type;
  String location;
  String? docId;
  String? coverPhoto;

  Project({
    required this.name,
    required this.type,
    this.docId,
    required this.location,
    this.coverPhoto,
  });

  toJson() {
    return {
      "name": name,
      "type": type,
      "location": location,
      "docId": docId,
      "coverPhoto": coverPhoto,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json["name"],
      type: json["type"],
      docId: json["docId"],
      location: json["location"],
      coverPhoto: json["coverPhoto"],
    );
  }

  copyWith({String? name, String? type, String? docId, String? location, String? coverPhoto}) {
    this.name = name ?? this.name;
    this.type = type ?? this.type;
    this.docId = docId ?? this.docId;
    this.location = location ?? this.location;
    this.coverPhoto = coverPhoto ?? this.coverPhoto;
  }
}
