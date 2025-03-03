import '/model/RecipeItem.dart';
import '/provider/RecipeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final RecipeItem item;

  const EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stepsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    descriptionController.text = widget.item.description;
    ingredientsController.text = widget.item.ingredients;
    stepsController.text = widget.item.steps;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    ingredientsController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Recipe'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อสูตรอาหาร'),
                autofocus: true,
                controller: titleController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนชื่อสูตรอาหาร";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'รายละเอียดสูตร'),
                maxLines: 3,
                controller: descriptionController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'วัตถุดิบ'),
                maxLines: 3,
                controller: ingredientsController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ขั้นตอนการทำ'),
                maxLines: 5,
                controller: stepsController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    var provider =
                        Provider.of<RecipeProvider>(context, listen: false);

                    provider.updateRecipe(
                      widget.item.keyID,
                      titleController.text.trim(),
                      descriptionController.text.trim(),
                      ingredientsController.text.trim(),
                      stepsController.text.trim(),
                    );

                    // แสดง SnackBar แจ้งเตือนอัปเดตสำเร็จ
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Recipe updated successfully!",
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    );

                    // รอ 2 วินาทีแล้วปิดหน้าจอ
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: const Text('แก้ไขข้อมูลสูตรอาหาร'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
