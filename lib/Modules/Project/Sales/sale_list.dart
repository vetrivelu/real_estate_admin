import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/Model/Project.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Model/Staff.dart';
import 'package:real_estate_admin/Model/Transaction.dart';
import 'package:real_estate_admin/Modules/Project/Sales/sale_form.dart';
import 'package:real_estate_admin/widgets/formfield.dart';

import '../../../Model/Lead.dart';
import '../../../Providers/session.dart';
import '../property_view.dart';

class SaleList extends StatefulWidget {
  const SaleList({Key? key, this.property}) : super(key: key);

  final Property? property;

  @override
  State<SaleList> createState() => _SaleListState();
}

final List<String> agentNames = [
  "ALL",
  "Yathushanth W.",
  "Durangan Z.",
  "Ravithyan F.",
  "Akshayen E.",
  "Harshavarthan O.",
  "Saakeythyan E.",
  "Vibhushan T.",
  "Ranesh N.",
  "Nivas F.",
];

class _SaleListState extends State<SaleList> {
  Agent? agent;
  Staff? staff;
  bool? convertedLeads = false;
  String selectedAgent = agentNames.first;
  String selectedStaff = agentNames.first;
  LeadStatus? leadStatus;

  final from = TextEditingController();
  final to = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  assignDate(final TextEditingController controller) {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100)).then((value) {
      setState(() {
        controller.text = value.toString().substring(0, 10);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("SALES REPORT"),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SizedBox(
                height: 120,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      // TileFormField(
                      //   controller: from,
                      //   title: 'FROM DATE',
                      //   suffix: IconButton(
                      //     onPressed: () {
                      //       assignDate(from);
                      //     },
                      //     icon: Icon(Icons.calendar_month),
                      //   ),
                      // ),
                      // TileFormField(
                      //   controller: to,
                      //   title: 'TO DATE',
                      //   suffix: GestureDetector(
                      //     onTap: () {
                      //       assignDate(to);
                      //     },
                      //     child: Icon(Icons.calendar_month),
                      //   ),
                      // ),
                      ListTile(
                        title: const Text("STAFF"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<Staff?>(
                              value: staff,
                              items: AppSession()
                                  .staffs
                                  .map((staffIterable) => DropdownMenuItem<Staff?>(
                                        value: staffIterable,
                                        child: Text(staffIterable.firstName),
                                      ))
                                  .followedBy([
                                const DropdownMenuItem<Staff?>(
                                  value: null,
                                  child: Text('ALL'),
                                )
                              ]).toList(),
                              isExpanded: true,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onChanged: (val) {
                                setState(() {
                                  staff = val;
                                });
                              }),
                        ),
                      ),
                      ListTile(
                        title: const Text("AGENT"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<Agent?>(
                              value: agent,
                              items: AppSession()
                                  .agents
                                  .map((agentIterable) => DropdownMenuItem<Agent?>(
                                        value: agentIterable,
                                        child: Text(agentIterable.firstName),
                                      ))
                                  .followedBy([
                                const DropdownMenuItem<Agent?>(
                                  value: null,
                                  child: Text('ALL'),
                                )
                              ]).toList(),
                              isExpanded: true,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onChanged: (val) {
                                setState(() {
                                  agent = val;
                                  print(agent?.toJson());
                                });
                              }),
                        ),
                      ),
                      ListTile(
                        title: const Text("STATUS"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<LeadStatus?>(
                              value: leadStatus,
                              items: const [
                                DropdownMenuItem(value: LeadStatus.pendingApproval, child: Text("PENDING APPROVAL")),
                                DropdownMenuItem(value: LeadStatus.sold, child: Text("SOLD")),
                                DropdownMenuItem(value: null, child: Text("ALL")),
                              ],
                              isExpanded: true,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onChanged: (val) {
                                setState(() {
                                  leadStatus = val;
                                });
                              }),
                        ),
                      ),
                      Container(),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            // child: Container(),
            child: StreamBuilder<List<Lead>>(
                stream: Lead.getSales(agent: agent, staff: staff, leadStatus: leadStatus),
                builder: (context, AsyncSnapshot<List<Lead>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                    return Listener(
                      onPointerSignal: (event) {
                        if (event is PointerScrollEvent) {
                          final offset = event.scrollDelta.dy;
                          _scrollController.jumpTo(_scrollController.offset + offset);
                        }
                      },
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              PaginatedDataTable(
                                controller: _scrollController,
                                rowsPerPage: (Get.height ~/ kMinInteractiveDimension) - 7,
                                columns: SaleListSourse.getColumns(),
                                source: SaleListSourse(
                                  snapshot.data!,
                                  context: context,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(snapshot.error.toString()),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class SaleListSourse extends DataTableSource {
  final List<Lead> leads;
  final BuildContext context;
  SaleListSourse(this.leads, {required this.context});

  final _format = NumberFormat.currency(locale: 'en-IN');

  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    final _lead = leads[(index)];

    return DataRow.byIndex(
      color: MaterialStateProperty.all(_lead.leadStatus == LeadStatus.sold ? Colors.lightGreen.shade100 : Colors.white),
      index: index,
      cells: [
        // DataCell(Text((index + 1).toString())),
        DataCell(Text(_lead.name)),
        DataCell(Text(_lead.phoneNumber ?? '')),
        // const DataCell(Text('42,50,500')),
        DataCell(Text(_format.format(_lead.sellingAmount))),

        DataCell(Text(_lead.staff?.firstName ?? '')),
        DataCell(Text(_format.format(_lead.staffComissionAmount))),
        DataCell(Text(_lead.agent?.firstName ?? '')),
        DataCell(Text(_format.format(_lead.agentComissionAmount))),
        DataCell(Text(_lead.agent?.superAgent?.firstName ?? '')),
        DataCell(Text(_format.format(_lead.superAgentComissionAmount))),

        DataCell(Text(DateTime.now().add(Duration(days: index)).toString().substring(0, 10))),

        DataCell(TextButton(
          onPressed: () {
            _lead.propertyRef.get().then((value) {
              var property = Property.fromSnapshot(value);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      content: SizedBox(
                        height: 800,
                        width: 600,
                        child: PropertyView(
                          property: property,
                        ),
                      ),
                    );
                  });
            });
          },
          child: Text('P${_lead.propertyID.toString().padLeft(6, '0')}'),
        )),
        DataCell(IconButton(
          icon: (_lead.leadStatus != LeadStatus.sold && AppSession().isAdmin) ? const Icon(Icons.edit) : const Icon(Icons.visibility),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  printInfo(info: (AppSession().staff?.isAdmin ?? false).toString());
                  printInfo(info: (_lead.leadStatus == LeadStatus.sold && (AppSession().staff?.isAdmin ?? false)).toString());
                  if (_lead.leadStatus == LeadStatus.sold && (AppSession().staff?.isAdmin ?? false) == false) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      title: const Text("Operation Not Allowed"),
                      content: const Text("Edit operation on sold transaction is only available for admin"),
                      actions: [TextButton(onPressed: Navigator.of(context).pop, child: const Text("Okay"))],
                    );
                  }

                  return AlertDialog(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    content: SizedBox(
                      height: 800,
                      width: 600,
                      child: SaleForm(
                        lead: _lead,
                      ),
                    ),
                  );
                });
          },
        )),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => (leads.length);

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  static List<DataColumn> getColumns() {
    List<DataColumn> list = [];
    list.addAll([
      // const DataColumn(label: Text("S.No")),
      const DataColumn(label: Text("Buyer Name")),
      const DataColumn(label: Text("Contact")),
      // const DataColumn(label: Text("Initial Amount")),
      const DataColumn(label: Text("Sold Amount")),
      const DataColumn(label: Text("Staff")),
      const DataColumn(label: Text("Staff Comission")),
      const DataColumn(label: Text("Agent")),
      const DataColumn(label: Text("Agent Comission")),

      const DataColumn(label: Text("Super Agnet")),
      const DataColumn(label: Text("Super agent Comission")),
      const DataColumn(label: Text("Date")),
      const DataColumn(label: Text("Property")),
      const DataColumn(label: Text("Edit")),
    ]);
    return list;
  }
}
