import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medally_pro/views/nave_view/home_view/post_view.dart';
import 'package:medally_pro/views/nave_view/home_view/profile_view.dart';
import '../../../const/constant_colors.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.put(HomeController());

  TextEditingController nameCon = TextEditingController();
  TextEditingController desCon = TextEditingController();
  TextEditingController priceCon = TextEditingController();
  TextEditingController ageCon = TextEditingController();
  TextEditingController breedCon = TextEditingController();

  @override
  void dispose() {
    nameCon.dispose();
    desCon.dispose();
    priceCon.dispose();
    ageCon.dispose();
    breedCon.dispose();
    super.dispose();
  }

  Rxn<File> image = Rxn<File>();
  var isLoading = false.obs;

  var itemsActionBar = [
    FloatingActionButton(
      backgroundColor: kPriemryColor,
      onPressed: () => Get.to(() => const PostView()),
      child: Icon(Icons.medical_services_outlined, color: kWhit),
    ),
    FloatingActionButton(
      backgroundColor: kPriemryColor,
      onPressed: () => Get.to(() => const ProfileView2()),
      child: Icon(Icons.person, color: kWhit),
    ),
  ];

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDataStream() {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uId).snapshots();
  }

  Future<void> pickImageFrom(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        image.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error picking image: $e',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
    }
  }

  Future<void> postData() async {
    if (nameCon.text.isEmpty ||
        desCon.text.isEmpty ||
        priceCon.text.isEmpty ||
        ageCon.text.isEmpty ||
        breedCon.text.isEmpty ||
        image.value == null) {
      Get.snackbar('Validation Error', 'All fields are required',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      String imageUrl = await _uploadImage(image.value!, user!.uid);

      await FirebaseFirestore.instance.collection('userPosts').add({
        'userId': user.uid,
        'animalName': nameCon.text.trim(),
        'description': desCon.text.trim(),
        'price': priceCon.text.trim(),
        'age': ageCon.text.trim(),
        'breed': breedCon.text.trim(),
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Post uploaded successfully',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.green);
      Get.back();

      nameCon.clear();
      desCon.clear();
      priceCon.clear();
      ageCon.clear();
      breedCon.clear();
      image.value = null;
    } catch (e) {
      Get.snackbar('Error', 'Error posting data: $e',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _uploadImage(File file, String userId) async {
    try {
      String filePath =
          'postImages/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
