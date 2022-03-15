import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durkhawpui/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeAdminRoleDialog extends StatefulWidget {
  final Member member;
  ChangeAdminRoleDialog({Key? key, required this.member}) : super(key: key);

  @override
  State<ChangeAdminRoleDialog> createState() => _ChangeAdminRoleDialogState();
}

class _ChangeAdminRoleDialogState extends State<ChangeAdminRoleDialog> {
  final List<String> roles = ["user", "admin", "super"];
  String? _selectedRole;
  bool loading = false;

  @override
  void initState() {
    _selectedRole = widget.member.role;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40,
                  child: Center(
                    child: Text("Change Admin Role"),
                  ),
                ),
                Divider(
                  color: Theme.of(context).textTheme.bodyText2!.color!,
                ),
                const SizedBox(height: 10),
                Text(
                  'change_role_desc'.tr,
                  style: Theme.of(context).textTheme.bodyText2!,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text("Member"),
                    const Spacer(),
                    Text(widget.member.name)
                  ],
                ),
                Row(
                  children: [
                    Text(widget.member.email),
                    const Spacer(),
                    Text("Role:"),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                      maxWidth: 25,
                      minWidth: 10,
                    )),
                    DropdownButton<String>(
                      items: roles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      value: _selectedRole,
                      elevation: 0,
                      onChanged: (newRole) {
                        setState(() {
                          _selectedRole = newRole;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: loading
                          ? Center(
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                if (loading) {
                                  return;
                                }
                                setState(() {
                                  loading = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.member.userId)
                                    .update({
                                  'role': _selectedRole,
                                });
                                setState(() {
                                  loading = false;
                                });
                                Get.back(result: true);
                              },
                              child: Text(
                                "Confirm",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
