import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_emt/data/models/screen_arguments.dart';

import 'package:open_emt/domain/bloc/favorite_stops_bloc/favorite_stops_bloc.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:open_emt/views/screens/detail_screen/detail_screen.dart';
import 'package:open_emt/views/theme/theme.dart';

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
        onTap: () async {
          context
              .read<StopInfoBloc>()
              .add(GetStopInfo(stopId: state.stops[index].label));
          await Navigator.pushNamed(context, DetailScreen.route,
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
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Nombre de la parada:'),
                content: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(hintText: "Ej: Casa"),
                    onSubmitted: (value) {
                      context.read<FavoriteStopsBloc>().add(FavoriteUpdated(
                            state.stops[index],
                            {'Direction': value},
                          ));
                      Navigator.pop(context);
                    }),
              );
            },
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
