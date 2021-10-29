import 'package:flutter/material.dart';
import 'package:open_emt/data/models/stop_model.dart';

class DetailTitle extends StatelessWidget {
  final StopInfo stopInfo;

  const DetailTitle({required this.stopInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Parada nº${stopInfo.label}'),
        const SizedBox(height: 5.0),
        Text(
          stopInfo.direction,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14.0),
        ),
        // Row(
        //   children: [
        //     for (int i = 0; i < stopInfo.stopLines.data.length; i++)
        //       Card(
        //         color: stopInfo.stopLines.data[i].label[0] == 'N'
        //             ? Colors.black
        //             : Colors.blue,
        //         child: Text(
        //           stopInfo.stopLines.data[i].label,
        //           style: AppTheme.lineNumber,
        //         ),
        //       ),
        //   ],
        // )
      ],

      // ListView.builder(
      //   physics: const BouncingScrollPhysics(),
      //   scrollDirection: Axis.horizontal,
      //   itemCount: stopInfo.stopLines.data.length,
      //   itemBuilder: (context, i) => Card(
      //     margin: const EdgeInsets.only(
      //       top: 10.0,
      //       left: 15.0,
      //       bottom: 10.0,
      //     ),
      //     elevation: 4.0,
      //     color: Colors.blue,
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Text(
      //         stopInfo.stopLines.data[i].label,
      //         style: AppTheme.lineNumber,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
