import 'package:flickr_viewer/presentation/base/bloc.dart';
import 'package:flickr_viewer/ui/base/base_bloc_provider.dart';
import 'package:flutter/widgets.dart';

abstract class BaseBlocAwareWidget extends StatefulWidget {}

abstract class BaseBlocAwareState<S extends BaseBlocAwareWidget,
    B extends BaseBloc, VS> extends State<S> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getStream(bloc),
      builder: (context, snapshot) => render(context, snapshot.data),
    );
  }

  Stream<VS> getStream(B bloc);

  B get bloc => BlocProvider.of<B>(context);

  Widget render(BuildContext context, VS viewState);
}
