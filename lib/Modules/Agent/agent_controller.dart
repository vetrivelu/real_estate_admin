import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/Model/Lead.dart';
import 'package:real_estate_admin/Modules/Agent/agent_form_state.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate_admin/Model/Result.dart';
import 'package:real_estate_admin/Model/Agent.dart';

class AgentController {
  AgentController({required this.formController});
  final AgentFormController formController;

  static final agentRef = FirebaseFirestore.instance.collection('agents');
  Agent get agent => formController.agent;

  Future<Result> addAgent() async {
    List<String> validators = [];
    var emailValidator = agentRef.where('email', isEqualTo: agent.email).get().then((value) => value.docs.isEmpty ? null : validators.add("Email"));
    var phoneNumberValidator =
        agentRef.where('phoneNumber', isEqualTo: agent.phoneNumber).get().then((value) => value.docs.isEmpty ? null : validators.add("Phone Number"));
    var panNUmberValidator = agentRef
        .where('panCardNumber', isEqualTo: agent.panCardNumber)
        .get()
        .then((value) => value.docs.isEmpty ? null : validators.add("PAN Card Number"));
    await Future.wait([emailValidator, phoneNumberValidator, panNUmberValidator]);
    if (validators.isNotEmpty) {
      validators.addAll(['', '', '']);
      return Result(
          tilte: Result.failure,
          message: "Following fields are already exists in other account,\n ${validators[0]} ${validators[1]} ${validators[2]} ");
    }
    return agentRef
        .doc(agent.docId)
        .set(agent.toJson())
        .then((value) => Result(tilte: Result.success, message: "Agent added Successfully"))
        .onError((error, stackTrace) => Result(tilte: Result.failure, message: "Agent addition failed"));
  }

  Future<Result> updateAgent() {
    return agentRef
        .doc(agent.docId)
        .update(agent.toJson())
        .then((value) => Result(tilte: Result.success, message: "Agent record updated successfully"))
        .onError((error, stackTrace) => Result(tilte: Result.failure, message: "Agent record update failed"));
  }

  Future<Result> deleteAgent() {
    return agentRef
        .doc(agent.docId)
        .delete()
        .then((value) => Result(tilte: Result.success, message: "Agent record updated successfully"))
        .onError((error, stackTrace) => Result(tilte: Result.failure, message: "Agent record update failed"));
  }

  static Future<List<Agent>> loadAgents(String name) {
    return agentRef.where('search', arrayContains: name.toLowerCase().trim()).get().then((value) {
      return value.docs.map((e) => Agent.fromSnapshot(e)).toList();
    });
  }

}
