import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'provider/profile_safety_net_provider.dart';
import '../../widgets/app_bar.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/user_provider.dart';

class ProfileSafetyNetScreen extends StatefulWidget {
  const ProfileSafetyNetScreen({Key? key}) : super(key: key);

  @override
  ProfileSafetyNetScreenState createState() => ProfileSafetyNetScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileSafetyNetProvider(),
      child: ProfileSafetyNetScreen(),
    );
  }
}

class ProfileSafetyNetScreenState extends State<ProfileSafetyNetScreen> {
  List<Contact> selectedContacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestContactPermission();
    _loadSafetyNetContacts();
  }

  Future<void> _requestContactPermission() async {
    final status = await Permission.contacts.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact permission is required to add trusted contacts')),
      );
    }
  }

  Future<void> _loadSafetyNetContacts() async {
    try {
      print('Starting to load safety net contacts');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userEmail = userProvider.email;
      
      print('User email: $userEmail');
      
      if (userEmail == null) {
        print('No user email found');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Get the user document
      print('Fetching from Firestore...');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('safetynet')
          .get();

      print('Found ${userDoc.docs.length} safety net contacts');
      print('Documents: ${userDoc.docs.map((doc) => doc.data()).toList()}');

      // Clear existing contacts
      setState(() {
        selectedContacts.clear();
      });

      // Get all phone contacts first
      final phoneContacts = await ContactsService.getContacts();
      print('Found ${phoneContacts.length} phone contacts');

      // For each safety net contact, find matching phone contact
      for (var doc in userDoc.docs) {
        final data = doc.data();
        print('Document data: $data');
        
        final phoneNumber = data['phone'] as String?;
        print('Processing contact with phone: $phoneNumber');
        
        if (phoneNumber != null) {
          // Normalize the safety net phone number
          String normalizedSafetyNetPhone = phoneNumber
              .replaceAll(RegExp(r'[\s\-\(\)]'), '') // Remove spaces, dashes, parentheses
              .replaceAll('+30', '') // Remove Greek country code
              .replaceAll('0030', ''); // Remove alternative Greek country code
          
          if (!normalizedSafetyNetPhone.startsWith('69')) {
            normalizedSafetyNetPhone = '69$normalizedSafetyNetPhone';
          }
          
          print('Normalized safety net phone: $normalizedSafetyNetPhone');
          
          // Find exact matching contact
          Contact? matchingContact;
          for (var contact in phoneContacts) {
            for (var phone in contact.phones ?? []) {
              if (phone.value == null) continue;
              
              // Normalize the contact's phone number
              String normalizedPhone = phone.value!
                  .replaceAll(RegExp(r'[\s\-\(\)]'), '') // Remove spaces, dashes, parentheses
                  .replaceAll('+30', '') // Remove Greek country code
                  .replaceAll('0030', ''); // Remove alternative Greek country code
              
              if (!normalizedPhone.startsWith('69')) {
                normalizedPhone = '69$normalizedPhone';
              }
              
              print('Comparing normalized numbers: $normalizedPhone with $normalizedSafetyNetPhone');
              
              if (normalizedPhone == normalizedSafetyNetPhone) {
                matchingContact = contact;
                print('Found matching contact: ${contact.displayName}');
                break;
              }
            }
            if (matchingContact != null) break;
          }

          if (matchingContact == null) {
            print('No matching contact found for $phoneNumber');
            matchingContact = Contact(
              displayName: 'Unknown Contact',
              phones: [Item(label: 'phone', value: phoneNumber)],
            );
          } else {
            // Ensure we have the contact's first name
            final nameParts = matchingContact.displayName?.split(' ') ?? ['Unknown'];
            final firstName = nameParts.first;
            matchingContact = Contact(
              displayName: firstName,
              avatar: matchingContact.avatar,
              phones: matchingContact.phones,
            );
          }

          print('Adding contact: ${matchingContact.displayName}');
          setState(() {
            selectedContacts.add(matchingContact!);
          });
        }
      }

      print('Final selected contacts: ${selectedContacts.map((c) => c.displayName).toList()}');
    } catch (e, stackTrace) {
      print('Error loading safety net contacts: $e');
      print('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading contacts: $e')),
      );
    } finally {
      print('Finished loading contacts');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickContact() async {
    try {
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      if (contacts.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Color(0xFFBCBCBC).withOpacity(0.04),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      Container(
                        width: 40.h,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "Select a Contact",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...contacts.map((contact) => _buildContactOption(contact)),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking contact')),
      );
    }
  }

  Widget _buildContactOption(Contact contact) {
    return GestureDetector(
      onTap: () {
        if (!selectedContacts.any((c) => c.displayName == contact.displayName)) {
          setState(() {
            selectedContacts.add(contact);
          });
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This contact is already added')),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.h),
        child: Row(
          children: [
            if (contact.avatar != null)
              CircleAvatar(
                radius: 20.h,
                backgroundImage: MemoryImage(contact.avatar!),
              )
            else
              CircleAvatar(
                radius: 20.h,
                child: Text(
                  contact.displayName?.substring(0, 1).toUpperCase() ?? '?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            SizedBox(width: 16.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.displayName ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (contact.phones?.isNotEmpty == true)
                    Text(
                      contact.phones!.first.value ?? '',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF).withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactWrapper(Contact contact, int index) {
    return Positioned(
      top: 20.h + (index * 70.h),
      child: Dismissible(
        key: Key(contact.displayName ?? 'contact_$index'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.h),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 24.h,
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            selectedContacts.removeAt(index);
          });
        },
        child: GestureDetector(
          onTap: () async {
            try {
              final Iterable<Contact> contacts = await ContactsService.getContacts();
              if (contacts.isNotEmpty) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Color(0xFFBCBCBC).withOpacity(0.04),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFBCBCBC).withOpacity(0.04),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 12.h),
                              Container(
                                width: 40.h,
                                height: 4.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(2.h),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                "Replace Contact",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...contacts.map((newContact) => GestureDetector(
                                        onTap: () {
                                          if (!selectedContacts.any((c) => c.displayName == newContact.displayName)) {
                                            setState(() {
                                              selectedContacts[index] = newContact;
                                            });
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('This contact is already added')),
                                            );
                                          }
                                        },
                                        child: _buildContactOption(newContact),
                                      )),
                                      SizedBox(height: 24.h),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            } catch (e) {
              print('Error picking contact: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error picking contact')),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/contact_wrapper.svg',
                    width: 314.h,
                    height: 64.h,
                  ),
                  Positioned(
                    left: 20.h,
                    child: CircleAvatar(
                      radius: 20.h,
                      backgroundImage: contact.avatar != null
                          ? MemoryImage(contact.avatar!)
                          : null,
                      child: contact.avatar == null
                          ? Text(
                              contact.displayName?.substring(0, 1).toUpperCase() ?? '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    left: 70.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.displayName ?? 'Unknown',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          contact.phones?.isNotEmpty == true
                              ? contact.phones!.first.value ?? ''
                              : 'No phone number',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF).withOpacity(0.6),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Background blur overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Color(0xFFBCBCBC).withOpacity(0.04),
                ),
              ),
            ),
            // Top blur box
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200.h,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (isLoading)
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        else
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.h, left: 24.h, right: 24.h, bottom: 100.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h),
                                  Center(
                                    child: SvgPicture.asset(
                                      'assets/images/safety_net.svg',
                                      width: 153,
                                      height: 85,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        "Your Safety Net",
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          letterSpacing: -1,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Center(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          selectedContacts.length >= 3 
                                              ? 'assets/images/sign_up_safety_net_empty_bigger.svg'
                                              : 'assets/images/sign_up_safety_net_empty.svg',
                                          width: 340.h,
                                          height: selectedContacts.length >= 3 ? 388.h : 223.h,
                                        ),
                                        ...selectedContacts.asMap().entries.map((entry) => _buildContactWrapper(entry.value, entry.key)),
                                        if (selectedContacts.isEmpty)
                                          Positioned(
                                            top: 48.h,
                                            child: Text(
                                              "Add a Trusted Contact",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        if (selectedContacts.isEmpty)
                                          Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: _pickContact,
                                              child: SvgPicture.asset(
                                                'assets/images/sign_up_safety_net_plus.svg',
                                                width: 58.88.h,
                                                height: 57.1.h,
                                              ),
                                            ),
                                          ),
                                        if (selectedContacts.isNotEmpty && selectedContacts.length < 5)
                                          Positioned(
                                            top: 20.h + (selectedContacts.length * 70.h) + (selectedContacts.length == 1 ? 10.h : 0) + (selectedContacts.length >= 2 ? 5.h : 0) + (selectedContacts.length >= 3 ? 20.h : 0) - (selectedContacts.length >= 4 ? 10.h : 0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: GestureDetector(
                                                onTap: _pickContact,
                                                child: SvgPicture.asset(
                                                  'assets/images/sign_up_safety_net_plus.svg',
                                                  width: selectedContacts.length >= 4 ? 45.h : (selectedContacts.length >= 3 ? 55.h : (selectedContacts.length >= 2 ? 40.h : 50.h)),
                                                  height: selectedContacts.length >= 4 ? 45.h : (selectedContacts.length >= 3 ? 55.h : (selectedContacts.length >= 2 ? 40.h : 50.h)),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// App bar with back button
  PreferredSizeWidget buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 40,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: buildBackButton(context),
      ),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Positioned(
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
