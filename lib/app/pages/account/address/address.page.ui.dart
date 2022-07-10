import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail_stepper_controller.dart';
import 'package:mercave/app/pages/store/cart/order_detail/step_one.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class AddressPageUI {
  final BuildContext context;
  final int userId;
  final bool loading;
  final bool error;
  final Function onError;

  //Data related to Step One
  List<String> neighborhoods = [];
  final _stepOneForm = GlobalKey<FormState>();
  TextEditingController selectedNeighborhood = TextEditingController();
  TextEditingController selectedStreet = TextEditingController();
  TextEditingController textCtrlPlatePart1 = TextEditingController();
  TextEditingController textCtrlPlatePart2 = TextEditingController();
  TextEditingController textCtrlPlatePart3 = TextEditingController();
  TextEditingController textCtrlAdditionalInfo = TextEditingController();
  
  AddressPageUI({
    @required this.context,
    @required this.neighborhoods,
    @required this.selectedNeighborhood,
    @required this.selectedStreet,
    @required this.textCtrlPlatePart1,
    @required this.textCtrlPlatePart2,
    @required this.textCtrlPlatePart3,
    @required this.textCtrlAdditionalInfo,
    @required this.userId,
    @required this.loading,
    @required this.error,
    @required this.onError,
  });
  Widget _getAppBarWidget() {
    return AppBar(
      backgroundColor: kCustomPrimaryColor,
      automaticallyImplyLeading: false,
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
                    color:kCustomWhiteColor,
                    width: 25.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Verífique los datos de envío',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  saveAddress() {
    if (_stepOneForm.currentState.validate()) {
      OrderDetailStepperController.saveStepOneDataToLocalStorage(
              selectedNeighborhood.text,
              selectedStreet.text,
              textCtrlPlatePart1.text,
              textCtrlPlatePart2.text,
              textCtrlPlatePart3.text,
              textCtrlAdditionalInfo.text,
              userId,
              context, true)
          .then((value) {
        if (value) {
          Navigator.pop(context, false);
        }
      });
    }
  }
  // ----------------------------  FIELD METHODS ---------------------------

  onSelectedNeighborhood(String neighborhood) {
    selectedNeighborhood.text = neighborhood;
  }

  onStreetSelected(String street) {
    selectedStreet.text = street;
  }

  ontextCtrlPlatePart1(String textCtrlPlatePartUI) {
    textCtrlPlatePart1.text = textCtrlPlatePartUI;
  }

  ontextCtrlPlatePart2(String textCtrlPlatePart2UI) {
    textCtrlPlatePart2.text = textCtrlPlatePart2UI;
  }

  ontextCtrlPlatePart3(String textCtrlPlatePart3UI) {
    textCtrlPlatePart3.text = textCtrlPlatePart3UI;
  }

  onTextCtrlAdditionalInfo(String textCtrlAdditionalInfoUI) {
    textCtrlAdditionalInfo.text = textCtrlAdditionalInfoUI;
  }

  Widget build() {
    if (loading || error) {
      return PageLoaderWidget(
        error: error,
        onError: onError,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomWhiteColor),
      home: Scaffold(
          appBar: _getAppBarWidget(),
          body: Container(
            height: double.infinity,
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StepOne(
                  neighborhoods: neighborhoods,
                  formKey: _stepOneForm,
                  onSelectedNeighborhood: onSelectedNeighborhood,
                  onStreetSelected: onStreetSelected,
                  ontextCtrlPlatePart1: ontextCtrlPlatePart1,
                  ontextCtrlPlatePart2: ontextCtrlPlatePart2,
                  ontextCtrlPlatePart3: ontextCtrlPlatePart3,
                  onTextCtrlAdditionalInfo: onTextCtrlAdditionalInfo,
                  selectedNeighborhood: selectedNeighborhood, //Barrio
                  selectedStreet: selectedStreet, //tipo de via
                  textCtrlPlatePart1: textCtrlPlatePart1, // dirección parte 1
                  textCtrlPlatePart2: textCtrlPlatePart2, // dirección parte 2
                  textCtrlPlatePart3: textCtrlPlatePart3, // dirección parte 3
                  textCtrlAdditionalInfo: textCtrlAdditionalInfo, // Información adicional
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: saveAddress,
                  child: Text(
                    'guardar',
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 13.0),
                    primary: kCustomPrimaryColor,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
            ]),
          )
          // Column(children: [
          //   Container(
          //     alignment: Alignment.centerLeft,
          //     child: Padding(
          //       padding: EdgeInsets.all(16.0),
          //       child: StepOne(
          //         neighborhoods: neighborhoods,
          //         formKey: _stepOneForm,
          //         onSelectedNeighborhood: onSelectedNeighborhood,
          //         onStreetSelected: onStreetSelected,
          //         ontextCtrlPlatePart1: ontextCtrlPlatePart1,
          //         ontextCtrlPlatePart2: ontextCtrlPlatePart2,
          //         ontextCtrlPlatePart3: ontextCtrlPlatePart3,
          //         onTextCtrlAdditionalInfo: onTextCtrlAdditionalInfo,
          //         selectedNeighborhood: selectedNeighborhood, //Barrio
          //         selectedStreet: selectedStreet, //tipo de via
          //         textCtrlPlatePart1: textCtrlPlatePart1, // dirección parte 1
          //         textCtrlPlatePart2: textCtrlPlatePart2, // dirección parte 2
          //         textCtrlPlatePart3: textCtrlPlatePart3, // dirección parte 3
          //         textCtrlAdditionalInfo:
          //             textCtrlAdditionalInfo, // Información adicional
          //       ),
          //     ),
          //   ),
          //   Container(
          //     width:MediaQuery.of(context).size.width -32,
          //     child: ElevatedButton(
          //       onPressed: saveAddress,
          //       child: Text(
          //         'guardar',
          //         style: TextStyle(fontSize: 17),
          //       ),
          //       style: ElevatedButton.styleFrom(
          //         padding: EdgeInsets.symmetric(vertical: 13.0),
          //         primary: kCustomPrimaryColor,
          //         onPrimary: Colors.white,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(32.0),
          //         ),
          //       ),
          //     ),
          //   ),
          // ]),
          ),
    );
  }
}
