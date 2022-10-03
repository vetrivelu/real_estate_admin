import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/Model/Property.dart';

enum TransactionStatus { pending, approved, rejected }

class Transaction {
  Transaction({
    required this.agentRef,
    required this.property,
    required this.createdDate,
    required this.supportingDocuments,
    required this.comments,
    required this.customerName,
    required this.customerContact,
    required this.customerGovernmentId,
    this.status = TransactionStatus.pending,
    this.sellingAmount = 0,
    this.agentComission,
    this.superAgentCmission,
    this.agent,
  });

  DocumentReference agentRef;
  DocumentReference property;
  DateTime createdDate;
  List<String> supportingDocuments;
  String? comments;
  String customerName;
  String customerGovernmentId;
  String customerContact;
  TransactionStatus status;
  Agent? agent;
  double sellingAmount;
  Commission? agentComission;
  Commission? superAgentCmission;
}
