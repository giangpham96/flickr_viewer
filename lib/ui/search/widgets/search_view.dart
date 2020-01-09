import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../../../common/stream_extensions.dart';

class SearchView extends StatefulWidget implements PreferredSizeWidget {
  SearchView({
    Key key,
    this.onQueryChanged,
    this.bottom,
    this.foregroundColor = Colors.white,
    this.hint,
    this.searchController,
  })  : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  @override
  final Size preferredSize;

  final void Function(String) onQueryChanged;

  final PreferredSizeWidget bottom;

  final Color foregroundColor;

  final String hint;

  final TextEditingController searchController;

  @override
  _SearchViewState createState() {
    return _SearchViewState();
  }
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _controller;

  TextEditingController get _searchController =>
      widget.searchController ?? _controller;

  PublishSubject<String> _queryEmitter = PublishSubject();

  @override
  void initState() {
    super.initState();
    if (widget.searchController == null) {
      _controller = TextEditingController();
    }
    _searchController.addListener(_onTextChanged);
    _queryEmitter
        .debounceTime(Duration(milliseconds: 500))
        .listen((q) => widget.onQueryChanged?.call(q));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onTextChanged);
    _queryEmitter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      bottom: widget.bottom,
      title: TextField(
        controller: _searchController,
        style: TextStyle(
          color: widget.foregroundColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: widget.foregroundColor),
                  onPressed: () {
                    // This Future is a work around for a known bug of flutter
                    // Refer to https://github.com/flutter/flutter/issues/35848
                    Future.delayed(Duration(milliseconds: 10)).then((_) {
                      _searchController.clear();
                    });
                  },
                )
              : null,
          hintText: widget.hint ?? '',
          hintStyle: TextStyle(color: widget.foregroundColor),
        ),
      ),
    );
  }

  _onTextChanged() {
    final s = _searchController.text;
    var query = s.trim();
    _queryEmitter.addIfNotClosed(query);
    setState(() {});
  }
}
