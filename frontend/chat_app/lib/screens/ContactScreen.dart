import 'package:chat_app/services/auth_service.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  List<Contact> appUsers = [];
  List<Contact> inviteUsers = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      Iterable<Contact> contactsList = await ContactsService.getContacts();
      List<Contact> allContacts = contactsList.toList();

      // Extract phone numbers
      List<String> phoneNumbers = [];
      for (var contact in allContacts) {
        if (contact.phones != null && contact.phones!.isNotEmpty) {
          String phoneNumber = contact.phones!.first.value!.replaceAll(" ", "");
          phoneNumbers.add(phoneNumber);
        }
      }

      // Query backend for registered users
      List<String> registeredNumbers = await fetchRegisteredUsers(phoneNumbers);

      // Separate contacts
      List<Contact> appUsersList = [];
      List<Contact> inviteUsersList = [];

      for (var contact in allContacts) {
        if (contact.phones != null && contact.phones!.isNotEmpty) {
          String phoneNumber = contact.phones!.first.value!.replaceAll(" ", "");
          if (registeredNumbers.contains(phoneNumber)) {
            appUsersList.add(contact);
          } else {
            inviteUsersList.add(contact);
          }
        }
      }

      setState(() {
        contacts = allContacts;
        appUsers = appUsersList;
        inviteUsers = inviteUsersList;
      });
    } else {
      print("Permission to access contacts was denied.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Contacts")),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (appUsers.isNotEmpty) _buildSectionTitle("People using the app"),
                ...appUsers.map((contact) => _buildContactTile(contact, isAppUser: true)).toList(),

                if (inviteUsers.isNotEmpty) _buildSectionTitle("Invite to join"),
                ...inviteUsers.map((contact) => _buildContactTile(contact, isAppUser: false)).toList(),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildContactTile(Contact contact, {required bool isAppUser}) {
    String phone = contact.phones?.isNotEmpty == true ? contact.phones!.first.value! : "No Phone";

    return ListTile(
      title: Text(contact.displayName ?? "No Name"),
      subtitle: Text(phone),
      trailing: ElevatedButton(
        onPressed: () {
          if (isAppUser) {
            Navigator.pushNamed(context, '/messages', arguments: {'user_id': phone});
          } else {
            _sendInvite(phone);
          }
        },
        child: Text(isAppUser ? "Chat" : "Invite"),
      ),
    );
  }

  void _sendInvite(String phoneNumber) {
    print("Invite sent to $phoneNumber");
    // Implement WhatsApp/SMS invite functionality
  }
}
