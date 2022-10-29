import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/Modules/Agent/agent_form.dart';
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

  final agentsRef = FirebaseFirestore.instance.collection("agents");

  late Query<Map<String, dynamic>> query;

  final searchController = TextEditingController();
  ActiveStatus activeStatus = ActiveStatus.active;

  reload() {
    query = agentsRef;
    query = query.where('activeStatus', isEqualTo: activeStatus.index);
    if (searchController.text.isNotEmpty) {
      query = query.where('search', arrayContains: searchController.text.toLowerCase().trim());
    }
    setState(() {});
  }

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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(56.0),
        child: FloatingActionButton(
          onPressed: () {
            // Get.to(() => const AgentForm());
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    content: SizedBox(height: 800, width: 600, child: AgentForm()),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                width: 800,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: TileFormField(controller: searchController, title: "SEARCH")),
                    Expanded(
                      child: ListTile(
                        title: const Text("STATUS"),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: DropdownButtonFormField<ActiveStatus>(
                            value: activeStatus,
                            items: const [
                              DropdownMenuItem(value: ActiveStatus.active, child: Text("ACTIVE")),
                              DropdownMenuItem(value: ActiveStatus.blocked, child: Text("BLOCKED")),
                              DropdownMenuItem(value: ActiveStatus.pendingApproval, child: Text("YET TO APPROVE")),
                            ],
                            onChanged: (val) {
                              activeStatus = val ?? activeStatus;
                              reload();
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            onPressed: reload,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("SEARCH"),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: query.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active || snapshot.hasData) {
                    List<Agent> agents = [];
                    agents = snapshot.data!.docs.map((e) => Agent.fromSnapshot(e)).toList();
                    if (agents.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text("No agents are available"),
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
                                DataColumn(label: Text('Status')),
                              ],
                              rows: agents
                                  .map((e) => DataRow(
                                        cells: [
                                          DataCell(TextButton(onPressed: () {}, child: Text("${e.firstName} ${e.lastName}"))),
                                          DataCell(Text(e.phoneNumber)),
                                          DataCell(Text(e.panCardNumber ?? '')),
                                          DataCell(Text(e.email ?? '')),
                                          DataCell(SelectableText(e.referenceCode)),
                                          DataCell(Text(e.superAgent?.firstName ?? '')),
                                          DataCell(Text(e.approvedStaff?.firstName ?? '')),
                                          DataCell(IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                        content: SizedBox(
                                                            height: 800,
                                                            width: 600,
                                                            child: AgentForm(
                                                              agent: e,
                                                            )),
                                                      );
                                                    });
                                              },
                                              icon: const Icon(Icons.edit))),
                                          DataCell(!(e.activeStatus == ActiveStatus.pendingApproval)
                                              ? TextButton(onPressed: e.enable, child: const Text("ENABLE"))
                                              : TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            shape:
                                                                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                            title: const Text("Are you sure ?"),
                                                            content: const Text("This will disable the agent, and stop him from adding leads"),
                                                            actions: [
                                                              TextButton(onPressed: Navigator.of(context).pop, child: const Text("NO")),
                                                              TextButton(
                                                                  onPressed: () {
                                                                    e.disable();
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: const Text("YES")),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: const Text("DISABLE"))),
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
            ),
          ),
        ],
      ),
    );
  }
}
