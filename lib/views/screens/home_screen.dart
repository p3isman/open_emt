import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import 'package:open_emt/data/models/screen_arguments.dart';
import 'package:open_emt/domain/bloc/favorite_stops_bloc/favorite_stops_bloc.dart';
import 'package:open_emt/domain/bloc/map_bloc/map_bloc.dart';
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
  final List<Widget> _tabs = [
    HomeTab(), // see the HomeTab class below
    const MapTab() //, see the SettingsTab class below
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OpenEMT')),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(label: 'Inicio', icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: 'Mapa', icon: Icon(Icons.map)),
        ],
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
      floatingActionButton:
          BlocBuilder<MapBloc, MapState>(builder: (context, state) {
        return _currentIndex == 1 && (state is MapLoaded)
            ? FloatingActionButton(
                onPressed: () => context.read<MapBloc>().add(const CenterMap()),
                child: const Icon(Icons.gps_fixed),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}

class HomeTab extends StatelessWidget {
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _textEditingController = TextEditingController();

  HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
                  text.contains('.') ||
                  !isNumeric(text) ||
                  int.parse(text) <= 0) {
                return 'Parada no válida.';
              }
            },
            onFieldSubmitted: (text) {
              if (_formFieldKey.currentState!.validate()) {
                // Remove leading zeros
                text = text.replaceFirst(RegExp(r'^0+'), '');
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
        onTap: () {
          context
              .read<StopInfoBloc>()
              .add(GetStopInfo(stopId: state.stops[index].label));
          Navigator.pushNamed(context, DetailScreen.route,
              arguments: ScreenArguments(stopId: state.stops[index].label));
        },
        leading: Card(
          color: Colors.grey.shade700,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(state.stops[index].label,
                style: AppTheme.waitingTime
                    .copyWith(color: Colors.white, fontSize: 16.0)),
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
                        state.stops[index].stopLines.data[stopLine].label[0] ==
                                'N'
                            ? [Colors.black, Colors.grey.shade700]
                            : [Colors.blue.shade700, Colors.blue.shade400],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  child: Text(
                    state.stops[index].stopLines.data[stopLine].label,
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

class MapTab extends StatelessWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Declare mapController each time the map is built and then change its value to avoid an 'already initialized' bug.
    MapController? mapController;

    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      if (state is MapLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is MapLoaded) {
        return FlutterMap(
          key: UniqueKey(),
          mapController: mapController,
          options: MapOptions(
            onMapCreated: (controller) => controller = state.mapController,
            center: LatLng(40.41317, -3.68307),
            zoom: 15.0,
            interactiveFlags: InteractiveFlag.drag |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.doubleTapZoom,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              attributionBuilder: (_) {
                return const Text("© OpenStreetMap contributors",
                    style: TextStyle(color: Colors.grey));
              },
            ),
            MarkerLayerOptions(
              markers: state.markers,
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }
}
