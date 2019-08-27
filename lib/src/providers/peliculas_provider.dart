import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apikey   = 'dc11300f7c75aeb800f78db5ff9be95b';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _isLoading     = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() => _popularesStreamController?.close();

  Future<List<Pelicula>> _procesarResp (Uri url) async {
    
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;

  }

  Future<List<Pelicula>> getNowPlaying() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apikey,
      'language': _language
    });

    return await _procesarResp(url);

  }

  Future<List<Pelicula>> getPopular() async {
    
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
}