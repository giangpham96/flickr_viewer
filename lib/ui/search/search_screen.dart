import 'package:flickr_viewer/presentation/photo_bloc.dart';
import 'package:flickr_viewer/ui/search/widgets/search_result.dart';
import 'package:flickr_viewer/ui/search/widgets/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../base/base_screen.dart';

class SearchScreen extends BaseStatefulScreen {

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState
    extends BaseStatefulScreenState<SearchScreen, PhotoBloc> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
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
        searchController: _searchController,
      ),
      body: SearchResult(
        onKeywordChange: (s) {
          _searchController.text = s;
        },
      ),
    );
  }
}
