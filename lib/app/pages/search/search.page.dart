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

  //Removes accents from string by replacing them with an equivalent
  String stringWithoutDiacritics(String sentence){
    sentence = sentence.toLowerCase();
    //Spanish accents
    sentence = sentence.replaceAll(new RegExp(r'á'), 'a');
    sentence = sentence.replaceAll(new RegExp(r'é'), 'e');
    sentence = sentence.replaceAll(new RegExp(r'í'), 'i');
    sentence = sentence.replaceAll(new RegExp(r'ó'), 'o');
    sentence = sentence.replaceAll(new RegExp(r'ú'), 'u');

    return sentence;
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
          var results = []; 
          var filters = [];
          //Filter neighboorhoods based on user input 
          if(text != ""){
            //Split filter into a list of words
            filters = text.split(" ");

            for (int i = 0; i < copyOfItems.length; i++) {
              bool shouldBeDisplayed = true;
              //Test each filter to check if neighborhood contains all filters 
              filters.forEach((filter){
                
                //Remove accents in filter
                var filterCleaned = stringWithoutDiacritics(filter);
                
                //Remove accents in item list
                var itemCleaned = stringWithoutDiacritics(copyOfItems[i]); 
                shouldBeDisplayed = shouldBeDisplayed && 
                  itemCleaned.contains(filterCleaned);
              });
              //Store neighborhood that contains all filters
              if(shouldBeDisplayed) results.add(copyOfItems[i]);
            }

            items = results;
          }else{
            //If User input is empty string then return all neighborhoods
            items = copyOfItems;
          }
          
          //items = List.from(copyOfItems);
          
          // items = items
          //     .where((item) => item
          //         .toString()
          //         .toLowerCase()
          //         .contains(text.toLowerCase().trim()))
          //     .toList();

          setState(() {});
        }).build();
  }
}
