import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_admin/Model/Lead.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Model/Result.dart';
import 'package:real_estate_admin/Model/Transaction.dart';
import 'package:real_estate_admin/Providers/session.dart';
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
  late ComissionController staffComission;
  late ComissionController agentComission;
  late ComissionController superAgentComission;
  final TextEditingController sellingAmount = TextEditingController(text: '0.00');

  double get sellingPrice => double.tryParse(sellingAmount.text) ?? 0;
  @override
  void initState() {
    super.initState();
    widget.lead.loadReferences();
    print("AGENT COMISSION");
    print(widget.lead.agentComission?.toJson());
    agentComission = widget.lead.agentComission != null ? ComissionController.fromComission(widget.lead.agentComission!) : ComissionController();
    staffComission = widget.lead.staffComission != null ? ComissionController.fromComission(widget.lead.staffComission!) : ComissionController();
    superAgentComission =
        widget.lead.superAgentComission != null ? ComissionController.fromComission(widget.lead.superAgentComission!) : ComissionController();
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.grey),
      borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }

  getComission({required ComissionController comission, required String title, required String name}) {
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
                                  name.toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                        child: TileFormField(
                          controller: comission.value,
                          validator: (val) {
                            double actualAmount = comission.comissionType == ComissionType.percent
                                ? (comission.comission.value * sellingPrice / 100)
                                : comission.comission.value;
                            if (actualAmount > sellingPrice) {
                              return "Comission amount should not be higher than the Selling price";
                            }
                          },
                          onChanged: (val) {
                            reload(() {});
                          },
                          title: "COMISSION",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: ListTile(
                            title: const Text("AMOUNT"),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: myBoxDecoration().copyWith(color: Colors.grey.shade300),
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
            TileFormField(controller: TextEditingController(text: widget.lead.phoneNumber), title: "Buyer Contact", enabled: false),
            TileFormField(controller: TextEditingController(text: widget.lead.governmentId), title: "Buyer ID", enabled: false),
            TileFormField(
              controller: sellingAmount,
              title: "Selling Amount",
              onChanged: (val) {
                if (double.tryParse(val) != null) {
                  setState(() {});
                }
              },
            ),
            getComission(comission: staffComission, title: 'STAFF COMISSION', name: widget.lead.staff?.firstName ?? ''),
            getComission(comission: agentComission, title: 'AGENT COMISSION', name: widget.lead.agent?.firstName ?? ''),
            getComission(comission: superAgentComission, title: 'SUPER AGENT COMISSION', name: widget.lead.agent?.superAgent?.firstName ?? ''),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 60,
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () async {
                    var future;
                    var lead = widget.lead;
                    if ((AppSession().staff?.isAdmin) ?? false) {
                      lead.leadStatus = LeadStatus.sold;
                    } else if (widget.lead.leadStatus != LeadStatus.sold) {
                      lead.leadStatus = LeadStatus.pendingApproval;
                    }
                    lead.staffComission = staffComission.comission;
                    lead.agentComission = agentComission.comission;
                    lead.superAgentComission = superAgentComission.comission;
                    lead.sellingAmount = double.tryParse(sellingAmount.text) ?? 0;
                    future = lead.reference
                        .update(lead.toJson())
                        .then((value) => Result(tilte: 'Success', message: "Record saved succesfully"))
                        .onError((error, stackTrace) => Result(tilte: 'Failed', message: "Record is not updated \n ${error.toString()}"));

                    showFutureDialog(
                      context,
                      future: future,
                    );
                  },
                  child: Text(widget.lead.leadStatus == LeadStatus.lead
                      ? "MARK PROPERTY AS SOLD"
                      : (widget.lead.leadStatus == LeadStatus.pendingApproval ? (AppSession().isAdmin ? "SAVE AND APPROVE" : "SAVE") : "SAVE")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
