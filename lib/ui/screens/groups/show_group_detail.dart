import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rx_splitter/constants/app_colors.dart';
import 'package:rx_splitter/controllers/expenses/expenses_controller.dart';
import 'package:rx_splitter/controllers/groups/add_group_member_controller.dart';
import 'package:rx_splitter/ui/screens/groups/add_group_member.dart';

class ShowGroupDetailScreen extends StatefulWidget {
  const ShowGroupDetailScreen(
      {required this.groupId, required this.groupName, Key? key})
      : super(key: key);

  final int groupId;
  final String groupName;

  @override
  State<ShowGroupDetailScreen> createState() => _ShowGroupDetailScreenState();
}

class _ShowGroupDetailScreenState extends State<ShowGroupDetailScreen> {
  AddGroupMemberController controller = Get.put(AddGroupMemberController());
  final ScrollController _scrollController = ScrollController();
  ExpenseController expenseController = Get.put(ExpenseController());
  bool isFAB = false;
  int? selectedValueId;

  @override
  void initState() {
    controller.fetchGroupMembersList(widget.groupId);
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() {
          isFAB = true;
        });
      } else {
        setState(() {
          isFAB = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.groupName)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.add,
                      color: AppColors.kSecondary,
                    ),
                  ),
                  onTap: () {
                    Get.to(
                      () => AddGroupMemberScreen(
                        groupId: widget.groupId,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: controller.obx(
                      (state) => ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: buildTextWidget(state, index),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.black,
          ),
        ],
      ),
      floatingActionButton: isFAB ? buildNormalFAB() : buildExtendedFAB(),
    );
  }

  Widget buildTextWidget(List? state, int index) {
    String? name;
    // List<dynamic>.from(
    //     state![index]['name'].map((s) => name = s['name']));
    //print(state[index]['groupMembers']);
    name = state![index]['name'];
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.pink,
      ),
      child: Text(
        name!,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget buildExtendedFAB() => AnimatedContainer(
        duration: const Duration(microseconds: 200),
        curve: Curves.linear,
        width: 150,
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: () {
            openAddExpenseDialog();
          },
          backgroundColor: AppColors.kGreen,
          icon: const Icon(Icons.event_note_outlined),
          label: const Center(
            child: Text(
              "Add expense",
              style: TextStyle(fontSize: 15, color: AppColors.white),
            ),
          ),
        ),
      );

  Widget buildNormalFAB() => AnimatedContainer(
        duration: const Duration(microseconds: 200),
        curve: Curves.linear,
        width: 50,
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: () {
            openAddExpenseDialog();
          },
          icon: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.event_note_outlined),
          ),
          label: const SizedBox(),
        ),
      );

  openAddExpenseDialog() {
    return Get.defaultDialog(
      title: widget.groupName,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            const Text('Add Expense'),
            const SizedBox(height: 16),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: expenseController.description,
                    decoration: const InputDecoration(
                        labelText: 'Enter the description'),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: expenseController.expense,
                    decoration:
                        const InputDecoration(labelText: 'Enter the expense'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text('Paid by '),
                      Container(
                        width: 170,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColors.kGreen),
                        child: _buildDropDownOfGroupMembers(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropDownOfGroupMembers() {
    return controller.obx(
      (state) => DropdownButtonFormField<int>(
        hint: const Text('Select one option'),
        value: selectedValueId,
        items: state!.map((value) {
          return DropdownMenuItem<int>(
            value: value['id'],
            child: Text(
              value['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedValueId = value;
          });
        },
        onSaved: (value) {
          setState(() {
            selectedValueId = value;
          });
        },
      ),
    );
  }
}
