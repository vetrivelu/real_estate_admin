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

  List<String> get search {
    List<String> returns = [];
    returns.addAll(makeSearchstring(name));
    returns.addAll(makeSearchstring(location));
    returns.addAll(makeSearchstring(type));
    return returns;
  }

  List<String> makeSearchstring(String string) {
    List<String> list = [];
    for (int i = 1; i < string.length; i++) {
      list.add(string.substring(0, i).toLowerCase());
    }
    list.add(string.toLowerCase());
    return list;
  }

  toJson() {
    return {
      "name": name,
      "type": type,
      "location": location,
      "docId": docId,
      "coverPhoto": coverPhoto,
      "search": search,
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
