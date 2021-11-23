import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/neighborhood.api.service.dart';
import 'package:mercave/app/pages/store/cart/order_detail/step_one_ui.dart';

class StepOne extends StatefulWidget {
  final List<String> neighborhoods;

  final GlobalKey formKey;
  final Function onSelectedNeighborhood;
  final Function onStreetSelected;
  final Function ontextCtrlPlatePart1;
  final Function ontextCtrlPlatePart2;
  final Function ontextCtrlPlatePart3;
  final Function onTextCtrlAdditionalInfo;
  final TextEditingController selectedNeighborhood;
  final TextEditingController selectedStreet;
  final TextEditingController textCtrlPlatePart1;
  final TextEditingController textCtrlPlatePart2;
  final TextEditingController textCtrlPlatePart3;
  final TextEditingController textCtrlAdditionalInfo;
  
  StepOne({
    @required this.neighborhoods,
    @required this.formKey,
    @required this.onSelectedNeighborhood,
    @required this.onStreetSelected,
    @required this.ontextCtrlPlatePart1,
    @required this.ontextCtrlPlatePart2,
    @required this.ontextCtrlPlatePart3,
    @required this.onTextCtrlAdditionalInfo,
    @required this.selectedNeighborhood,
    @required this.selectedStreet,
    @required this.textCtrlPlatePart1,
    @required this.textCtrlPlatePart2,
    @required this.textCtrlPlatePart3,
    @required this.textCtrlAdditionalInfo,
  });

  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  bool error = false;
  bool loading = false;
  int userId;

  List streets = [
    'Calle',
    'Carrera',
    'Avenida',
    'Avenida Carrera',
    'Circular',
    'Circunvalar',
    'Diagonal',
    'Manzana',
    'Transversal',
    'Via',
  ];

  @override
  void initState() {
    super.initState();
    
    
  }
  
  

  @override
  Widget build(BuildContext context) {
    return StepOneUI(
        context: context,
        neighborhoods: widget.neighborhoods,
        streets: streets,
        selectedNeighborhoodUI: widget.selectedNeighborhood,
        selectedStreetUI: widget.selectedStreet,
        userId: userId,
        onSelectedNeighborhood: widget.onSelectedNeighborhood,
        onSelectedStreet: widget.onStreetSelected,
        ontextCtrlPlatePart1: widget.ontextCtrlPlatePart1,
        ontextCtrlPlatePart2: widget.ontextCtrlPlatePart2,
        ontextCtrlPlatePart3: widget.ontextCtrlPlatePart3,
        onTextCtrlAdditionalInfo: widget.onTextCtrlAdditionalInfo,
        textCtrlPlatePart1UI: widget.textCtrlPlatePart1,
        textCtrlPlatePart2UI: widget.textCtrlPlatePart2,
        textCtrlPlatePart3UI: widget.textCtrlPlatePart3,
        textCtrlAdditionalInfo: widget.textCtrlAdditionalInfo,
        loading: loading,
        error: error,
        formKey: widget.formKey
      ).build();
  }
}
