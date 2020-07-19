import 'dart:convert';
import 'package:picolal/Category.dart';
import 'package:picolal/Rule.dart';
import 'package:http/http.dart' as http;

class ApiServices {

  static const String endpoint = "http://lil-nas.ddns.net:8080/api/";

  static Future<List<Category>> getCategories() async {
      final res = await http.get(endpoint + "categories");
      if (res.statusCode != 200) {
        throw Error();
      }
      final jsonBody = json.decode(res.body);
      final List<Category> categories = [];
      categories.addAll((jsonBody as List).map((category) => Category.fromJson(category)).toList());
      return categories;
  }

  static Future<List<Rule>> getRulesByCat(Category cat) async {
      final res = await http.get(endpoint + "category/" + cat.name + "/rules");
      if (res.statusCode != 200) throw Error();

      final jsonBody = json.decode(res.body);
      final List<Rule> rules = [];
      rules.addAll((jsonBody as List).map((rule) => Rule.fromJson(rule)).toList());
      return rules;
  }
}