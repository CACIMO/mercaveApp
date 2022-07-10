import 'package:flutter/material.dart';
import 'package:mercave/app/pages/search/search.page.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class StepOneUI {
  final BuildContext context;
  final List neighborhoods;
  final List streets;
  final Function onSelectedNeighborhood;
  final Function onSelectedStreet;
  final Function ontextCtrlPlatePart1;
  final Function ontextCtrlPlatePart2;
  final Function ontextCtrlPlatePart3;
  final Function onTextCtrlAdditionalInfo;

  final int userId;
  final bool loading;
  final bool error;
  
  GlobalKey formKey;
  TextEditingController selectedNeighborhoodUI;
  TextEditingController selectedStreetUI;
  TextEditingController textCtrlPlatePart1UI;
  TextEditingController textCtrlPlatePart2UI;
  TextEditingController textCtrlPlatePart3UI;
  TextEditingController textCtrlAdditionalInfo;

  StepOneUI(
      {@required this.context,
      @required this.neighborhoods,
      @required this.streets,
      @required this.selectedNeighborhoodUI,
      @required this.selectedStreetUI,
      @required this.onSelectedNeighborhood,
      @required this.onSelectedStreet,
      @required this.ontextCtrlPlatePart1,
      @required this.ontextCtrlPlatePart2,
      @required this.ontextCtrlPlatePart3,
      @required this.onTextCtrlAdditionalInfo,
      @required this.textCtrlPlatePart1UI,
      @required this.textCtrlPlatePart2UI,
      @required this.textCtrlPlatePart3UI,
      @required this.textCtrlAdditionalInfo,
      @required this.userId,
      @required this.loading,
      @required this.error,
      @required this.formKey});

  Widget build() {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Barrio',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: kCustomPrimaryColor,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 55.0,
                    child: TextFormField(
                        cursorColor: kCustomPrimaryColor,

                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: selectedNeighborhoodUI == null
                            ? ''
                            : selectedNeighborhoodUI,
                        validator: (value) {
                          if (value == '') {
                            return 'Debe Seleccionar un barrio.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          selectedNeighborhoodUI.text = value;
                        },
                        onTap: () async {
                          final itemSelected = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(
                                items: neighborhoods,
                                hintText: 'Seleccione el barrio',
                                noItemsFoundText:
                                    'No se han encontrado resultados',
                              ),
                            ),
                          );

                          if (itemSelected != null && itemSelected is String) {
                            onSelectedNeighborhood(itemSelected);
                          }
                        },
                        readOnly: true,
                        decoration: new InputDecoration(
                          suffixIcon: GestureDetector(
                            child: Icon(Icons.arrow_forward,color: kCustomPrimaryColor,),
                          ),
                          hintText: 'Seleccione el barrio',
                          hintStyle: TextStyle(color: kCustomHintColor),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kCustomPrimaryColor,
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Ingrese la dirección',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: kCustomPrimaryColor,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 55.0,
                    child: TextFormField(
                      cursorColor: kCustomPrimaryColor,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller:
                            selectedStreetUI == null ? '' : selectedStreetUI,
                        validator: (value) {
                          if (value == '') {
                            return 'Debe Seleccionar un tipo de via.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          selectedStreetUI.text = value;
                        },
                        onTap: () async {
                          final itemSelected = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(
                                items: streets,
                                hintText: 'Seleccione el tipo de vía',
                                noItemsFoundText:
                                    'No se han encontrado resultados',
                              ),
                            ),
                          );

                          if (itemSelected != null && itemSelected is String) {
                            onSelectedStreet(itemSelected);
                          }
                        },
                        readOnly: true,
                        decoration: new InputDecoration(
                          suffixIcon: GestureDetector(
                            child: Icon(Icons.arrow_forward,color: kCustomPrimaryColor),
                          ),
                          hintText: 'Seleccione el tipo de vía',
                          hintStyle: TextStyle(color: kCustomHintColor),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kCustomPrimaryColor,
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    cursorColor: kCustomPrimaryColor,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: textCtrlPlatePart1UI == null
                        ? ''
                        : textCtrlPlatePart1UI,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      hintText: '12 Sur',
                      hintStyle: TextStyle(color: kCustomHintColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kCustomPrimaryColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Requerido';
                      } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                        return 'Invalido';
                      }

                      return null;
                    },
                    onSaved: ontextCtrlPlatePart1,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '#',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    cursorColor: kCustomPrimaryColor,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: textCtrlPlatePart2UI == null
                        ? ''
                        : textCtrlPlatePart2UI,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      hintText: '34',
                      hintStyle: TextStyle(color: kCustomHintColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kCustomPrimaryColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Requerido';
                      } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                        return 'Invalido';
                      }

                      return null;
                    },
                    onSaved: ontextCtrlPlatePart2,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '-',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    cursorColor: kCustomPrimaryColor,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: textCtrlPlatePart3UI == null
                        ? ''
                        : textCtrlPlatePart3UI,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      hintText: '26',
                      hintStyle: TextStyle(color: kCustomHintColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kCustomPrimaryColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Requerido';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Invalido';
                      }

                      return null;
                    },
                    onSaved: ontextCtrlPlatePart3,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    cursorColor: kCustomPrimaryColor,
                    controller: textCtrlAdditionalInfo == null
                        ? ''
                        : textCtrlAdditionalInfo,
                    textAlign: TextAlign.left,
                    decoration: new InputDecoration(
                      hintText: 'Informal adicional',
                      hintStyle: TextStyle(color: kCustomHintColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kCustomPrimaryColor,
                        ),
                      ),
                    ),
                    onSaved: onTextCtrlAdditionalInfo,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
