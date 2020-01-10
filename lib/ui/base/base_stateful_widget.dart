import 'package:flickr_viewer/presentation/base/bloc.dart';
import 'package:flickr_viewer/ui/base/base_bloc_provider.dart';
import 'package:flutter/widgets.dart';

abstract class BaseBlocAwareWidget extends StatefulWidget {}

abstract class BaseBlocAwareState<S extends BaseBlocAwareWidget,
    B extends BaseBloc, VS> extends State<S> {

  Stream<VS> _stream;
  @override
  void initState() {
    _stream = getStream(bloc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.data != null)
         return render(context, snapshot.data);
        return const SizedBox.shrink();
      },
    );
  }

  Stream<VS> getStream(B bloc);

  B get bloc => BlocProvider.of<B>(context);

  Widget render(BuildContext context, VS viewState);
}
