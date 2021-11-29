import 'package:flutter/material.dart';
import 'package:mercave/app/pages/search/search.page.ui.dart';

class SearchPage extends StatefulWidget {
  final List items;
  final String hintText;
  final String noItemsFoundText;

  SearchPage({
    @required this.items,
    @required this.hintText,
    @required this.noItemsFoundText,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List items;
  List copyOfItems;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    copyOfItems = List.from(items);
  }

  @override
  Widget build(BuildContext context) {
    return SearchPageUI(
        context: context,
        items: items,
        hintText: widget.hintText,
        noItemsFoundText: widget.noItemsFoundText,
        onItemSelected: (item) {
          Navigator.pop(context, item);
        },
        onTextSearchChanged: (text) {
          items = List.from(copyOfItems);
          items = items
              .where((item) => item
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase().trim()))
              .toList();

          setState(() {});
        }).build();
  }
}
