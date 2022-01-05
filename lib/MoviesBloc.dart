import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_movie_app_using_bloc/MoviesModel.dart';
import 'package:search_movie_app_using_bloc/MoviesRepo.dart';

class MoviesEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchMovies extends MoviesEvent {
  final _name;

  FetchMovies(this._name);

  @override
  List<Object> get props => [_name];
}

class ResetMovies extends MoviesEvent {}

class MoviesState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MovieIsNotSearched extends MoviesState {}

class MovieIsLoading extends MoviesState {}

class MovieIsNotLoaded extends MoviesState {}

class MovieIsLoaded extends MoviesState {
  final _movie;

  MovieIsLoaded(this._movie);

  MoviesModel get getMovie => _movie;

  @override
  List<Object> get props => [_movie];
}

class MovieInitialState extends MoviesState {}

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesRepo moviesRepo;
  MoviesBloc(this.moviesRepo) : super(MovieInitialState());

  MoviesState get initialState => MovieIsNotSearched();

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    if (event is FetchMovies) {
      yield MovieIsLoading();

      try {
        MoviesModel movie = await moviesRepo.getMovies(event._name);
        yield MovieIsLoaded(movie);
      } catch (_) {
        print(_);
        yield MovieIsNotLoaded();
      }
    } else if (event is ResetMovies) {
      yield MovieIsNotSearched();
    }
  }
}
