import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actor_model.dart';
import 'package:peliculas/src/models/film_model.dart';
import 'package:peliculas/src/providers/films_provider.dart';

class DetailFilm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Film film = ModalRoute.of( context ).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppbar( film ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox( height: 10.0 ),
              _posterTitle( film, context ),
              _description( film ),
              _createCast( film )
            ]),
          )
        ],
      ),
    );
  }

  Widget _createAppbar( Film film) {

    return SliverAppBar(
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text( 
          film.title,
          style: TextStyle( color: Colors.white, fontSize: 16.0 ),
        ),
        background: FadeInImage(
          image: NetworkImage( film.getBackgroundImg() ),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration( milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );

  }

  Widget _posterTitle( Film film, BuildContext context ) {

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: film.uniqueID,
            child: ClipRRect(
              borderRadius: BorderRadius.circular( 20.0 ),
              child: Image(
                image: NetworkImage( film.getPosterImgs() ),
                height: 150.0,
              ),
            ),
          ),
          SizedBox( width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text( film.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis ),
                Text( film.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis ),
                Row(
                  children: <Widget>[
                    Icon(Icons.star),
                    SizedBox( width: 5.0,),
                    Text( film.voteAverage.toString(), style: Theme.of(context).textTheme.subhead )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );

  }

  Widget _description( Film film ) {

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20.0, vertical: 20.0 ),
      child: Text( film.overview, textAlign: TextAlign.justify ),
    );

  }

  Widget _createCast(Film film) {

    final filmsProvider = new FilmsProvider();

    return FutureBuilder(
      future: filmsProvider.getCast( film.id.toString() ),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        return (snapshot.hasData) ?
          _createPageViewActors( snapshot.data ) :
          Center( child: CircularProgressIndicator());

      },
    );

  }

  Widget _createPageViewActors( List<Actor> actors ) {

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actors.length,
        itemBuilder: ( context, index ) => _actorCard( actors[index] ),
      ),
    );
  }

  Widget _actorCard( Actor actor) {

    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular( 20.0 ),
            child: FadeInImage(
              image: NetworkImage( actor.getPhoto() ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover
            ),
          ),
          Text( 
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

  }
}