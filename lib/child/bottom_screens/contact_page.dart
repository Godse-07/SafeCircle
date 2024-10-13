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
  TextEditingController searchController = TextEditingController();

  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    askPermission();
    searchController.addListener(() {
      filterContacts();
    });
  }

  Future<void> askPermission() async {
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
      filteredContacts = _contacts;
      isLoading = false; // Stop loading once contacts are fetched
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

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(
      RegExp(r'^(\+)|\D'),
      (Match m) {
        return m[0] == "+" ? "+" : "";
      },
    );
  }

  filterContacts() {
    List<Contact> _filteredContacts = [];
    _filteredContacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _filteredContacts.retainWhere((contact) {
        String search = searchController.text.toLowerCase();
        String flattenedPhone =
            flattenPhoneNumber(contact.phones?.elementAt(0).value ?? "");
        String name = contact.displayName?.toLowerCase() ?? "";
        return name.contains(search) || flattenedPhone.contains(search);
      });
    }
    setState(() {
      filteredContacts = _filteredContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExists =
        isSearching ? filteredContacts.isNotEmpty : contacts.isNotEmpty;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(
                child: Progress(), // Show Progress() while loading
              )
            : Container(
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [Colors.deepPurple, Colors.pinkAccent],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: "Search Contacts",
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.search, color: Colors.pinkAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        controller: searchController,
                      ),
                    ),
                    listItemExists
                        ? Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                Contact contact = isSearching
                                    ? filteredContacts[index]
                                    : contacts[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5,
                                  child: ListTile(
                                    title: Text(
                                      contact.displayName ?? "No Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      contact.phones?.elementAt(0).value ??
                                          "No Phone",
                                      style:
                                          TextStyle(color: Colors.grey[600]),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.pinkAccent,
                                      child: Text(
                                        contact.initials(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.pinkAccent,
                                    ),
                                    onTap: () {
                                      // Handle contact tap
                                    },
                                  ),
                                );
                              },
                              itemCount: isSearching
                                  ? filteredContacts.length
                                  : contacts.length,
                            ),
                          )
                        : Center(
                            child: Text(
                              "No Contacts Found",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 18),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
