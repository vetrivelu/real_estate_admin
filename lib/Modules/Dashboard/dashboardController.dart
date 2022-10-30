import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../Model/Agent.dart';

class DashboardController extends GetxController {
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
