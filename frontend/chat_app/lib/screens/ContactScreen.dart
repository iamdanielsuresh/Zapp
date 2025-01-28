import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  // Function to request permission and get contacts
  _getContacts() async {
    // Request permission to access contacts
    PermissionStatus permissionStatus = await Permission.contacts.request();

    // If permission is granted, retrieve contacts
    if (permissionStatus.isGranted) {
      Iterable<Contact> contactsList = await ContactsService.getContacts();
      setState(() {
        contacts = contactsList.toList();
      });
    } else {
      // Handle permission denied case
      print("Permission to access contacts was denied.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Contacts", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text("Add people who are already using the app or invite them to join."),
            SizedBox(height: 20),
            Expanded(
              child: contacts.isEmpty
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching contacts
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(contacts[index].displayName ?? 'No Name', style: Theme.of(context).textTheme.bodyMedium),
                          subtitle: Text(contacts[index].phones?.isNotEmpty == true ? contacts[index].phones!.first.value! : 'No Phone'),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            child: Text("Add"),
                          ),
                        );
                      },
                    ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
