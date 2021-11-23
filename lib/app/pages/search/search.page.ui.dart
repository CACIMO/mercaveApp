import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';

class SearchPageUI {
  final BuildContext context;
  final List items;
  final String hintText;
  final String noItemsFoundText;
  final Function onTextSearchChanged;
  final Function onItemSelected;

  TextEditingController searchTextController = TextEditingController();
  List itemsCopy;

  SearchPageUI({
    @required this.context,
    @required this.items,
    @required this.hintText,
    @required this.noItemsFoundText,
    @required this.onTextSearchChanged,
    @required this.onItemSelected,
  }) {
    itemsCopy = List.from(items);
  }

  build() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomWhiteColor),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBarWidget(),
        body: items.length == 0
            ? _getNoItemsFoundWidget()
            : _getItemsFoundWidget(),
      ),
    );
  }

  Widget _getAppBarWidget() {
    return AppBar(
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Image.asset(
                    'assets/icons/back_arrow.png',
                    width: 25.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: TextField(
              autofocus: true,
              decoration: new InputDecoration(
                hintText: hintText,
              ),
              onChanged: (text) {
                onTextSearchChanged(text);
              },
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNoItemsFoundWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              noItemsFoundText,
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }

  Widget _getItemsFoundWidget() {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          onTap: () {
            onItemSelected(items[index]);
          },
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
        height: 1.0,
      ),
    );
  }
}
