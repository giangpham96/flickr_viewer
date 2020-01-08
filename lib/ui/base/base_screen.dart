import 'package:flickr_viewer/presentation/base/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'base_bloc_provider.dart';

abstract class BaseScreen extends StatefulWidget {}

abstract class BaseScreenState<S extends BaseScreen, B extends BaseBloc>
    extends State<S> {
  final B _bloc = GetIt.instance.get<B>();
  B get bloc => _bloc;

  Widget provideChild();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      child: provideChild(),
      bloc: _bloc,
    );
  }
}
