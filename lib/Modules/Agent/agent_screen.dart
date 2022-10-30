import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Agent.dart';
import 'package:real_estate_admin/Modules/Agent/agent_leads.dart';
import 'package:real_estate_admin/Modules/Agent/agent_referrals.dart';

class AgentScreen extends StatelessWidget {
  const AgentScreen({Key? key, required this.agent}) : super(key: key);

  final Agent agent;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${agent.firstName} ${agent.lastName}'),
            bottom: const TabBar(tabs: [
              Tab(child: Text("LEADS")),
              Tab(child: Text("REFERRALS")),
            ]),
          ),
          body: TabBarView(children: [
            AgentLeads(agent: agent),
            AgentReferrals(agent: agent),
          ]),
        ));
  }
}
