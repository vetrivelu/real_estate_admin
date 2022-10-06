import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_admin/Modules/Agent/agent_list.dart';
import 'package:real_estate_admin/Modules/Project/project_list.dart';
import 'package:real_estate_admin/Modules/Staff/staff_list.dart';
import 'package:real_estate_admin/Providers/session.dart';
import 'package:real_estate_admin/auth_gate.dart';

class Home extends StatelessWidget {
  const Home({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var session = AppSession();
    return Row(
      children: [
        Card(
          child: Drawer(
            child: Column(
              children: [
                const AspectRatio(aspectRatio: 1),
                ListTile(
                  title: const Text("Dashboard"),
                  selectedColor: Colors.blue,
                  trailing: const Icon(Icons.dashboard),
                  onTap: () {
                    // session.pageController.jumpToPage(0);
                    Get.offAll(() => Container());
                  },
                ),
                ListTile(
                  title: const Text("Projects"),
                  trailing: const Icon(Icons.tab),
                  onTap: () {
                    // session.pageController.jumpToPage(1);
                    Get.offAll(() => const ProjectList());
                  },
                ),
                ListTile(
                  title: const Text("Agents"),
                  trailing: const Icon(Icons.people),
                  onTap: () {
                    // session.pageController.jumpToPage(2);
                    Get.offAll(() => const AgentList());
                  },
                ),
                ListTile(
                  title: const Text("Staffs"),
                  trailing: const Icon(Icons.people_sharp),
                  onTap: () {
                    // session.pageController.jumpToPage(2);
                    Get.offAll(() => const StaffList());
                  },
                ),
                ListTile(
                  title: const Text("Logout"),
                  trailing: const Icon(Icons.logout),
                  onTap: () {
                    session.firbaseAuth.signOut();
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
