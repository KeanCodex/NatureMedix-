import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:naturemedix/components/cust_textformfield.dart';
import 'package:naturemedix/controllers/bookmark_controller.dart';
import 'package:naturemedix/controllers/dashboard_controller.dart';
import 'package:naturemedix/utils/_initApp.dart';
import 'package:naturemedix/utils/responsive.dart';

import 'control_screen.dart';

class BookmarkScreen extends StatefulWidget with Application {
  const BookmarkScreen({super.key});

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> with Application {
  @override
  Widget build(BuildContext context) {
    final DashboardController dashControl = Get.put(DashboardController());
    return GetBuilder<BookmarkController>(
      init: Get.find<BookmarkController>(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color.white),
          centerTitle: true,
          backgroundColor: color.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAll(() => const ControlScreen(), arguments: 0);
            },
          ),
          title: Text(
            'BOOKMARK',
            style: style.displaySmall(context,
                color: color.white,
                fontsize: setResponsiveSize(context, baseSize: 15),
                fontweight: FontWeight.w500,
                fontspace: 2,
                fontstyle: FontStyle.normal),
          ),
          actions: [
            Obx(() {
              return IconButton(
                icon: Icon(
                  controller.ascendingSort.value
                      ? Icons.sort_outlined
                      : Icons.filter_list,
                  color: color.white,
                ),
                onPressed: () {
                  controller.toggleSort();
                },
              );
            }),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(setResponsiveSize(context, baseSize: 17)),
          child: Column(
            children: [
              TextFormFields(
                control: controller.searchController,
                labeltext: 'Search',
                iconData: Icons.search,
                isPassword: false,
              ),
              Gap(setResponsiveSize(context, baseSize: 10)),
              Expanded(
                child: Obx(() {
                  final bookmarks = controller.filteredBookmarks;
                  return bookmarks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                gif.notFound,
                                scale: setResponsiveSize(context, baseSize: 2),
                              ),
                              Text(
                                'No bookmark found',
                                style: style.displaySmall(context,
                                    fontsize: setResponsiveSize(context,
                                        baseSize: 14),
                                    color: color.darkGrey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: bookmarks.length,
                          itemBuilder: (context, index) {
                            final plant = bookmarks[index];
                            return Dismissible(
                              key: Key(plant.plantName),
                              background: Container(color: Colors.red),
                              onDismissed: (direction) {
                                controller.removeBookmark(plant);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${plant.plantName} removed')));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: setResponsiveSize(context,
                                        baseSize: 5)),
                                child: Card(
                                  elevation:
                                      setResponsiveSize(context, baseSize: 4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          setResponsiveSize(context,
                                              baseSize: 5))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: setResponsiveSize(context,
                                            baseSize: 6)),
                                    child: ListTile(
                                      leading: Image.asset(plant.plantImage,
                                          width: 70, height: 70),
                                      title: Text(plant.plantName),
                                      subtitle: Text(
                                          'Scientific Name: ${plant.scientificName}'),
                                      onTap: () {
                                        dashControl.selectPlant(plant, context);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
