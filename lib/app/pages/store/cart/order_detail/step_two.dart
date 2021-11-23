import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/config.api.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class StepTwo extends StatefulWidget {
  String dayIdSelected;
  String hourIdSelected;
  bool deliveryDateHourError;
  Function getDeliveryDay;
  Function getDeliveryHour;
  List deliveryDays;

  StepTwo({
    @required this.dayIdSelected,
    @required this.hourIdSelected,
    @required this.deliveryDateHourError,
    @required this.getDeliveryDay,
    @required this.getDeliveryHour,
    @required this.deliveryDays
  });

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  bool error = false;
  bool loading = false;

  List deliveryDays;
  List deliveryHoursDaySelected;

  String dayIdSelected;
  String hourIdSelected;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    if(widget.deliveryDays != null)
      deliveryDays = widget.deliveryDays;

    _loadPreviousDataSelected();
  }

  void _loadPreviousDataSelected() async {
    if (widget.dayIdSelected != null) {
      var daySelected = this
          .deliveryDays
          .where((day) => day['id'] == widget.dayIdSelected)
          .toList();

      if (daySelected.length > 0) {
        this.dayIdSelected = widget.dayIdSelected;
      }

      if (this.dayIdSelected != null) {
        var existHourSelected = daySelected[0]['horarios_de_entrega']
            .where((hour) => hour['id'] == widget.hourIdSelected)
            .toList();

        if (existHourSelected.length > 0) {
          this.hourIdSelected = widget.hourIdSelected;
        }
      }
    }

    if (this.dayIdSelected != null) {
      _getDeliveryHoursDaySelected();
    }

  }

  void _getDeliveryHoursDaySelected() {
    List daySelected = deliveryDays.where((deliveryDay) {
      return deliveryDay['id'] == dayIdSelected;
    }).toList();

    if (daySelected != null) {
      setState(() {
        deliveryHoursDaySelected = daySelected[0]['horarios_de_entrega'];
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    if (loading || error) {
      return Container(
        height: MediaQuery.of(context).size.height * .5,
        child: PageLoaderWidget(
          error: error,
          onError: () async {
            await _init();
          },
        ),
      );
    }

    return Column(
      children: <Widget>[
        _getSliderDaysWidget(context: context),
        _getDeliveryHoursWidget(context: context),
        _getErrorMessage(context: context)
      ],
    );
  }

  Widget _getSliderDaysWidget({BuildContext context}) {
    return Container(
      height: 120.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: deliveryDays.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                padding: EdgeInsets.only(right: 5.0),
                color: Colors.white,
                child: RawMaterialButton(
                  fillColor: dayIdSelected == deliveryDays[index]['id']
                      ? kCustomPrimaryColor
                      : kCustomWhiteColor,
                  shape: new CircleBorder(
                    side: BorderSide(
                      color: kCustomPrimaryColor,
                      width: 1.0,
                    ),
                  ),
                  elevation: 1.0,
                  child: Text(
                    deliveryDays[index]['dia'].toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: dayIdSelected == deliveryDays[index]['id']
                          ? kCustomWhiteColor
                          : kCustomPrimaryColor,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      dayIdSelected = deliveryDays[index]['id'];
                      hourIdSelected = null;
                    });

                    widget.getDeliveryDay(dayIdSelected);
                    _getDeliveryHoursDaySelected();
                  },
                ),
              ),
              Text(deliveryDays[index]['nombre_dia'])
            ],
          );
        },
      ),
    );
  }

  Widget _getDeliveryHoursWidget({BuildContext context}) {
    if (deliveryHoursDaySelected == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 16.0),
        child: Text(
          'Por favor seleccione el día de entrega para visualizar '
          'las posibles horas de entrega.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: deliveryHoursDaySelected.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kCustomPrimaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(40.0),
                      color: hourIdSelected ==
                              deliveryHoursDaySelected[index]['id']
                          ? kCustomPrimaryColor
                          : kCustomWhiteColor,
                    ),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              deliveryHoursDaySelected[index]['hora_inicio'] +
                                  ' - ' +
                                  deliveryHoursDaySelected[index]['hora_fin'],
                              style: TextStyle(
                                color: hourIdSelected ==
                                        deliveryHoursDaySelected[index]['id']
                                    ? kCustomWhiteColor
                                    : kCustomPrimaryColor,
                              ),
                            ),
                            Text(
                              StringService.getPriceFormat(
                                number: double.tryParse(
                                  deliveryHoursDaySelected[index]
                                      ['precio_domicilio'],
                                ),
                              ),
                              style: TextStyle(
                                color: hourIdSelected ==
                                        deliveryHoursDaySelected[index]['id']
                                    ? kCustomWhiteColor
                                    : kCustomPrimaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          hourIdSelected =
                              deliveryHoursDaySelected[index]['id'];
                        });

                        widget.getDeliveryHour(hourIdSelected);
                      },
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _getErrorMessage({BuildContext context}) {
    return Visibility(
      visible: widget.deliveryDateHourError,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Text(
              'Debe seleccionar un dia y una hora de entrega',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
