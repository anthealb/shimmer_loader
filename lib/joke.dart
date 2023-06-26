import 'dart:convert';
import 'package:http/http.dart' as http;

class Jokes {
  static final Uri url = Uri.https('official-joke-api.appspot.com', '/random_joke');

  static Future<Joke> loadJoke() async {
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
      return Future.delayed(const Duration(seconds: 2), () => Joke.fromJson(json.decode(response.body)));
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}

class Joke {
  final String type;
  final String setup;
  final String punchline;

  const Joke(this.type, this.setup, this.punchline);

  Joke.fromJson(Map<String, dynamic> map)
      : type = map['type'],
        setup = map['setup'],
        punchline = map['punchline'];
}
