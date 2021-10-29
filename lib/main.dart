import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:open_emt/data/services/db_service.dart';
import 'package:open_emt/data/services/emt_service.dart';
import 'package:open_emt/domain/bloc/favorite_stops_bloc/favorite_stops_bloc.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:open_emt/domain/repositories/emt_repository.dart';
import 'package:open_emt/domain/repositories/favorites_repository.dart';
import 'package:open_emt/views/screens/detail_screen/detail_screen.dart';
import 'package:open_emt/views/screens/home_screen/home_screen.dart';
import 'package:open_emt/views/theme/theme.dart';

final GetIt locator = GetIt.instance;

Future<void> _setup() async {
  locator.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepository(dbService: DBService()));
  locator.registerLazySingleton<EMTRepository>(
      () => EMTRepository(emtService: EMTService()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setup();
  runApp(const OpenEMT());
}

class OpenEMT extends StatelessWidget {
  const OpenEMT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoriteStopsBloc(
              favoritesRepository: locator.get<FavoritesRepository>())
            ..add(const InitializeFavorites()),
        ),
        BlocProvider(
          create: (context) =>
              StopInfoBloc(emtRepository: locator.get<EMTRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'OpenEMT',
        initialRoute: HomeScreen.route,
        routes: {
          HomeScreen.route: (context) => const HomeScreen(),
          DetailScreen.route: (context) => const DetailScreen(),
        },
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
