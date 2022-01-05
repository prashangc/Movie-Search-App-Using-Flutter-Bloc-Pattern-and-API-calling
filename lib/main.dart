import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:search_movie_app_using_bloc/MoviesBloc.dart';
import 'package:search_movie_app_using_bloc/MoviesModel.dart';
import 'package:search_movie_app_using_bloc/MoviesRepo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: BlocProvider(
          create: (context) => MoviesBloc(MoviesRepo()),
          child: SearchMovies(),
        ),
      ),
    );
  }
}

class SearchMovies extends StatelessWidget {
  const SearchMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of<MoviesBloc>(context);
    var movieNameController = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state) {
            if (state is MovieInitialState)
              return Container(
                child: Column(
                  children: [
                    Text(
                      "Search For Movies",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "Instantly",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey[100],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: movieNameController,
                      decoration: InputDecoration(
                        prefix: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Colors.white70, style: BorderStyle.solid),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.blue, style: BorderStyle.solid)),
                        hintText: "Movie Name",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          movieBloc.add(FetchMovies(movieNameController.text));
                        },
                        color: Colors.lightBlue,
                        child: Text(
                          "Search",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            else if (state is MovieIsLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (state is MovieIsLoaded)
              return ShowMovie(state.getMovie, movieNameController.text);
            else
              return Text(
                "ERROR",
                style: TextStyle(color: Colors.white),
              );
          },
        ),
      ],
    );
  }
}

class ShowMovie extends StatelessWidget {
  MoviesModel moviesModel;

  final name;

  ShowMovie(this.moviesModel, this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "name: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "page: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.page.toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "total pages: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.totalPages.toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "total results: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.totalResults.toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "title: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.results![0].title.toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "average vote: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.results![0].voteAverage.toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "average vote count: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.results![0].voteCount.toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "overview: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.results![0].overview.toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Release  date: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.results![0].releaseDate.toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "genre: ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                moviesModel.results![0].genreIds![0].toString(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
