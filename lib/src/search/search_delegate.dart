import 'package:flutter/material.dart';
import 'package:peliculas/src/models/film_model.dart';
import 'package:peliculas/src/providers/films_provider.dart';

class DataSearch extends SearchDelegate{

  final filmsProvider = new FilmsProvider();
  
  @override //Acciones de nuestro AppBar
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton( 
        icon: Icon( Icons.clear ),
        onPressed: () => query = '',
      ),
    ];

  }

  @override //Icono a la izquierda del AppBar
  Widget buildLeading(BuildContext context) {

    return IconButton(
      icon: AnimatedIcon( icon: AnimatedIcons.menu_arrow, progress: transitionAnimation ),
      onPressed: () => close( context, null ),
    );

  }

  @override //Crea los resultado que vamos a mostrar
  Widget buildResults(BuildContext context) {

    return Container();

  }

  @override //Son la sugerencias que aparecen cuando la persona escribe
  Widget buildSuggestions(BuildContext context) {

    return ( query.isEmpty ) ? 
      Container() :
      FutureBuilder(
        future: filmsProvider.searchMovie( query ),
        builder: (BuildContext context, AsyncSnapshot<List<Film>> snapshot) {

          final films = snapshot.data;

          return ( snapshot.hasData) ?
            ListView(
              children: films.map( ( film ) {
                return ListTile(
                  leading: FadeInImage( 
                    image: NetworkImage( film.getPosterImgs() ),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text( film.title ),
                  subtitle: Text( film.originalTitle ),
                  onTap: (){
                    close( context, null);
                    film.uniqueID = '';
                    Navigator.pushNamed(context, 'detail', arguments: film);
                  },
                );
              }).toList()
            )
            : Center( child: CircularProgressIndicator() );
        },
      );


  }

}