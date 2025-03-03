import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/RecipeProvider.dart';
import '/model/RecipeItem.dart';

class EditScreen extends StatefulWidget {
  final RecipeItem item; // ✅ ต้องมีตัวแปร item

  const EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;

  // รายการหมวดหมู่ของสูตรอาหาร
  final List<String> _categories = [
    "อาหารคาว",
    "อาหารหวาน",
    "เครื่องดื่ม",
    "อาหารว่าง",
    "อาหารเพื่อสุขภาพ"
  ];
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _descriptionController = TextEditingController(text: widget.item.description);
    _ingredientsController = TextEditingController(text: widget.item.ingredients);
    _stepsController = TextEditingController(text: widget.item.steps);
    _selectedCategory = widget.item.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _updateRecipe() {
    if (_formKey.currentState!.validate()) {
      var provider = Provider.of<RecipeProvider>(context, listen: false);
      provider.updateRecipe(
        widget.item.keyID,
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _ingredientsController.text.trim(),
        _stepsController.text.trim(),
        category: _selectedCategory,
      );

      // แสดง SnackBar แจ้งเตือนอัปเดตสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("อัปเดตสูตรอาหารสำเร็จ!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      // ปิดหน้าจอหลังจากอัปเดต
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขสูตรอาหาร"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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

                const SizedBox(height: 16),

                // ✅ Dropdown สำหรับเลือกหมวดหมู่
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "หมวดหมู่"),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _updateRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("อัปเดตสูตรอาหาร"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
