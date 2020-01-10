import 'package:flickr_viewer/common/model/keyword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KeywordList extends StatelessWidget {
  final List<Keyword> keywords;
  final Function(String) onKeywordSelected;

  const KeywordList({Key key, this.keywords = const [], this.onKeywordSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (keywords.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(15),
          child: Text(
            'Are you looking for...',
            style: TextStyle(color: Colors.blueAccent, fontSize: 20),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _mapKeywordToTile(keywords[index]);
            },
            itemCount: keywords.length,
          ),
        ),
      ],
    );
  }

  Widget _mapKeywordToTile(Keyword keyword, {int nestedLevel = 0}) {
    if (keyword.subKeywords?.isEmpty ?? true) {
      return ListTile(
        title: GestureDetector(
          onTap: () => onKeywordSelected?.call(keyword.keyword),
          child: Container(
            padding: EdgeInsets.only(left: nestedLevel * 15.0),
            child: Text(
              keyword.keyword,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      );
    } else {
      return ExpansionTile(
        title: GestureDetector(
          onTap: () => onKeywordSelected?.call(keyword.keyword),
          child: Container(
            padding: EdgeInsets.only(left: nestedLevel * 15.0),
            child: Text(
              keyword.keyword,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
        children: keyword.subKeywords
            .map((k) => _mapKeywordToTile(k, nestedLevel: nestedLevel + 1))
            .toList(),
      );
    }
  }
}
