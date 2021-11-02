import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_emt/data/models/screen_arguments.dart';
import 'package:open_emt/data/models/stop_list_model.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:open_emt/domain/repositories/emt_repository.dart';
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
              return Stack(
                children: [
                  GoogleMap(
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                      myLocationEnabled: true,
                      minMaxZoomPreference:
                          const MinMaxZoomPreference(15.0, null),
                      markers: _createMarkers(
                        context,
                        snapshot.data!,
                        _customInfoWindowController,
                      ),
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(40.41317, -3.68307),
                        zoom: 15.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _customInfoWindowController.googleMapController ??=
                            controller;
                      }),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    offset: 0.0,
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

  Set<Marker> _createMarkers(
    BuildContext context,
    StopListModel stopList,
    CustomInfoWindowController customInfoWindowController,
  ) {
    Set<Marker> markers = <Marker>{};

    for (var i in stopList.data) {
      final LatLng position = LatLng(
        i.geometry.coordinates.last,
        i.geometry.coordinates.first,
      );

      // Sort line numbers
      i.lines.sort((a, b) => int.parse(a.substring(0, a.length - 2))
          .compareTo(int.parse(b.substring(0, b.length - 2))));

      markers.add(
        Marker(
          markerId: MarkerId('stop-${i.node}'),
          onTap: () => customInfoWindowController.addInfoWindow!(
            GestureDetector(
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
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
                                        colors: i.lines[stopLine].characters
                                                    .first ==
                                                'N'
                                            ? [
                                                Colors.black,
                                                Colors.grey.shade700
                                              ]
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
                                        i.lines[stopLine].substring(
                                            0, i.lines[stopLine].length - 2),
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
            ),
            position,
          ),
          position: position,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }
    return markers;
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
