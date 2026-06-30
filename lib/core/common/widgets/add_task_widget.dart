import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clause_verify/core/common/widgets/custom_text.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';

/// ===========================
/// TodoController
/// ===========================
class TodoController extends GetxController {
  var todos = <TextEditingController>[].obs;
  final bool initWithField;

  TodoController({this.initWithField = true});

  @override
  void onInit() {
    super.onInit();
    if (initWithField) {
      addTodoField();
    }
  }

  @override
  void onClose() {
    for (var c in todos) {
      c.dispose();
    }
    super.onClose();
  }

  void addTodoField() {
    todos.add(TextEditingController());
  }

  void removeTodoField(int index) {
    todos[index].dispose();
    todos.removeAt(index);
  }

  List<String> getTodoValues() {
    return todos.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();
  }

  void submitTodos(Function(List<String> todos) onSubmit) {
    final todosList = getTodoValues();
    onSubmit(todosList);
  }
}

/// ===========================
/// DynamicTodoWidget (UI)
/// ===========================
class DynamicTodoWidget extends StatelessWidget {
  final Function(List<String> todos) onSubmit;
  final bool initWithField;

  DynamicTodoWidget({
    super.key,
    required this.onSubmit,
    this.initWithField = true,
  });

  late final TodoController controller = Get.put(
    TodoController(initWithField: initWithField),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool showSubmit = controller.todos.any((c) => c.text.trim().isNotEmpty);

      return Column(
        children: [
          ...controller.todos.asMap().entries.map((entry) {
            int index = entry.key;
            TextEditingController todoController = entry.value;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  if (showSubmit)
                    GestureDetector(
                      onTap: () => controller.removeTodoField(index),
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      onChanged: (_) => controller.todos.refresh(), // important
                      decoration: InputDecoration(
                        hintText: "Write task",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: controller.addTodoField,
                icon: const Icon(
                  Icons.add,
                  color: AppColors.tealColor,
                  size: 20,
                ),
                label: CustomText(
                  text: "Add More",
                  color: AppColors.tealColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 10.w),

              if (showSubmit)
                OutlinedButton(
                  onPressed: () => controller.submitTodos(onSubmit),
                  child: const Text("Submit"),
                ),
            ],
          ),
        ],
      );
    });
  }
}
