import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/RecipeProvider.dart';
import '/model/RecipeItem.dart';

class FormScreen extends StatefulWidget {
  final RecipeItem? recipe; // ทำให้รองรับการแก้ไขข้อมูลเดิมได้

  const FormScreen({super.key, this.recipe});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe?.title ?? "");
    _descriptionController = TextEditingController(text: widget.recipe?.description ?? "");
    _ingredientsController = TextEditingController(text: widget.recipe?.ingredients ?? "");
    _stepsController = TextEditingController(text: widget.recipe?.steps ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      var provider = Provider.of<RecipeProvider>(context, listen: false);

      if (widget.recipe == null) {
        // เพิ่มสูตรอาหารใหม่
        provider.addRecipe(
          RecipeItem(
            keyID: DateTime.now().toString(),
            title: _titleController.text,
            description: _descriptionController.text,
            ingredients: _ingredientsController.text,
            steps: _stepsController.text,
            date: DateTime.now(),
          ),
        );
      } else {
        // แก้ไขสูตรอาหารเดิม
        provider.updateRecipe(
          widget.recipe!.keyID,
          _titleController.text,
          _descriptionController.text,
          _ingredientsController.text,
          _stepsController.text,
        );
      }
      Navigator.pop(context); // ปิดหน้า FormScreen กลับไปที่หน้าหลัก
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.recipe != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "แก้ไขสูตรอาหาร" : "เพิ่มสูตรอาหาร"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "ชื่อสูตรอาหาร"),
                validator: (value) => value!.isEmpty ? "กรุณากรอกชื่อสูตรอาหาร" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "รายละเอียด"),
                validator: (value) => value!.isEmpty ? "กรุณากรอกรายละเอียด" : null,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: "วัตถุดิบ"),
                validator: (value) => value!.isEmpty ? "กรุณาป้อนวัตถุดิบ" : null,
              ),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(labelText: "ขั้นตอนการทำ"),
                validator: (value) => value!.isEmpty ? "กรุณาป้อนขั้นตอนการทำ" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text(isEditing ? "อัปเดตสูตรอาหาร" : "เพิ่มสูตรอาหาร"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
