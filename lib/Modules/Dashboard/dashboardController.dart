import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:real_estate_admin/Model/Lead.dart';
import 'package:real_estate_admin/Model/Property.dart';
import '../../Model/Agent.dart';

final settings = FirebaseFirestore.instance.collection('config').doc('settings');
final counters = FirebaseFirestore.instance.collection('config').doc('counters');

class DashboardController extends GetxController {
  @override
  void onInit() async {
    loadLeads();
    loadtop5Agents();
    super.onInit();
  }

  List<Agent> top5AgentsByLeads = [];
  List<Agent> top5AgentsBySuccessfull = [];
  List<Agent> top5AgentsByComission = [];
  int totalLeads = 0;
  int totalSuccessleads = 0;
  double totalSoldAmount = 0;
  int totalProperties = 0;
  int totalProjects = 0;
  int totalAgents = 0;
  int totalActiveAgents = 0;
  int totalStaffs = 0;
  Map<DateTime, List<Lead>> dateWiseLeads = {};
  Map<DateTime, List<Lead>> dateWiseSoldLeads = {};

  loadLeads() {
    var date = DateTime.now().subtract(const Duration(days: 30));
    return FirebaseFirestore.instance
        .collectionGroup('leads')
        .orderBy('enquiryDate', descending: true)
        .where('enquiryDate', isGreaterThanOrEqualTo: date)
        .get()
        .then((value) {
      var leads = value.docs.map((e) => Lead.fromSnapshot(e)).toList();
      totalLeads = leads.length;
      totalSuccessleads = leads.where((element) => element.leadStatus == LeadStatus.sold).length;

      printInfo(info: leads.length.toString());
      for (var lead in leads) {
        if (dateWiseLeads[lead.enquiryDate.trimTime()] == null) {
          dateWiseLeads[lead.enquiryDate.trimTime()] = [];
        }
        dateWiseLeads[lead.enquiryDate.trimTime()]?.add(lead);
      }
    });
  }

  loadtop5Agents() {
    FirebaseFirestore.instance.collection('agents').orderBy('leadCount', descending: true).limit(5).get().then((value) {
      top5AgentsByLeads = value.docs.map((e) => Agent.fromSnapshot(e)).toList();
      update();
    });
    FirebaseFirestore.instance.collection('agents').orderBy('successfullLeadCount', descending: true).limit(5).get().then((value) {
      top5AgentsBySuccessfull = value.docs.map((e) => Agent.fromSnapshot(e)).toList();
      update();
    });
    FirebaseFirestore.instance.collection('agents').orderBy('commissionAmount', descending: true).limit(5).get().then((value) {
      top5AgentsByComission = value.docs.map((e) => Agent.fromSnapshot(e)).toList();
      update();
    });
  }
}

extension DateTrim on DateTime {
  DateTime trimTime() {
    return DateTime(year, month, day);
  }
}
