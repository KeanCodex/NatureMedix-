import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/cust_ConfirmAlert.dart';
import '../../models/plant_info.dart';
import '../../models/remedy_info.dart';
import '../../utils/_initApp.dart';

class BookmarkController extends GetxController {
  var ascendingSort = true.obs;
  var bookmarkedPlants = <PlantData>[].obs;
  var bookmarkedRemedies = <RemedyInfo>[].obs;
  var searchQuery = ''.obs;
  final searchController = TextEditingController();
  Box? userBox;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text.toLowerCase();
    });
    loadBookmarks();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    update();
  }

  void toggleSort() {
    ascendingSort.value = !ascendingSort.value;
    update();
  }

  Future<void> openUserBox() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Open a Hive box specific to the user's UID.
    userBox = await Hive.openBox(user.uid);
  }

  void removeBookmark(PlantData plant, BuildContext context) async {
    showConfirmValidation(
      context,
      'Delete Bookmark',
      'Do you want to delete?',
      () async {
        bookmarkedPlants.remove(plant);
        await saveBookmarks();
        Get.back();
        Get.snackbar(
          'Success',
          'Successfully delete bookmark.',
          icon: Icon(Icons.delete_outline_outlined,
              color: Application().color.white),
          colorText: Application().color.white,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Application().color.valid,
        );
      },
      Application().gif.removed,
    );
    update();
  }

  void addBookmark(PlantData plant) async {
    if (!bookmarkedPlants.contains(plant)) {
      plant.bookmarkedAt = DateTime.now();
      bookmarkedPlants.add(plant);
      await saveBookmarks();
    }
    update();
  }

  void addRemedyBookmark(RemedyInfo remedy) async {
    if (!bookmarkedRemedies.contains(remedy)) {
      remedy.bookmarkedAt = DateTime.now();
      bookmarkedRemedies.add(remedy);
      await saveBookmarks();
    }
    update();
  }

  void removeRemedyBookmark(RemedyInfo remedy, BuildContext context) async {
    showConfirmValidation(
      context,
      'Delete Bookmark',
      'Do you want to delete?',
      () async {
        Get.back();
        try {
          bookmarkedRemedies.remove(remedy);
          await saveBookmarks();
          Get.snackbar(
            'Success',
            'Successfully delete bookmark.',
            icon: Icon(Icons.delete_outline_outlined,
                color: Application().color.white),
            colorText: Application().color.white,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Application().color.valid,
          );
        } catch (e) {
          print('Error deleting request: $e');
        }
        update();
      },
      Application().gif.removed,
    );
  }

  void removeAllBookmark(BuildContext context) async {
    if (bookmarkedPlants.isEmpty && bookmarkedRemedies.isEmpty) return;
    showConfirmValidation(
      context,
      'Delete Bookmark',
      'Do you want to delete all?',
      () async {
        Get.back();
        try {
          bookmarkedPlants.clear();
          bookmarkedRemedies.clear();
          await saveBookmarks();
          Get.snackbar(
            'Success',
            'Successfully delete all bookmark.',
            icon: Icon(Icons.delete_outline_outlined,
                color: Application().color.white),
            colorText: Application().color.white,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Application().color.valid,
          );
        } catch (e) {
          print('Error deleting request: $e');
        }
        update();
      },
      Application().gif.removed,
    );
  }

  bool isPlantBookmarked(PlantData plant) {
    return bookmarkedPlants.any((p) => p.plantName == plant.plantName);
  }

  bool isRemedyBookmarked(RemedyInfo remedy) {
    return bookmarkedRemedies.any((r) => r.remedyName == remedy.remedyName);
  }

  List<dynamic> get filteredBookmarks {
    final query = searchQuery.value;
    final filteredPlants = bookmarkedPlants.where((plant) {
      return plant.plantName.toLowerCase().contains(query) ||
          plant.scientificName.toLowerCase().contains(query);
    }).toList();
    final filteredRemedies = bookmarkedRemedies.where((remedy) {
      return remedy.remedyName.toLowerCase().contains(query) ||
          remedy.description.toLowerCase().contains(query);
    }).toList();

    List<dynamic> combinedList = [...filteredPlants, ...filteredRemedies];

    // Apply date filter
    DateTime now = DateTime.now();
    combinedList = combinedList.where((item) {
      DateTime? bookmarkDate = (item is PlantData)
          ? item.bookmarkedAt
          : (item as RemedyInfo).bookmarkedAt;
      if (bookmarkDate == null) return false;

      switch (selectedFilter.value) {
        case 'Today':
          return bookmarkDate.day == now.day &&
              bookmarkDate.month == now.month &&
              bookmarkDate.year == now.year;
        case 'Yesterday':
          DateTime yesterday = now.subtract(Duration(days: 1));
          return bookmarkDate.day == yesterday.day &&
              bookmarkDate.month == yesterday.month &&
              bookmarkDate.year == yesterday.year;
        case 'Old':
          return bookmarkDate.isBefore(now.subtract(Duration(days: 2)));
        default: // 'All'
          return true;
      }
    }).toList();

    // Sort the combined list based on ascendingSort
    combinedList.sort((a, b) {
      String nameA =
          (a is PlantData) ? a.plantName : (a as RemedyInfo).remedyName;
      String nameB =
          (b is PlantData) ? b.plantName : (b as RemedyInfo).remedyName;
      return ascendingSort.value
          ? nameA.compareTo(nameB)
          : nameB.compareTo(nameA);
    });
    return combinedList;
  }

  Future<void> saveBookmarks() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if (userBox == null) await openUserBox();
    if (userBox == null) return;

    // Make sure the data is in the correct format before saving
    List<Map<String, dynamic>> plantMaps =
        bookmarkedPlants.map((plant) => plant.toMap()).toList();
    List<Map<String, dynamic>> remedyMaps =
        bookmarkedRemedies.map((remedy) => remedy.toMap()).toList();

    await userBox!.put('$uid-bookmarkedPlants', plantMaps);
    await userBox!.put('$uid-bookmarkedRemedies', remedyMaps);

    // Save to Firestore (when online)
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'bookmarkedPlants':
            bookmarkedPlants.map((plant) => plant.toMap()).toList(),
        'bookmarkedRemedies':
            bookmarkedRemedies.map((remedy) => remedy.toMap()).toList(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> loadBookmarks() async {
    final user = FirebaseAuth.instance.currentUser;

    // Load from Hive (offline)
    if (userBox == null) await openUserBox();
    if (userBox == null) return;

    final plantList = userBox!
        .get('${user!.uid}-bookmarkedPlants', defaultValue: <PlantData>[]);
    final remedyList = userBox!
        .get('${user.uid}-bookmarkedRemedies', defaultValue: <RemedyInfo>[]);

    bookmarkedPlants.value = plantList.cast<PlantData>();
    bookmarkedRemedies.value = remedyList.cast<RemedyInfo>();

    // Load from Firestore (online)
    final docSnapshot =
        await _firestore.collection('users').doc(user.uid).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        final firestorePlants = List.from(data['bookmarkedPlants'] ?? []);
        final firestoreRemedies = List.from(data['bookmarkedRemedies'] ?? []);
        // Update bookmarks with Firestore data (if available)
        bookmarkedPlants.value =
            firestorePlants.map((e) => PlantData.fromMap(e)).toList();
        bookmarkedRemedies.value =
            firestoreRemedies.map((e) => RemedyInfo.fromMap(e)).toList();
      }
    }
  }

  final borderCust = OutlineInputBorder(
    borderSide: BorderSide(color: Application().color.white),
    borderRadius: BorderRadius.circular(15),
  );
}
