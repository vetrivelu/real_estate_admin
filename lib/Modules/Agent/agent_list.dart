import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/widgets/formfield.dart';

class AgentList extends StatefulWidget {
  const AgentList({Key? key}) : super(key: key);

  @override
  State<AgentList> createState() => _AgentListState();
}

class _AgentListState extends State<AgentList> {
  @override
  void initState() {
    query = agentsRef;
    super.initState();
  }

  final agentsRef = FirebaseFirestore.instance.collection("agents").where("isStaff", isEqualTo: false);

  late Query<Map<String, dynamic>> query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "AGENTS LIST",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: query.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active || snapshot.hasData) {
                  List<Agent> agents = [];
                  agents = snapshot.data!.docs.map((e) => Agent.fromSnapshot(e)).toList();
                  if (agents.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text("No Agents are added yet"),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        child: SizedBox(
                          width: double.maxFinite,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Phone')),
                              DataColumn(label: Text('PAN')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Referral Code')),
                              DataColumn(label: Text('Referred By')),
                              DataColumn(label: Text('Approved by')),
                              DataColumn(label: Text('Edit')),
                              DataColumn(label: Text('Delete')),
                            ],
                            rows: agents
                                .map((e) => DataRow(
                                      cells: [
                                        DataCell(TextButton(onPressed: () {}, child: Text("${e.firstName} ${e.lastName}"))),
                                        DataCell(Text(e.phoneNumber)),
                                        DataCell(Text(e.panCardNumber ?? '')),
                                        DataCell(Text(e.email ?? '')),
                                        DataCell(Text('')),
                                        DataCell(Text(e.superAgent?.firstName ?? '')),
                                        DataCell(Text(e.approvedStaff?.firstName ?? '')),
                                        DataCell(Icon(Icons.edit)),
                                        DataCell(Icon(Icons.delete)),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  }
                }
                if (snapshot.hasError) {
                  return Center(
                    child: SelectableText(snapshot.data.toString()),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
