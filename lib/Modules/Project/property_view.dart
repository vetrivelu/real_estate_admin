import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Lead.dart';
import 'package:real_estate_admin/Model/Project.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Modules/Project/leads/lead_form.dart';
import 'package:real_estate_admin/helper.dart';

class PropertyView extends StatelessWidget {
  const PropertyView({Key? key, required this.property, required this.project}) : super(key: key);

  final Property property;
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      floatingActionButton: ButtonBar(
        children: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        content: SizedBox(
                          height: 800,
                          width: 600,
                          child: LeadForm(property: property),
                        ),
                      );
                    });
              },
              child: const Text("ADD LEAD")),
          ElevatedButton(onPressed: () {}, child: const Text("SELL")),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              property.title,
              style: getText(context).headline2!,
            ),
          ),
          Card(
            child: Table(
              children: [
                TableRow(
                  children: [
                    ListTile(
                      title: const Text("PLOT NUMBER"),
                      subtitle: Text(property.plotNumber ?? "Nil"),
                    ),
                    ListTile(
                      title: const Text("SURVEY/PATTA NUMBER"),
                      subtitle: Text(property.surveyNumber ?? "Nil"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    ListTile(
                      title: const Text("DTLP NUMBER"),
                      subtitle: Text(property.dtcpNumber ?? "Nil"),
                    ),
                    ListTile(
                      title: const Text("DISTRICT"),
                      subtitle: Text(property.district ?? "Nil"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    ListTile(
                      title: const Text("TALUK"),
                      subtitle: Text(property.taluk ?? "Nil"),
                    ),
                    ListTile(
                      title: const Text("FEATURES"),
                      subtitle: Text(property.features),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    ListTile(
                      title: const Text("DESCRIPTION"),
                      subtitle: Text(property.description ?? "Nil"),
                    ),
                    ListTile(
                      title: const Text("VALUE"),
                      subtitle: Text(property.propertyAmount.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "AVAILABLE LEADS",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Card(
              child: StreamBuilder<List<Lead>>(
                  stream: property.getLeads(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                      property.leads = snapshot.data!;
                      return DataTable(
                          columns: const [
                            DataColumn(label: Text('NAME')),
                            DataColumn(label: Text('PHONE')),
                            // DataColumn(label: Text('AADHAR')),
                            // DataColumn(label: Text('ENQUIRY DATE')),
                            DataColumn(label: Text('AGENT')),
                            DataColumn(label: Text('STAFF')),
                          ],
                          rows: (property.leads)
                              .map((e) => DataRow(cells: [
                                    DataCell(Text(e.name)),
                                    DataCell(Text(e.phoneNumber ?? '')),
                                    // DataCell(Text(e.governmentId ?? '')),
                                    // DataCell(Text(e.enquiryDate.toString().substring(0, 10))),
                                    DataCell(Text(e.agent?.firstName ?? '')),
                                    DataCell(Text(e.staff?.firstName ?? '')),
                                  ]))
                              .toList());
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(56.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
