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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SELL PROPERTY'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          TileFormField(controller: TextEditingController(text: widget.lead.name), title: "Buyer Name", enabled: false),
          TileFormField(controller: TextEditingController(text: widget.lead.governmentId), title: "Buyer ID", enabled: false),
          TileFormField(
            controller: sellingAmount,
            title: "Selling Amount",
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TileFormField(
                  controller: staffComission.value,
                  title: "Staff Comission",
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  leading: Radio<ComissionType>(
                      value: ComissionType.amount,
                      groupValue: staffComission.comissionType,
                      onChanged: (val) {
                        setState(() {
                          staffComission.comissionType = val ?? staffComission.comissionType;
                        });
                      }),
                  title: const Text("Amount"),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  leading: Radio<ComissionType>(
                      value: ComissionType.percent,
                      groupValue: staffComission.comissionType,
                      onChanged: (val) {
                        setState(() {
                          staffComission.comissionType = val ?? staffComission.comissionType;
                        });
                      }),
                  title: const Text("Percent"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TileFormField(
                  controller: agentComission.value,
                  title: "Agent Comission",
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  leading: Radio<ComissionType>(
                      value: ComissionType.amount,
                      groupValue: agentComission.comissionType,
                      onChanged: (val) {
                        setState(() {
                          agentComission.comissionType = val ?? agentComission.comissionType;
                        });
                      }),
                  title: const Text("Amount"),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  leading: Radio<ComissionType>(
                      value: ComissionType.percent,
                      groupValue: agentComission.comissionType,
                      onChanged: (val) {
                        setState(() {
                          agentComission.comissionType = val ?? agentComission.comissionType;
                        });
                      }),
                  title: const Text("Percent"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TileFormField(
                  controller: superAgentComission.value,
                  title: "Super Agent Comission",
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  leading: Radio<ComissionType>(
                      value: ComissionType.amount,
                      groupValue: superAgentComission.comissionType,
                      onChanged: (val) {
                        setState(() {
                          superAgentComission.comissionType = val ?? superAgentComission.comissionType;
                        });
                      }),
                  title: const Text("Amount"),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  leading: Radio<ComissionType>(
                      value: ComissionType.percent,
                      groupValue: superAgentComission.comissionType,
                      onChanged: (val) {
                        setState(() {
                          superAgentComission.comissionType = val ?? superAgentComission.comissionType;
                        });
                      }),
                  title: const Text("Percent"),
                ),
              ),
            ],
          ),
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
    );
  }
}
