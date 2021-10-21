import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:open_emt/data/models/screen_arguments.dart';
import 'package:open_emt/domain/bloc/favorite_stops_bloc/favorite_stops_bloc.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:open_emt/utils/utils.dart';
import 'package:open_emt/views/screens/detail_screen.dart';
import 'package:open_emt/views/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  /// Static named route for page
  static const String route = '/home';

  /// Static method to return the widget as a PageRoute
  static Route go() =>
      MaterialPageRoute<void>(builder: (_) => const HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OpenEMT')),
      body: BlocConsumer<StopInfoBloc, StopInfoState>(
        listenWhen: (previous, current) => current is StopInfoLoaded,
        listener: (context, state) {
          if (state is StopInfoLoaded && ModalRoute.of(context)!.isCurrent) {
            Navigator.of(context).pushNamed(
              DetailScreen.route,
              arguments: ScreenArguments(
                  stopInfo: state.stopInfo.data.first.stopInfo.first),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: TextFormField(
                  key: _formFieldKey,
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Número de parada',
                      border: OutlineInputBorder(),
                      icon: FaIcon(FontAwesomeIcons.bus)),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Introduce un número de parada.';
                    }
                    text = text.trim();
                    if (text == '' ||
                        text.contains('.') ||
                        !isNumeric(text) ||
                        int.parse(text) <= 0) {
                      return 'Parada no válida.';
                    }
                  },
                  onFieldSubmitted: (text) {
                    if (_formFieldKey.currentState!.validate()) {
                      context
                          .read<StopInfoBloc>()
                          .add(GetStopInfo(stopId: text));
                    }
                  },
                ),
              ),
              if (state is StopInfoLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: SizedBox(
                      height: 100.0,
                      child: Center(child: CircularProgressIndicator())),
                ),
              if (state is StopInfoError)
                Padding(
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
                ),
              BlocBuilder<FavoriteStopsBloc, FavoriteStopsState>(
                  builder: (context, state) {
                if (state is FavoritesLoadSuccess) {
                  return Column(
                    children: List.generate(
                      state.stops.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: FavoriteStop(state, index),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              })
            ],
          );
        },
      ),
    );
  }
}

class FavoriteStop extends StatelessWidget {
  final FavoritesLoadSuccess state;
  final int index;

  const FavoriteStop(
    this.state,
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) => BlocProvider.of<FavoriteStopsBloc>(context)
          .add(FavoriteDeleted(state.stops[index])),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      key: UniqueKey(),
      child: ListTile(
        onTap: () => context
            .read<StopInfoBloc>()
            .add(GetStopInfo(stopId: state.stops[index].label)),
        leading: Card(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(state.stops[index].label,
                style: AppTheme.waitingTime.copyWith(fontSize: 16.0)),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            state.stops[index].direction,
            style: AppTheme.waitingTime.copyWith(fontSize: 14.0),
            softWrap: true,
          ),
        ),
        subtitle: Wrap(
          children: List.generate(
            state.stops[index].stopLines.data.length,
            (stopLine) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors:
                        state.stops[index].stopLines.data[stopLine].line == 'N'
                            ? [Colors.black, Colors.grey.shade700]
                            : [Colors.blue.shade700, Colors.blue.shade400],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  child: Text(
                    state.stops[index].stopLines.data[stopLine].line,
                    style: AppTheme.lineNumber.copyWith(fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
