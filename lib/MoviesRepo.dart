import 'package:search_movie_app_using_bloc/MoviesModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviesRepo {
  Future<MoviesModel> getMovies(String name) async {
    final result = await http.Client().get(Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=802b2c4b88ea1183e50e6b285a27696e&fbclid=IwAR2yEEcerjqqhPN8qjrzg1qoW-cgqeamtIvrRjyWSbStT9su_66LuHO-tKs"));

    if (result.statusCode != 200) throw Exception();

    return testFromJson(result.body);
  }
}
