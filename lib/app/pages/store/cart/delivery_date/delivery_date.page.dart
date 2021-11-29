import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/config.api.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class DeliveryDatePage extends StatefulWidget {
  @override
  _DeliveryDateState createState() => _DeliveryDateState();
}

class _DeliveryDateState extends State<DeliveryDatePage> {
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
    setState(() {
      loading = true;
      error = false;
    });

    try {
      deliveryDays = await ConfigAPIService.getDeliveryDays();
      setState(() {
        loading = false;
        error = false;
      });

      _loadPreviousDataSelected();
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  void _loadPreviousDataSelected() async {
    var dayIdSelectedSession =
        await SessionService.getItem(key: 'deliveryDayIdSelected');
    var hourIdSelectedSession =
        await SessionService.getItem(key: 'deliveryHourIdSelected');

    if (dayIdSelectedSession != null) {
      var daySelected = this
          .deliveryDays
          .where((day) => day['id'] == dayIdSelectedSession)
          .toList();

      if (daySelected.length > 0) {
        this.dayIdSelected = dayIdSelectedSession;
      }

      if (this.dayIdSelected != null) {
        var existHourSelected = daySelected[0]['horarios_de_entrega']
            .where((hour) => hour['id'] == hourIdSelectedSession)
            .toList();

        if (existHourSelected.length > 0) {
          this.hourIdSelected = hourIdSelectedSession;
        }
      }
    }

    if (this.dayIdSelected != null) {
      _getDeliveryHoursDaySelected();
    }
    setState(() {});
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

  void _setDeliveryDate({BuildContext context}) async {
    if (dayIdSelected == null || hourIdSelected == null) {
      AlertService.showErrorAlert(
          context: context,
          title: 'Error',
          description: 'Por favor seleccione el día y hora de entrega');

      return;
    }

    Map daySelected = deliveryDays
        .where((deliveryDay) => deliveryDay['id'] == dayIdSelected)
        .toList()[0];
    Map hourSelected = daySelected['horarios_de_entrega']
        .where((deliveryHour) => deliveryHour['id'] == hourIdSelected)
        .toList()[0];

    String deliveryDate = daySelected['nombre_dia'] +
        ' ' +
        daySelected['dia'] +
        ' de ' +
        daySelected['nombre_mes'] +
        ', ' +
        daySelected['anio'] +
        ' de ' +
        hourSelected['hora_inicio'] +
        ' a ' +
        hourSelected['hora_fin'];

    await SessionService.setItem(
      key: 'deliveryDayIdSelected',
      value: dayIdSelected,
    );

    await SessionService.setItem(
      key: 'deliveryHourIdSelected',
      value: hourIdSelected,
    );

    await SessionService.setItem(
      key: 'deliveryDateSelected',
      value: daySelected['fecha_entrega'],
    );

    await SessionService.setItem(
      key: 'deliveryFromHourSelected',
      value: hourSelected['hora_desde'],
    );

    await SessionService.setItem(
      key: 'deliveryToHourSelected',
      value: hourSelected['hora_hasta'],
    );

    await SessionService.setItem(key: 'shipping_day', value: deliveryDate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (loading || error) {
      return PageLoaderWidget(
        error: error,
        onError: () async {
          await _init();
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomSecondaryColor),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBarWidget(context),
        body: _getBodyWidget(context),
        bottomNavigationBar: _bottomNavigationBarWidget(context: context),
      ),
    );
  }

  Widget _getAppBarWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kCustomWhiteColor,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/icons/back_arrow.png',
                    width: 25.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Confirmar fecha de entrega'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _getSliderDaysWidget(context: context),
        _getDeliveryHoursWidget(context: context),
      ],
    );
  }

  Widget _getSliderDaysWidget({BuildContext context}) {
    return Container(
      height: 120.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

                      _getDeliveryHoursDaySelected();
                    },
                  ),
                ),
                Text(deliveryDays[index]['nombre_dia'])
              ],
            );
          },
        ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 325,
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
                      },
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _bottomNavigationBarWidget({BuildContext context}) {
    return Stack(
      children: [
        new Container(
          height: 100.0,
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonTheme(
                  height: 50.0,
                  minWidth: MediaQuery.of(context).size.width,
                  child: RoundButtonWidget(
                    text: 'Guardar',
                    onPressed: () {
                      _setDeliveryDate(context: context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
