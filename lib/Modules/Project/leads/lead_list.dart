import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Model/Staff.dart';
import 'package:real_estate_admin/Modules/Project/Sales/sale_form.dart';
import 'package:real_estate_admin/Modules/Project/property_view.dart';
import 'package:real_estate_admin/Providers/session.dart';

import '../../../Model/Lead.dart';

class LeadList extends StatefulWidget {
  const LeadList({Key? key, this.property}) : super(key: key);

  final Property? property;

  @override
  State<LeadList> createState() => _LeadListState();
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

class _LeadListState extends State<LeadList> {
  Agent? agent;
  Staff? staff;
  bool? convertedLeads = false;
  String selectedAgent = agentNames.first;
  String selectedStaff = agentNames.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LEADS"),
        centerTitle: true,
      ),
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
                      ListTile(
                        title: const Text("Lead Status"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<bool?>(
                              items: const [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text("ALL"),
                                ),
                                DropdownMenuItem(
                                  value: true,
                                  child: Text("Converted Leads"),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text("Pending"),
                                ),
                              ],
                              value: convertedLeads,
                              isExpanded: true,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onChanged: (val) {
                                setState(() {
                                  convertedLeads = val;
                                });
                              }),
                        ),
                      ),
                      ListTile(
                        title: const Text("Assigned To"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String?>(
                              value: selectedAgent,
                              items: agentNames
                                  .map((e) => DropdownMenuItem<String?>(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                              isExpanded: true,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onChanged: (val) {
                                setState(() {});
                              }),
                        ),
                      ),
                      ListTile(
                        title: const Text("Source"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String?>(
                              value: selectedStaff,
                              items: agentNames
                                  .map((e) => DropdownMenuItem<String?>(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                              isExpanded: true,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onChanged: (val) {
                                setState(() {});
                              }),
                        ),
                      ),
                      Container(),
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
                stream: Lead.getLeads(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Table(
                      children: [
                        TableRow(
                          children: [
                            PaginatedDataTable(
                              rowsPerPage: (Get.height ~/ kMinInteractiveDimension) - 7,
                              columns: LeadListSourse.getColumns(),
                              source: LeadListSourse(
                                snapshot.data ?? [],
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    printError(info: snapshot.error.toString());
                    return Center(
                      child: Text(snapshot.error.toString()),
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

class LeadListSourse extends DataTableSource {
  final List<Lead> leads;
  final BuildContext context;
  LeadListSourse(this.leads, {required this.context});

  @override
  DataRow? getRow(int index) {
    final _lead = leads[index];

    return DataRow.byIndex(
      color: MaterialStateProperty.all(_lead.leadStatus == LeadStatus.sold ? Colors.lightGreen.shade100 : Colors.white),
      index: index,
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(_lead.name)),
        DataCell(Text('${_lead.name}@gmail.com')),
        DataCell(Text(_lead.phoneNumber ?? '')),
        DataCell(
          DropdownButtonFormField<Staff?>(
              value: _lead.staff,
              items: AppSession()
                  .staffs
                  .map((staff) => DropdownMenuItem<Staff?>(
                        value: staff,
                        child: Text(staff.firstName),
                      ))
                  .toList(),
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (val) {
                if (val != null) {
                  _lead.assignStaff(val);
                }
              }),
        ),
        DataCell(Text(_lead.agent?.firstName ?? '')),
        DataCell(Text(_lead.enquiryDate.toString().substring(0, 10))),
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
          child: const Text("Property"),
        )),
        DataCell(_lead.leadStatus != LeadStatus.lead
            ? Container()
            : ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          content: SizedBox(
                              height: 800,
                              width: 600,
                              child: SaleForm(
                                lead: _lead,
                              )),
                        );
                      });
                },
                child: const Text("Convert to sale"),
              )),
        DataCell(_lead.leadStatus == LeadStatus.sold
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              )
            : IconButton(
                onPressed: () {
                  _lead.reference!.delete();
                },
                icon: const Icon(Icons.delete)))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => (leads.length);

  @override
  int get selectedRowCount => 0;

  static List<DataColumn> getColumns() {
    List<DataColumn> list = [];
    list.addAll([
      const DataColumn(label: Text("S.No")),
      const DataColumn(label: Text("Name")),
      const DataColumn(label: Text("Email")),
      const DataColumn(label: Text("Phone")),
      const DataColumn(label: Text("Assigned")),
      const DataColumn(label: Text("Source")),
      const DataColumn(label: Text("Enquiry Date")),
      const DataColumn(label: Text("Property")),
      const DataColumn(label: Text("")),
      const DataColumn(label: Text("Delete")),
    ]);
    return list;
  }
}
