import 'package:flutter/material.dart';
import 'package:open_emt/data/models/stop_model.dart';
import 'package:open_emt/views/theme/theme.dart';
import 'package:open_emt/utils/string_extension.dart';

class ArriveInfoWidget extends StatelessWidget {
  final List<Arrive> arriveInfo;

  const ArriveInfoWidget({required this.arriveInfo, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      left: 15.0,
                      bottom: 10.0,
                    ),
                    elevation: 4.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          colors: arriveInfo.first.line[0] == 'N'
                              ? [Colors.black, Colors.grey.shade700]
                              : [Colors.blue.shade700, Colors.blue.shade400],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: Text(
                          arriveInfo.first.line,
                          style: AppTheme.lineNumber,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Row(
                            children: arriveInfo[0].estimateArrive < 30
                                ? [
                                    const Text(
                                      '<<<',
                                      style: AppTheme.waitingTime,
                                    )
                                  ]
                                : [
                                    Text(
                                      '${(arriveInfo[0].estimateArrive / 60).round()}min',
                                      style: AppTheme.waitingTime,
                                    ),
                                    const Text(
                                      ' | ',
                                      style: AppTheme.waitingTime,
                                    ),
                                    Text(
                                      '${arriveInfo[0].distanceBus}m',
                                      style: AppTheme.waitingTime,
                                    ),
                                  ]),
                        const SizedBox(height: 5.0),
                        Row(
                            children: arriveInfo[1].estimateArrive < 30
                                ? [
                                    const Text(
                                      '<<<',
                                      style: AppTheme.waitingTimeSecondary,
                                    )
                                  ]
                                : [
                                    Text(
                                      '${(arriveInfo[1].estimateArrive / 60).round()}min',
                                      style: AppTheme.waitingTimeSecondary,
                                    ),
                                    const Text(
                                      ' | ',
                                      style: AppTheme.waitingTimeSecondary,
                                    ),
                                    Text(
                                      '${arriveInfo[1].distanceBus}m',
                                      style: AppTheme.waitingTimeSecondary,
                                    ),
                                  ]),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      arriveInfo.first.destination.toLowerCase().toTitleCase(),
                      style: AppTheme.waitingTime,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
