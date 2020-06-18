class Rule {

  int id;
  String name;
  String content;
  int drinks;

  Rule(this.id, this.name, this.content, this.drinks);

  factory Rule.fromJson(Map<String, dynamic> json){
    return Rule(json["id"], json["name"], json["content"], json["drinks"]);
  }
}