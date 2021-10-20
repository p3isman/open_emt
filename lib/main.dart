import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:open_emt/data/services/emt_service.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:open_emt/domain/repositories/emt_repository.dart';
import 'package:open_emt/views/screens/detail_screen.dart';
import 'package:open_emt/views/screens/home_screen.dart';

final GetIt locator = GetIt.instance;

Future<void> _setup() async {
  locator.registerLazySingleton<EMTService>(() => EMTService());
  locator.registerLazySingleton<EMTRepository>(
      () => EMTRepository(emtService: locator.get<EMTService>()));
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
      ),
    );
  }
}
