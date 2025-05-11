import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'package:easy_localization/easy_localization.dart';
import 'listmum_one_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'dart:typed_data';

// ignore_for_file: must_be_immutable
class SafetynetlittleliftsModel {
  SafetynetlittleliftsModel({
    List<ListmumOneItemModel>? listmumOneItemList,
    bool? isLoading,
    int? safetynetFileCount,
  })  : listmumOneItemList = listmumOneItemList ?? const [],
        isLoading = isLoading ?? true,
        safetynetFileCount = safetynetFileCount ?? 0;

  final List<ListmumOneItemModel> listmumOneItemList;
  bool isLoading;
  int safetynetFileCount;
  Map<String, dynamic>? person1Data;
  Map<String, dynamic>? contactDebugInfo;
  Uint8List? contactAvatar;

  Future<void> fetchSafetynetFiles() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw Exception('No user logged in');
      }

      print('Fetching safetynet files for user: ${user.email}');
      
      // Initialize contactDebugInfo as a map to store all contacts
      contactDebugInfo = {};
      
      // First, get all contacts from the phone
      final contacts = await ContactsService.getContacts();
      print('Found ${contacts.length} contacts');
      
      // Create a map of normalized phone numbers to contacts for quick lookup
      final phoneToContact = <String, Contact>{};
      for (var contact in contacts) {
        if (contact.phones != null) {
          for (var phone in contact.phones!) {
            final normalizedPhone = phone.value?.replaceAll(RegExp(r'[\s\-\(\)]'), '') ?? '';
            if (normalizedPhone.isNotEmpty) {
              phoneToContact[normalizedPhone] = contact;
            }
          }
        }
      }

      // Fetch all safetynet documents at once
      final safetynetSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('safetynet')
          .get();

      print('Found ${safetynetSnapshot.docs.length} safetynet documents');
      safetynetFileCount = safetynetSnapshot.docs.length;
      
      // Process all documents
      for (var doc in safetynetSnapshot.docs) {
        print('Processing document: ${doc.id}');
        final personData = doc.data();
        print('Document data: $personData');
        
        final personIndex = int.parse(doc.id.replaceAll('person', ''));
        print('Person index: $personIndex');
        
        // Store initial data from Firebase
        contactDebugInfo!['person$personIndex'] = {
          'name': personData['name'] ?? 'Unknown',
          'phone': personData['phone'] ?? 'No phone number',
          'hasAvatar': false,
          'avatarData': null,
        };
        
        // Try to match with phone contact
        if (personData['phone'] != null) {
          final phoneNumber = personData['phone'] as String;
          final normalizedPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
          print('Looking for contact with phone: $normalizedPhone');
          
          // Look for matching contact
          Contact? matchingContact;
          for (var entry in phoneToContact.entries) {
            if (entry.key.contains(normalizedPhone) || normalizedPhone.contains(entry.key)) {
              matchingContact = entry.value;
              print('Found matching contact: ${matchingContact.displayName}');
              break;
            }
          }
          
          if (matchingContact != null) {
            print('Processing contact: ${matchingContact.displayName} for person$personIndex');
            
            // Get avatar data
            Uint8List? avatarData;
            if (matchingContact.avatar != null && matchingContact.avatar!.isNotEmpty) {
              try {
                avatarData = Uint8List.fromList(matchingContact.avatar!);
                print('Successfully processed avatar data');
              } catch (e) {
                print('Error processing avatar data: $e');
                avatarData = null;
              }
            }
            
            // Get display name
            final displayName = matchingContact.givenName?.isNotEmpty == true 
                ? matchingContact.givenName 
                : matchingContact.displayName?.split(' ').first ?? 'Unknown';
            
            // Update contact info
            contactDebugInfo!['person$personIndex'] = {
              'name': displayName,
              'phone': personData['phone'],
              'hasAvatar': avatarData != null,
              'avatarData': avatarData,
              'emails': matchingContact.emails?.map((e) => e.value).toList() ?? [],
              'rawContact': {
                'id': matchingContact.identifier,
                'displayName': matchingContact.displayName,
                'givenName': matchingContact.givenName,
                'familyName': matchingContact.familyName,
                'middleName': matchingContact.middleName,
                'prefix': matchingContact.prefix,
                'suffix': matchingContact.suffix,
              }
            };
            
            // For person1, also update the contactAvatar field for backward compatibility
            if (personIndex == 1) {
              contactAvatar = avatarData;
            }
          } else {
            print('No matching contact found for phone: $normalizedPhone');
          }
        }
      }
      
      print('Final contactDebugInfo: $contactDebugInfo');
      print('Final safetynetFileCount: $safetynetFileCount');
      isLoading = false;
    } catch (e) {
      print('Error fetching safetynet files: $e');
      isLoading = false;
    }
  }

  static List<ListmumOneItemModel> getListmumOneItemList() => [
        ListmumOneItemModel(
          mumTwo: "lbl_mum".tr(),
          mobileNo: "lbl_6969696969".tr(),
        ),
        ListmumOneItemModel(
          mumTwo: "lbl_dad".tr(),
          mobileNo: "lbl_6969696969".tr(),
        ),
        ListmumOneItemModel(
          mumTwo: "lbl_partner".tr(),
          mobileNo: "lbl_6969696969".tr(),
        ),
      ];
}
