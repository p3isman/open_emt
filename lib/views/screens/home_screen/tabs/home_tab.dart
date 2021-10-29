import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:open_emt/data/models/screen_arguments.dart';
import 'package:open_emt/domain/bloc/favorite_stops_bloc/favorite_stops_bloc.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:open_emt/views/screens/detail_screen/detail_screen.dart';
import 'package:open_emt/views/screens/home_screen/widgets/favorite_stop.dart';
import 'package:open_emt/views/theme/theme.dart';

class HomeTab extends StatelessWidget {
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _textEditingController = TextEditingController();

  HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<StopInfoBloc, StopInfoState>(
      builder: (context, state) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 10.0,
              ),
              child: TextFormField(
                key: _formFieldKey,
                controller: _textEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Número de parada',
                    hintText: 'Introduce un código de parada.',
                    border: OutlineInputBorder(),
                    icon: FaIcon(FontAwesomeIcons.bus)),
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Introduce un número de parada.';
                  }
                  text = text.trim();
                  if (text == '' ||
                      int.parse(text) is! int ||
                      int.parse(text) <= 0) {
                    return 'Parada no válida.';
                  }
                },
                onFieldSubmitted: (text) {
                  if (_formFieldKey.currentState!.validate()) {
                    context.read<StopInfoBloc>().add(GetStopInfo(stopId: text));
                    Navigator.pushNamed(context, DetailScreen.route,
                        arguments: ScreenArguments(stopId: text));
                  }
                },
              ),
            ),
            BlocBuilder<FavoriteStopsBloc, FavoriteStopsState>(
                builder: (context, state) {
              if (state is FavoritesLoadSuccess) {
                return state.stops.isEmpty
                    ? Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 40.0,
                            ),
                            child: Text(
                                'Marca paradas como favoritas para verlas aquí',
                                style: AppTheme.title),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: size.width * 0.1),
                              child: SvgPicture.asset(
                                'assets/bus.svg',
                                width: size.width * 0.55,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: List.generate(
                          state.stops.length,
                          (index) => Column(
                            children: [
                              if (index != 0) const Divider(),
                              FavoriteStop(state, index),
                            ],
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
    );
  }
}
