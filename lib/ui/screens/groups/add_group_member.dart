import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rx_splitter/constants/app_colors.dart';
import 'package:rx_splitter/controllers/groups/add_group_member_controller.dart';
import 'package:rx_splitter/utils/extensions/validation.dart';

class AddGroupMemberScreen extends StatefulWidget {
  const AddGroupMemberScreen({required this.groupId, Key? key})
      : super(key: key);

  final int groupId;

  @override
  State<AddGroupMemberScreen> createState() => _AddGroupMemberScreenState();
}

class _AddGroupMemberScreenState extends State<AddGroupMemberScreen> {
  AddGroupMemberController controller = Get.put(AddGroupMemberController());
  bool isLoading = false;

  void changeIsLoadingValue() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    controller.fetchGroupMembersList(widget.groupId);
    super.initState();
  }

  void addGroupMember() async {
    try {
      changeIsLoadingValue();
      var response = await controller.createGroupMember(
          widget.groupId, controller.email.text);
      changeIsLoadingValue();
      if (response.statusCode == 200) {
        Get.snackbar(
          'SUCCESS',
          "Member added successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.green,
          colorText: AppColors.white,
        );
      } else {
        Get.snackbar(
          'FAILURE',
          "Unable to add group member",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
        );
      }
      controller.name.clear();
      controller.email.clear();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add group member'),
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Form(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: controller.name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Group member name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: controller.email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Group member email is required';
                        } else if (val.isValidEmail) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: () {
                            addGroupMember();
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
                                    'Add member',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            thickness: 2,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: controller.obx((state) => Column(
                    children: [
                      const Text(
                        'Members of the group',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state?.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                child: buildTextWidget(state, index),
                              ),
                              const SizedBox(height: 4.0),
                            ],
                          );
                        },
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextWidget(List? state, int index) {
    String? name, email;
    name = state![index]['name'];
    email = state[index]['email'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          name!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          email!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        const Divider(thickness: 1.5),
      ],
    );
  }
}
