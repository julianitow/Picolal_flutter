class Category {
  final int id;
  final String name;
  final String description;

  Category(this.id, this.name, this.description );

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(json["id"], json["name"], json["description"]);
  }
}