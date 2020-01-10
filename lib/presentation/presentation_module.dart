import 'package:flickr_viewer/presentation/photo_bloc.dart';
import 'package:get_it/get_it.dart';

presentationModule() {
  GetIt.instance.registerFactory<PhotoBloc>(
    () => PhotoBloc(GetIt.instance.get(), GetIt.instance.get()),
  );
}
