import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../common/context_extensions.dart';

class FooterState {
  const FooterState._();

  factory FooterState.loadingFooter() => const FooterState._();
}

class LoadingFailedFooter extends FooterState {
  final Function(BuildContext context) failureBuilder;

  LoadingFailedFooter(this.failureBuilder) : super._();
}

class PaginatedGridView extends StatefulWidget {
  final int crossAxisCount;
  final int itemCount;
  final double childAspectRatio;
  final VoidCallback onNextPage;
  final Function(BuildContext context, int position) itemBuilder;
  final Widget Function(BuildContext context) progressBuilder;
  final FooterState footerState;

  PaginatedGridView({
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.onNextPage,
    this.childAspectRatio = 1,
    this.progressBuilder,
    this.footerState,
    this.crossAxisCount = 2,
  });

  @override
  _PaginatedGridViewState createState() => _PaginatedGridViewState();
}

class _PaginatedGridViewState extends State<PaginatedGridView> {
  @override
  Widget build(BuildContext context) {
    final widgetState = widget.footerState;

    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification sn) {
          if (widgetState != null)
            return true;
          if (sn is ScrollUpdateNotification &&
              sn.metrics.pixels >
                  sn.metrics.maxScrollExtent -
                      context.getScreenHeight() / 2) {
            widget.onNextPage();
          }
          return true;
        },
        child: _renderList(widgetState));
  }

  Widget _renderList(FooterState footerState) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            childAspectRatio: widget.childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            widget.itemBuilder,
            childCount: widget.itemCount,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: true,
          ),
        ),
        if (footerState == FooterState.loadingFooter())
          SliverToBoxAdapter(
            child: widget.progressBuilder?.call(context) ?? _defaultLoading(),
          ),
        if (footerState is LoadingFailedFooter)
          SliverToBoxAdapter(
            child: footerState.failureBuilder(context),
          )
      ],
    );
  }

  Widget _defaultLoading() {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
