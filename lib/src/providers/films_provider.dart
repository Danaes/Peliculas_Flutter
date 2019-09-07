import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actor_model.dart';

import 'package:peliculas/src/models/film_model.dart';

class FilmsProvider {

  String _apikey   = 'dc11300f7c75aeb800f78db5ff9be95b';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _isLoading     = false;

  List<Film> _populares = new List();

  final _popularesStreamController = StreamController<List<Film>>.broadcast();

  Function(List<Film>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Film>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() => _popularesStreamController?.close();

  Future<List<Film>> _procesarResp (Uri url) async {
    
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final films = new Films.fromJsonList(decodeData['results']);

    return films.items;

  }

  Future<List<Film>> getNowPlaying() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apikey,
      'language': _language
    });

    return await _procesarResp(url);

  }

  Future<List<Film>> getPopular() async {
    
    if ( _isLoading ) return [];
    
    _isLoading = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apikey,
      'language': _language,
      'page'    : _popularesPage.toString(),
    });

    final resp = await _procesarResp(url);

    _populares.addAll(resp);
    popularesSink( _populares );
    
    _isLoading = false;

    return resp;
  }

  Future<List<Actor>> getCast( String idFilm) async {

    final url = Uri.https(_url, '3/movie/$idFilm/credits', {
      'api_key' : _apikey
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actors;
  }

  Future<List<Film>> searchMovie( String query ) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apikey,
      'language': _language,
      'query'   : query
    });

    return await _procesarResp(url);

  }

}