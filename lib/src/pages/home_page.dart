import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final PeliculasProvider peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Películas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer( context),
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        return ( snapshot.hasData ) ? 
          CardSwiper( peliculas: snapshot.data ) :
          Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator( backgroundColor: Colors.indigoAccent ),
            )
          );
          
      },
    );
  }

  Widget _footer( BuildContext context ) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead )
          ),
          SizedBox( height: 5.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              return ( snapshot.hasData ) ? 
                MovieHorizontal( films: snapshot.data, nextPage: peliculasProvider.getPopular ) :
                Center(
                  child: CircularProgressIndicator( backgroundColor: Colors.indigoAccent )
                );
            },
          ),
        ],
      ),
    );

  }
}