import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_admin/Model/Lead.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Model/Transaction.dart';
import 'package:real_estate_admin/widgets/formfield.dart';
import 'package:real_estate_admin/widgets/future_dialog.dart';

class SaleForm extends StatefulWidget {
  const SaleForm({
    Key? key,
    required this.lead,
  }) : super(key: key);

  final Lead lead;

  @override
  State<SaleForm> createState() => _SaleFormState();
}

class _SaleFormState extends State<SaleForm> {
  ComissionController staffComission = ComissionController();
  ComissionController agentComission = ComissionController();
  ComissionController superAgentComission = ComissionController();
  final TextEditingController sellingAmount = TextEditingController(text: '0.00');

  double get sellingPrice => double.tryParse(sellingAmount.text) ?? 0;

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.grey),
      borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }

  getComission({required ComissionController comission, required String title}) {
    return ListTile(
      title: Text(title),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          decoration: myBoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StatefulBuilder(builder: (context, reload) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                        title: const Text("NAME"),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: myBoxDecoration(),
                            // margin: const EdgeInsets.all(8),
                            height: 56,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  (widget.lead.staff?.firstName).toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: ListTile(
                        title: const Text("AMOUNT"),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: myBoxDecoration(),
                            // margin: const EdgeInsets.all(8),
                            height: 56,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  comission.comissionType == ComissionType.percent
                                      ? (comission.comission.value * sellingPrice / 100).toStringAsFixed(2)
                                      : comission.comission.value.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TileFormField(
                          controller: comission.value,
                          onChanged: (val) {
                            reload(() {
                              double value = double.tryParse(val) ?? 0;
                              double sellingPrice = double.tryParse(sellingAmount.text) ?? 0;
                              if (sellingPrice == 0 || value == 0) {
                                comission.amount.text = '0.00';
                              } else {
                                comission.amount.text =
                                    comission.comissionType == ComissionType.amount ? value.toString() : ((value / 100) * sellingPrice).toString();
                              }
                            });
                          },
                          title: "Comission",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ListTile(
                          leading: Radio<ComissionType>(
                              value: ComissionType.amount,
                              groupValue: comission.comissionType,
                              onChanged: (val) {
                                reload(() {
                                  comission.comissionType = val ?? comission.comissionType;
                                });
                              }),
                          title: const Text("Amount"),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ListTile(
                          leading: Radio<ComissionType>(
                              value: ComissionType.percent,
                              groupValue: comission.comissionType,
                              onChanged: (val) {
                                reload(() {
                                  comission.comissionType = val ?? comission.comissionType;
                                });
                              }),
                          title: const Text("Percent"),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SELL PROPERTY'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            TileFormField(controller: TextEditingController(text: widget.lead.name), title: "Buyer Name", enabled: false),
            TileFormField(controller: TextEditingController(text: widget.lead.governmentId), title: "Buyer ID", enabled: false),
            TileFormField(
              controller: sellingAmount,
              title: "Selling Amount",
            ),
            getComission(comission: staffComission, title: 'STAFF COMISSION'),
            getComission(comission: agentComission, title: 'AGENT COMISSION'),
            getComission(comission: superAgentComission, title: 'SUPER AGENT COMISSION'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 60,
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () async {
                    showFutureDialog(
                      context,
                      future: widget.lead.convertToSale(
                        sellingAmount: double.tryParse(sellingAmount.text) ?? 0,
                        staffComission: staffComission.comission,
                        agentComission: agentComission.comission,
                        superAgentComission: superAgentComission.comission,
                      ),
                    );
                  },
                  child: const Text("MARK PROPERTY AS SOLD"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
