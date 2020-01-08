import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../../../common/stream_extensions.dart';

class SearchView extends StatefulWidget implements PreferredSizeWidget {
  SearchView(
      {Key key,
      this.onQueryChanged,
      this.bottom,
      this.foregroundColor = Colors.white,
      this.hint})
      : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  @override
  final Size preferredSize;

  final void Function(String) onQueryChanged;

  final PreferredSizeWidget bottom;

  final Color foregroundColor;

  final String hint;

  @override
  _SearchViewState createState() {
    return _SearchViewState();
  }
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchQuery = new TextEditingController();
  bool _showClearButton = false;
  PublishSubject<String> _queryEmitter = PublishSubject();

  @override
  void initState() {
    super.initState();
    _queryEmitter
        .debounceTime(Duration(milliseconds: 500))
        .listen((q) => widget.onQueryChanged(q));
  }

  @override
  void dispose() {
    _queryEmitter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      bottom: widget.bottom,
      title: TextField(
        controller: _searchQuery,
        style: TextStyle(
          color: widget.foregroundColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: Icon(Icons.close, color: widget.foregroundColor),
                  onPressed: () => setState(() {
                    _showClearButton = false;
                    // This Future is a work around for a known bug of flutter
                    // Refer to https://github.com/flutter/flutter/issues/35848
                    Future.delayed(Duration(milliseconds: 10)).then((_) {
                      _searchQuery.clear();
                    });
                    _queryEmitter.addIfNotClosed('');
                  }),
                )
              : null,
          hintText: widget.hint ?? '',
          hintStyle: TextStyle(color: widget.foregroundColor),
        ),
        onChanged: (s) {
          setState(() {
            _showClearButton = s.isNotEmpty;
          });
          var query = s.trim();
          if (query.isNotEmpty && widget.onQueryChanged != null) {
            _queryEmitter.addIfNotClosed(query);
          }
        },
      ),
    );
  }
}
