import 'package:flutter/material.dart';
import 'package:peliculas/src/models/film_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Film> films;
  final Function nextPage;
  final _pageController = new PageController( initialPage: 1, viewportFraction: 0.3 );

  MovieHorizontal({ @required this.films, @required this.nextPage });

  @override
  Widget build( BuildContext context ) {
    
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {

      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) 
        nextPage(); 
      
    });

    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: films.length,
        itemBuilder: ( context, index ) => _tarjeta(context, films[ index ])
      ),
    );
  }

  Widget _tarjeta( BuildContext context, Film film) {

    film.uniqueID = '${ film.id }-poster';

    final tarjeta = Container(
        margin: EdgeInsets.only( right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: film.uniqueID,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage( film.getPosterImgs() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 160.0,
                ),
              ),
            ),
            SizedBox( height: 5.0),
            Text(
              film.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of( context ).textTheme.caption,
            )
          ],
        ),
      );

    return GestureDetector(
      onTap: (){

        Navigator.pushNamed(context, 'detail', arguments: film);

      },
      child: tarjeta,
    );

  }
}