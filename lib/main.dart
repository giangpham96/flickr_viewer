import 'package:flickr_viewer/common/config/secret_provider.dart';
import 'package:flickr_viewer/data/data_module.dart';
import 'package:flickr_viewer/domain/domain_module.dart';
import 'package:flickr_viewer/presentation/presentation_module.dart';
import 'package:flickr_viewer/remote/remote_module.dart';
import 'package:flickr_viewer/ui/app_module.dart';
import 'package:flickr_viewer/ui/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appModule(await SecretLoader('assets/secret.json').load());
  remoteModule();
  dataModule();
  domainModule();
  presentationModule();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetIt.instance.ready,
      builder: (_, __) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SearchScreen(),
      ),
    );
  }
}
