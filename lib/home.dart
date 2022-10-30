import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_admin/Modules/Agent/agent_list.dart';
import 'package:real_estate_admin/Modules/Dashboard/dashboard.dart';
import 'package:real_estate_admin/Modules/Project/Sales/sale_list.dart';
import 'package:real_estate_admin/Modules/Project/leads/lead_list.dart';
import 'package:real_estate_admin/Modules/Project/project_list.dart';
import 'package:real_estate_admin/Modules/Staff/staff_form.dart';
import 'package:real_estate_admin/Modules/Staff/staff_list.dart';
import 'package:real_estate_admin/Providers/session.dart';
import 'package:real_estate_admin/auth_gate.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedTile = 0;
  @override
  Widget build(BuildContext context) {
    var session = AppSession();
    return Row(
      children: [
        Card(
          child: Drawer(
            width: Get.width * 0.125,
            child: Column(
              children: [
                const AspectRatio(aspectRatio: 1),
                ListTile(
                  selected: selectedTile == 0,
                  title: const Text("Dashboard"),
                  selectedColor: Colors.blue,
                  trailing: const Icon(Icons.dashboard),
                  onTap: () {
                    // session.pageController.jumpToPage(0);

                    setState(() {
                      selectedTile = 0;
                    });
                    Get.offAll(() => Container());
                  },
                ),
                ListTile(
                  selected: selectedTile == 1,
                  title: const Text("Projects"),
                  trailing: const Icon(Icons.tab),
                  onTap: () {
                    // session.pageController.jumpToPage(1);
                    setState(() {
                      selectedTile = 1;
                    });
                    Get.offAll(() => const ProjectList());
                  },
                ),
                ListTile(
                  selected: selectedTile == 2,
                  title: const Text("Agents"),
                  trailing: const Icon(Icons.people),
                  onTap: () {
                    // session.pageController.jumpToPage(2);
                    setState(() {
                      selectedTile = 2;
                    });
                    Get.offAll(() => const AgentList());
                  },
                ),
                AppSession().isAdmin
                    ? ListTile(
                        selected: selectedTile == 3,
                        title: const Text("Staffs"),
                        trailing: const Icon(Icons.people_sharp),
                        onTap: () {
                          // session.pageController.jumpToPage(2);
                          setState(() {
                            selectedTile = 3;
                          });
                          Get.offAll(() => const StaffList());
                        },
                      )
                    : Container(),
                ListTile(
                  selected: selectedTile == 4,
                  title: const Text("Leads"),
                  trailing: const Icon(Icons.people_sharp),
                  onTap: () {
                    // session.pageController.jumpToPage(2);
                    setState(() {
                      selectedTile = 4;
                    });
                    Get.offAll(() => const LeadList());
                  },
                ),
                ListTile(
                  selected: selectedTile == 5,
                  title: const Text("Sales"),
                  trailing: const Icon(Icons.people_sharp),
                  onTap: () {
                    // session.pageController.jumpToPage(2);
                    setState(() {
                      selectedTile = 5;
                    });
                    Get.offAll(() => const SaleList());
                  },
                ),
                ListTile(
                  title: const Text("My Profile"),
                  trailing: const Icon(Icons.person),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            content: SizedBox(height: 800, width: 600, child: StaffForm(staff: AppSession().staff)),
                          );
                        });
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
        Expanded(child: widget.child),
      ],
    );
  }
}
