import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rx_splitter/constants/app_colors.dart';
import 'package:rx_splitter/controllers/groups/display_groups_controller.dart';
import 'package:rx_splitter/ui/screens/groups/show_group_detail.dart';

class DisplayGroupsScreen extends StatefulWidget {
  const DisplayGroupsScreen({Key? key}) : super(key: key);

  @override
  State<DisplayGroupsScreen> createState() => _DisplayGroupsScreenState();
}

class _DisplayGroupsScreenState extends State<DisplayGroupsScreen> {
  DisplayGroupsController controller = Get.put(DisplayGroupsController());
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void changeIsLoadingValue() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Groups')),
      ),
      body: controller.obx(
        (state) => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: state?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          () => ShowGroupDetailScreen(
                            groupId: state![index]['id'],
                            groupName: state[index]['groupName'],
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(6.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(state![index]['groupName']),
                        ),
                      ),
                    ),
                  );
                },
              ),
        onEmpty: const Center(
          child: Text("Currently, you are not indulged in any group"),
        ),
        onError: (e) => Text(e.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.defaultDialog(
            title: 'Add group',
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller.groupName,
                    decoration: const InputDecoration(
                      labelText: "Group name",
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Group name is mandatory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            changeIsLoadingValue();
                            final response = await controller
                                .createGroup(controller.groupName.text);
                            if (response.statusCode == 200) {
                              changeIsLoadingValue();
                              Get.back();
                              Get.snackbar(
                                  'SUCCESS', 'Group created successfully',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: AppColors.green);
                              controller.onInit();
                            } else {
                              changeIsLoadingValue();
                              Get.snackbar('ERROR',
                                  'Failed to create the group, please Try again!',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: AppColors.red);
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print(e.toString());
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.kPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 15.0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Create',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
