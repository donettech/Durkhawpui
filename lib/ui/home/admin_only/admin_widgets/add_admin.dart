import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../model/user.dart';

class AddAdmin extends StatefulWidget {
  final Function(Member) onConfirm;
  const AddAdmin({Key? key, required this.onConfirm}) : super(key: key);

  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  var _ref = FirebaseFirestore.instance.collection('users');
  bool searching = false;
  String? message;
  final _ctrl = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  List<Member> results = [];
  Member? _selected;

  Future<void> _searchUser() async {
    String _query = _ctrl.text.toLowerCase();
    _query.replaceAll(' ', "");
    _query.replaceAll('.', "");
    _query.replaceAll(',', "");
    var res = await _ref
        .where('email', isEqualTo: _query)
        .withConverter<Member>(
          fromFirestore: (snapshots, _) =>
              Member.fromJson(snapshots.data()!, snapshots.id),
          toFirestore: (member, _) => member.toJson(),
        )
        .get();
    if (res.docs.isEmpty) {
      setState(() {
        message = "User with email $_query Not Found";
      });
      return;
    } else {
      setState(() {
        results.clear();
        message = null;
      });
      res.docs.forEach((QueryDocumentSnapshot event) {
        var _member = event.data() as Member;
        results.add(_member);
      });
      setState(() {
        message = "Select the user from the list";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).cardColor,
          ),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "add_admin_desc".tr,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _ctrl,
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (!GetUtils.isEmail(value!)) {
                      return "email invalid";
                    } else
                      return null;
                  },
                ),
                const SizedBox(height: 10),
                if (message != null)
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.yellow,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                const SizedBox(height: 10),
                if (results.isNotEmpty) _buildResultList(),
                const SizedBox(height: 10),
                if (results.isEmpty)
                  ElevatedButton(
                    onPressed: () async {
                      if (_form.currentState!.validate()) {
                        setState(() {
                          searching = true;
                        });
                        await _searchUser();
                        setState(() {
                          searching = false;
                        });
                      }
                    },
                    child: searching
                        ? Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: 20,
                            height: 20,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .color!),
                              ),
                            ),
                          )
                        : Text('Search'),
                  ),
                if (results.isNotEmpty)
                  ElevatedButton(
                    onPressed: (_selected != null) ? confirmAdd : null,
                    child: Text('Confirm'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void confirmAdd() {
    Get.back();
    widget.onConfirm(_selected!);
  }

  Widget _buildResultList() {
    return SizedBox(
      height: 350,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return Card(
            color: (_selected != null &&
                    (results[index].userId == _selected!.userId))
                ? Colors.lightBlueAccent
                : Colors.transparent,
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image:
                          CachedNetworkImageProvider(results[index].avatarUrl),
                      fit: BoxFit.cover),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  results[index].name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  _selected = results[index];
                });
              },
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    results[index].email,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Role: ",
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        results[index].role,
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
