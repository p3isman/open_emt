import 'package:flutter/material.dart';
import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/views/theme/theme.dart';
import 'package:open_emt/utils/string_extension.dart';

class ArriveInfoWidget extends StatelessWidget {
  final Arrive arriveInfo;

  const ArriveInfoWidget({required this.arriveInfo, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              margin: const EdgeInsets.only(
                top: 10.0,
                left: 15.0,
                bottom: 10.0,
              ),
              elevation: 4.0,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  arriveInfo.line,
                  style: AppTheme.lineNumber,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                  children: arriveInfo.estimateArrive < 30
                      ? [
                          const Text(
                            '<<<',
                            style: AppTheme.waitingTime,
                          )
                        ]
                      : [
                          Text(
                            '${(arriveInfo.estimateArrive / 60).round()}min',
                            style: AppTheme.waitingTime,
                          ),
                          const Text(
                            ' | ',
                            style: AppTheme.waitingTime,
                          ),
                          Text(
                            '${arriveInfo.distanceBus}m',
                            style: AppTheme.waitingTime,
                          ),
                        ]),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                arriveInfo.destination.toLowerCase().toTitleCase(),
                style: AppTheme.waitingTime,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
