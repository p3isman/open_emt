import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  /// Static named route for page
  static const String route = '/home';

  /// Static method to return the widget as a PageRoute
  static Route go() =>
      MaterialPageRoute<void>(builder: (_) => const HomeScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('OpenEMT'),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            TextField(
              keyboardType: TextInputType.number,
              onSubmitted: (value) =>
                  context.read<StopInfoBloc>().add(GetStopInfo(stopId: value)),
            ),
            BlocBuilder<StopInfoBloc, StopInfoState>(
              builder: (context, state) {
                if (state is StopInfoLoaded) {
                  return Text(state.stopInfo.toString());
                } else if (state is StopInfoLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ]),
        ),
      ],
    ));
  }
}
