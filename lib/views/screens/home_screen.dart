import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:open_emt/data/models/screen_arguments.dart';
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
          return Column(
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
                  child: CircularProgressIndicator(),
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
            ],
          );
        },
      ),
    );
  }
}
