import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:open_emt/data/models/map_marker_model.dart';
import 'package:open_emt/data/models/screen_arguments.dart';
import 'package:open_emt/data/models/stop_list_model.dart';
import 'package:open_emt/data/repositories/emt_repository.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:open_emt/main.dart';
import 'package:open_emt/views/screens/detail_screen/detail_screen.dart';
import 'package:open_emt/views/theme/theme.dart';

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  // Default controller
  // final Completer<GoogleMapController> _controller = Completer();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final List<Marker> _googleMarkers = [];
  double _currentZoom = 15;
  late final BitmapDescriptor _stopIcon;
  late final BitmapDescriptor _groupIcon;

  @override
  void initState() {
    super.initState();
    // Request location permission (necessary on Android, not needed on iOS)
    Location().requestPermission();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/bus-stop-icon.png')
        .then((value) => _stopIcon = value);
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/bus-group-icon.png')
        .then((value) => _groupIcon = value);
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: locator.get<EMTRepository>().getStopList(),
          builder:
              (BuildContext context, AsyncSnapshot<StopListModel> snapshot) {
            if (snapshot.hasData) {
              // Initialize map markers for fluster
              List<MapMarker> mapMarkers = _createMarkers(
                context,
                snapshot.data!,
                _customInfoWindowController,
              );

              // Initialize fluster with created markers
              Fluster<MapMarker> fluster = _initFluster(mapMarkers);

              return Stack(
                children: [
                  GoogleMap(
                    onTap: (position) {
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _customInfoWindowController.googleMapController ??=
                          controller;
                      _updateMarkers(
                        fluster: fluster,
                        updatedZoom: _currentZoom,
                      );
                    },
                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                      _updateMarkers(
                        fluster: fluster,
                        updatedZoom: position.zoom,
                      );
                    },
                    myLocationEnabled: true,
                    minMaxZoomPreference: const MinMaxZoomPreference(9.0, null),
                    markers: _googleMarkers.toSet(),
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(40.41317, -3.68307),
                      zoom: 15.0,
                    ),
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    offset: 25.0,
                    height: 150,
                    width: 200,
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  List<MapMarker> _createMarkers(
    BuildContext context,
    StopListModel stopList,
    CustomInfoWindowController customInfoWindowController,
  ) {
    List<MapMarker> markers = <MapMarker>[];

    for (var i in stopList.data) {
      final LatLng position = LatLng(
        i.geometry.coordinates.last,
        i.geometry.coordinates.first,
      );

      // Sort line numbers
      i.lines.sort((a, b) => int.parse(a.substring(0, a.length - 2))
          .compareTo(int.parse(b.substring(0, b.length - 2))));

      markers.add(
        MapMarker(
          id: 'stop-${i.node}',
          onTap: () => customInfoWindowController.addInfoWindow!(
            MarkerInfoWindow(i: i),
            position,
          ),
          position: position,
          icon: _stopIcon,
        ),
      );
    }
    return markers;
  }

  Fluster<MapMarker> _initFluster(List<MapMarker> markers) {
    return Fluster<MapMarker>(
      minZoom: 0, // The min zoom at clusters will show
      maxZoom: 14, // The max zoom at clusters will show
      radius: 300, // Cluster radius in pixels
      extent: 2048, // Tile extent. Radius is calculated with it.
      nodeSize: 64, // Size of the KD-tree leaf node.
      points: markers, // The list of markers created before
      createCluster: (
        // Create cluster marker
        BaseCluster? cluster,
        double? lng,
        double? lat,
      ) =>
          MapMarker(
        id: cluster!.id.toString(),
        position: LatLng(lat!, lng!),
        icon: _groupIcon,
        onTap: () {},
        isCluster: cluster.isCluster,
        clusterId: cluster.id,
        pointsSize: cluster.pointsSize,
        childMarkerId: cluster.childMarkerId,
      ),
    );
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers(
      {Fluster<MapMarker>? fluster, double? updatedZoom}) async {
    if (updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await getClusterMarkers(
      fluster,
      _currentZoom,
    );

    _googleMarkers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {});
  }

  /// Gets a list of markers and clusters that reside within the visible bounding box for
  /// the given [currentZoom]. For more info check [Fluster.clusters].
  Future<List<Marker>> getClusterMarkers(
    Fluster<MapMarker>? fluster,
    double currentZoom,
  ) {
    if (fluster == null) return Future.value([]);

    return Future.wait(fluster.clusters(
      [-180, -85, 180, 85],
      currentZoom.toInt(),
    ).map((mapMarker) async {
      return mapMarker.toMarker();
    }).toList());
  }

  // Future<BitmapDescriptor> _getCustomIcon(GlobalKey iconKey) async {
  //   Future<Uint8List> _capturePng(GlobalKey iconKey) async {
  //     RenderRepaintBoundary boundary =
  //         iconKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     var pngBytes = byteData!.buffer.asUint8List();
  //     return pngBytes;
  //   }

  //   Uint8List imageData = await _capturePng(iconKey);
  //   return BitmapDescriptor.fromBytes(imageData);
  // }
}

class MarkerInfoWindow extends StatelessWidget {
  const MarkerInfoWindow({
    Key? key,
    required this.i,
  }) : super(key: key);

  final Data i;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<StopInfoBloc>().add(GetStopInfo(stopId: i.node));
        Navigator.pushNamed(context, DetailScreen.route,
            arguments: ScreenArguments(stopId: i.node));
      },
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            color: Colors.grey.shade50,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: FaIcon(
                            FontAwesomeIcons.bus,
                            color: Colors.blue,
                            size: 12.0,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              i.name,
                              style: AppTheme.waitingTimeSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Wrap(
                      children: List.generate(
                        i.lines.length,
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
                                    i.lines[stopLine].characters.first == 'N'
                                        ? [Colors.black, Colors.grey.shade700]
                                        : [
                                            Colors.blue.shade700,
                                            Colors.blue.shade400
                                          ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: Text(
                                int.parse(i.lines[stopLine].substring(
                                        0, i.lines[stopLine].length - 2))
                                    .toString(),
                                style: AppTheme.lineNumber
                                    .copyWith(fontSize: 10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Triangle.isosceles(
            edge: Edge.BOTTOM,
            child: Container(
              color: Colors.grey.shade50,
              width: 20.0,
              height: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
