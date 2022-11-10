import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_admin/Model/Staff.dart';
import 'package:real_estate_admin/Modules/Staff/staff_form.dart';

class StaffList extends StatefulWidget {
  const StaffList({Key? key}) : super(key: key);

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  void initState() {
    query = agentsRef;
    super.initState();
  }

  final agentsRef = FirebaseFirestore.instance.collection("staffs");

  late Query<Map<String, dynamic>> query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: const Text(
      //     "STAFFS LIST",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   centerTitle: true,
      // ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(56.0),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    content: SizedBox(height: 800, width: 600, child: StaffForm()),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: query.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active || snapshot.hasData) {
                  List<Staff> staffs = [];
                  staffs = snapshot.data!.docs.map((e) => Staff.fromSnapshot(e)).toList();
                  if (staffs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text("No staffs are added yet"),
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
                              DataColumn(label: Text('Comission Earned')),
                              DataColumn(label: Text('Lead count')),
                              DataColumn(label: Text('Converted LeadCount')),
                              DataColumn(label: Text('Edit')),
                              DataColumn(label: Text('Delete')),
                            ],
                            rows: staffs
                                .map((e) => DataRow(
                                      cells: [
                                        DataCell(TextButton(onPressed: () {}, child: Text("${e.firstName} ${e.lastName}"))),
                                        DataCell(Text(e.phoneNumber)),
                                        DataCell(Text(e.panCardNumber ?? '')),
                                        DataCell(Text(e.email)),
                                        DataCell(Text(NumberFormat.currency(locale: 'en-IN').format(e.commissionAmount))),
                                        DataCell(Text(e.leadCount.toString())),
                                        DataCell(Text(e.successfullLeadCount.toString())),
                                        DataCell(IconButton(
                                            onPressed: () {
                                              Get.to(() => StaffForm(
                                                    staff: e,
                                                  ));
                                            },
                                            icon: const Icon(Icons.edit))),
                                        DataCell(IconButton(
                                            onPressed: () {
                                              e.delete();
                                            },
                                            icon: const Icon(Icons.delete))),
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
