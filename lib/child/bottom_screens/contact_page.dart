import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woman_safety/constant.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];

  void initState() {
    super.initState();
    askpermission();
  }

  Future<void> askpermission() async {
    PermissionStatus status = await getContactsPermission();
    if (status == PermissionStatus.granted) {
      getAllContacts();
    } else {
      handleInvalidPermissions(status);
    }
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  void handleInvalidPermissions(PermissionStatus status) {
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<PermissionStatus> getContactsPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted || status.isPermanentlyDenied) {
      status = await Permission.contacts.request();

      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: contacts.length == 0
            ? Center(
                child: Progress(),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(contacts[index].displayName ?? ""),
                    subtitle:
                        Text(contacts[index].phones?.elementAt(0).value ?? ""),
                    leading: CircleAvatar(
                      child: Text(contacts[index].initials()),
                    ),
                  );
                },
                itemCount: contacts.length,
              ),
      ),
    );
  }
}
