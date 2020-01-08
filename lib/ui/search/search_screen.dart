import 'package:flickr_viewer/presentation/photo_bloc.dart';
import 'package:flickr_viewer/ui/search/widgets/search_result.dart';
import 'package:flickr_viewer/ui/search/widgets/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../base/base_screen.dart';

class SearchScreen extends BaseScreen {
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseScreenState<SearchScreen, PhotoBloc> {

  @override
  Widget provideChild() {
    return Scaffold(
      appBar: SearchView(
        foregroundColor: Colors.white,
        hint: 'Search',
        onQueryChanged: (s) {
          if (s.trim().isEmpty) {
            bloc.resetSearch();
          } else {
            bloc.onKeywordChanged(s.trim());
          }
        },
      ),
      body: SearchResult(),
    );
  }
}
