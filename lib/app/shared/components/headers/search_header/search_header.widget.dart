import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/headers/search_header/search_header.widget.ui.dart';

class SearchHeaderWidget extends StatefulWidget {
  final String textToSearch;
  final Function onSearchSubmitted;
  final Function onCloseButtonTapped;

  SearchHeaderWidget({
    @required this.textToSearch,
    @required this.onSearchSubmitted,
    @required this.onCloseButtonTapped,
  });

  @override
  _SearchHeaderWidgetState createState() => _SearchHeaderWidgetState();
}

class _SearchHeaderWidgetState extends State<SearchHeaderWidget> {
  TextEditingController searchTextController;

  @override
  void initState() {
    super.initState();
    setState(() {
      searchTextController = TextEditingController(text: widget.textToSearch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchHeaderWidgetUI(
      context: context,
      textToSearch: widget.textToSearch,
      onSearchSubmitted: widget.onSearchSubmitted,
      onCloseButtonTapped: widget.onCloseButtonTapped,
      searchTextController: searchTextController,
      onChangedText: (text) {},
    ).build();
  }
}
