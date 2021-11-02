import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_emt/data/models/screen_arguments.dart';
import 'package:open_emt/domain/bloc/favorite_stops_bloc/favorite_stops_bloc.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:open_emt/domain/repositories/emt_repository.dart';
import 'package:open_emt/domain/repositories/favorites_repository.dart';
import 'package:open_emt/main.dart';
import 'package:open_emt/views/theme/theme.dart';
import 'package:open_emt/views/screens/detail_screen/widgets/arrive_info.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  /// Static named route for page
  static const String route = '/detail';

  /// Static method to return the widget as a PageRoute
  static Route go() =>
      MaterialPageRoute<void>(builder: (_) => const DetailScreen());

  @override
  Widget build(BuildContext context) {
    final String stopId =
        (ModalRoute.of(context)!.settings.arguments as ScreenArguments).stopId;

    final _emtRepository = locator.get<EMTRepository>();
    final _favoritesRepository = locator.get<FavoritesRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parada nº$stopId',
          style: AppTheme.appBarTitle,
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.blue,
                  Colors.blue.shade900,
                ]),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<StopInfoBloc, StopInfoState>(
            builder: (context, state) {
              if (state is StopInfoLoaded) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: _emtRepository
                          .groupArrivesByLine(state.stopInfo.data.first.arrive)
                          .length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 3.0,
                          ),
                          child: ArriveInfoWidget(
                              arriveInfo: _emtRepository.groupArrivesByLine(
                                  state.stopInfo.data.first.arrive)[i]),
                        );
                      }),
                );
              } else if (state is StopInfoLoading) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: CircularProgressIndicator(),
                ));
              } else if (state is StopInfoError) {
                if (state.error != null) {
                  return Text(state.error!.type.toString());
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40.0,
                    horizontal: 15.0,
                  ),
                  child: Card(
                    color: Colors.red.shade200,
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Error al obtener información sobre la parada.',
                        style: AppTheme.errorMessage,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: Text('Introduce un número de parada'));
              }
            },
          ),
        ],
      ),
      floatingActionButton:
          BlocBuilder<StopInfoBloc, StopInfoState>(builder: (context, state) {
        return (state is StopInfoLoaded)
            ? Wrap(
                direction: Axis.vertical,
                children: [
                  BlocBuilder<FavoriteStopsBloc, FavoriteStopsState>(
                      builder: (context, favoriteStopsState) {
                    if (favoriteStopsState is FavoritesLoadSuccess) {
                      bool isFavorite = _favoritesRepository.checkIfFavorite(
                          favoriteStopsState.stops,
                          state.stopInfo.data.first.stopInfo.first);
                      return FloatingActionButton(
                        heroTag: null,
                        onPressed: isFavorite
                            ? () => context.read<FavoriteStopsBloc>().add(
                                FavoriteDeleted(
                                    state.stopInfo.data.first.stopInfo.first))
                            : () => context.read<FavoriteStopsBloc>().add(
                                FavoriteAdded(
                                    state.stopInfo.data.first.stopInfo.first)),
                        child: isFavorite
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: FloatingActionButton(
                      heroTag: null,
                      onPressed: () => context.read<StopInfoBloc>().add(
                          GetStopInfo(
                              stopId: state
                                  .stopInfo.data.first.stopInfo.first.label)),
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink();
      }),
    );
  }
}
