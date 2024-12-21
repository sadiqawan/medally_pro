import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medally_pro/views/nave_view/home_view/home_controller.dart';
import '../../../../componants/medicin_card.dart';
import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';

class MedicineListView extends StatelessWidget {
  const MedicineListView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Active Medicine',
          style: kSubTitle2B.copyWith(color: kWhit),
        ),
        backgroundColor: kPriemryColor,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: homeController.getUserMedicationStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Active Medicine added yet'),
            );
          }

          final medication = snapshot.data!.docs;

          return ListView.builder(
            itemCount: medication.length,
            itemBuilder: (context, index) {
              final medicationData = medication[index].data();
              final medicineName = medicationData['medicineName'] ?? 'Unknown';
              final drName = medicationData['doctorName'] ?? 'N/A';
              final reminderTime = medicationData['reminderTime'] ?? 'N/A';
              final durtionTime = medicationData['duration'] ?? 'N/A';
              final remainingDose = medicationData['strength'] ?? 'N/A';
              final memberName = medicationData['memberName'] ?? 'N/A';
              final medicinImage = medicationData['picture'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MedicineCard(
                  onTap: () async {
                    final url = 'https://google.com/search?q=$medicineName';
                    try {
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      } else {
                        Get.snackbar(
                          "Error",
                          "Cannot launch $url",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "An unexpected error occurred: $e",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  medicineName: medicineName,
                  doctorName: drName,
                  durationTime: durtionTime,
                  time: reminderTime,
                  remainingDose: remainingDose,
                  memberName: memberName,
                  image: medicinImage,
                  editOnTap: () {},
                  deleteOnTap: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('usersMemberList')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('medication')
                          .doc(medication[index].id)
                          .delete();
                      Get.snackbar(
                        "Success",
                        "Medication deleted successfully",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                      );
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to delete medication: $e",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
