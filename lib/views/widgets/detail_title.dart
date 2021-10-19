import 'package:flutter/material.dart';
import 'package:open_emt/data/models/stop_model.dart';

class DetailTitle extends StatelessWidget {
  final StopInfo stopInfo;
  late final StopLines lines;

  DetailTitle({required this.stopInfo, Key? key}) : super(key: key) {
    lines = stopInfo.stopLines;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Parada nº${stopInfo.label}'),
        // SizedBox(
        //   height: size.height * 0.5,
        //   child: ListView.builder(
        //     physics: const BouncingScrollPhysics(),
        //     scrollDirection: Axis.horizontal,
        //     itemCount: lines.data.length,
        //     itemBuilder: (context, i) => Card(
        //       margin: const EdgeInsets.only(
        //         top: 10.0,
        //         left: 15.0,
        //         bottom: 10.0,
        //       ),
        //       elevation: 4.0,
        //       color: Colors.blue,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(
        //           lines.data[i].label,
        //           style: AppTheme.lineNumber,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
