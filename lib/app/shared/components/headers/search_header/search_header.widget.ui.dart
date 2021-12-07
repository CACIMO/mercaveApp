import 'package:flutter/material.dart';
import 'package:mercave/app/pages/store/cart/cart_detail/cart_detail.page.dart';

class SearchHeaderWidgetUI {
  final BuildContext context;
  final String textToSearch;
  final Function onSearchSubmitted;
  final Function onCloseButtonTapped;
  final Function onChangedText;

  TextEditingController searchTextController;

  SearchHeaderWidgetUI({
    this.context,
    this.textToSearch,
    this.onSearchSubmitted,
    this.onCloseButtonTapped,
    this.searchTextController,
    this.onChangedText,
  });

  Widget build() {
    return ListTile(
        //leading: ,
        title: Row(
      children: <Widget>[
        _getLeftButtonsWidget(),
        Expanded(
          flex: 1,
          child: _getSearchInputWidget(),
        ),
        _getRightButtonsWidget()
      ],
    ));
  }

  Widget _getSearchInputWidget() {
    return TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      controller: searchTextController,
      decoration: new InputDecoration(
        hintText: 'Buscar en Merca Vé',
      ),
      onSubmitted: (text) {
        onSearchSubmitted(text);
      },
      onChanged: (text) {
        onChangedText(text);
      },
    );
  }

  Widget _getLeftButtonsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () {
            onCloseButtonTapped();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/icons/back_arrow.png',
              width: 32.0,
            ),
          ),
        )
      ],
    );
  }

  Widget _getRightButtonsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _getClearSearchButtonWidget(),
        _getCartButtonWidget(),
      ],
    );
  }

  Widget _getClearSearchButtonWidget() {
    return InkWell(
      onTap: () {
        searchTextController.text = '';
        onSearchSubmitted(searchTextController.text);
      },
      child: Icon(
        Icons.close,
        size: 38.0,
      ),
    );
  }

  Widget _getCartButtonWidget() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartDetailPage(),
          ),
        );
      },
      child: Image.asset(
        'assets/icons/cart.png',
        width: 38.0,
      ),
    );
  }
}
