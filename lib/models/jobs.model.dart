import 'dart:convert';


List<Jobs> jobsFromJson(String str) =>
    List<Jobs>.from(json.decode(str).map((x) => Jobs.fromJson(x)));

String jobsToJson(List<Jobs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Jobs {
  Jobs({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.postedBy,
    required this.jobimage,
    required this.contactNr,
    required this.category,
  });

  int id;
  String title;
  String description;
  String createdAt;
  String postedBy;
  String jobimage;
  String contactNr;
  String category;

  factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      createdAt: json["created_at"],
      postedBy: json["posted_by"],
      jobimage: json["jobimage"],
      contactNr: json["contact_nr"],
      category: json["category"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt,
        "posted_by": postedBy,
        "jobimage": jobimage,
        "contact_nr": contactNr,
        "category": category,
      };
}
