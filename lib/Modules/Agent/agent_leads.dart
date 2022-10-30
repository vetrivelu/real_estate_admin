import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Agent.dart';

import '../../Model/Lead.dart';

class AgentLeads extends StatefulWidget {
  const AgentLeads({Key? key, required this.agent}) : super(key: key);
  @override
  State<AgentLeads> createState() => _LeadListState();
  final Agent agent;
}

class _LeadListState extends State<AgentLeads> {
  late Query<Map<String, dynamic>> query;

  int totalLeads = 0;
  int convertedLeads = 0;

  Future<List<Lead>> getLeads() async {
    return FirebaseFirestore.instance.collectionGroup('leads').where('agentRef', isEqualTo: widget.agent.reference).get().then((event) {
      return event.docs.map((e) {
        var lead = Lead.fromSnapshot(e);
        return lead;
      }).toList();
    });
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Lead>>(
          future: getLeads(),
          builder: (BuildContext context, AsyncSnapshot<List<Lead>> snapshot) {
            if ((snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) && snapshot.hasData) {
              var list = snapshot.data!;
              var successlist = list.where((element) => element.leadStatus == LeadStatus.sold);
              count = successlist.length;
              return Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: CircularProgressIndicator(
                                      value: count / list.length,
                                      backgroundColor: Colors.grey,
                                      strokeWidth: 16,
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: Center(
                                          child: Text(
                                    "$count/${snapshot.data!.length}\n LEADS",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  )))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: ListTile(
                                        title: const Text("LEADS"),
                                        subtitle: Text(snapshot.data!.length.toString()),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: ListTile(
                                        title: const Text("CONVERTED"),
                                        subtitle: Text(count.toString()),
                                      ),
                                    ),
                                  ],
                                ),
                                ListTile(
                                  title: const Text("COMISSION EARNED"),
                                  subtitle: Text(successlist
                                      .fold<double>(0, (double previousValue, element) => previousValue + element.agentComissionAmount)
                                      .toString()),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var lead = snapshot.data![index];
                          return Card(
                            child: ExpansionTile(
                              trailing: lead.leadStatus != LeadStatus.lead
                                  ? null
                                  : IconButton(onPressed: lead.reference.delete, icon: const Icon(Icons.delete)),
                              title: Text(lead.name),
                              subtitle: Text(lead.phoneNumber ?? lead.email ?? ''),
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: const Text("Staff"),
                                        subtitle: Text(lead.staff?.firstName ?? "Staff Record Not found"),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: const Text("Staff Contact"),
                                        subtitle: Text(lead.staff?.phoneNumber ?? "Staff Record Not found"),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: const Text("Government ID"),
                                        subtitle: Text(lead.governmentId ?? ''),
                                      ),
                                    ),
                                    Expanded(
                                      child: lead.leadStatus == LeadStatus.sold
                                          ? ListTile(
                                              title: const Text("COMISSION EANRED"),
                                              subtitle: Text(lead.agentComissionAmount.toString()),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              if (kDebugMode) {
                print(snapshot.error.toString());
              }
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
