import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/RecipeProvider.dart';
import '/model/RecipeItem.dart';
import '/formScreen.dart';
import '/editScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RecipeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var recipeProvider = Provider.of<RecipeProvider>(context);
    var recipes = recipeProvider.recipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'สูตรอาหารทั้งหมด',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: recipes.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีสูตรอาหาร',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                var recipe = recipes[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ ชื่อสูตรอาหาร
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ✅ รายละเอียด
                        Text(
                          recipe.description,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),

                        // ✅ หมวดหมู่
                        Text(
                          "หมวดหมู่: ${recipe.category}",
                          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 8),

                        // ✅ วัตถุดิบ
                        Text(
                          "วัตถุดิบ: ${recipe.ingredients}",
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),

                        // ✅ ขั้นตอน
                        Text(
                          "ขั้นตอนการทำ: ${recipe.steps}",
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),

                        // ✅ วันที่เพิ่ม/แก้ไข
                        Text(
                          "เพิ่มเมื่อ: ${recipe.date.toLocal()}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),

                        const Divider(),

                        // ✅ ปุ่มแก้ไขและลบ
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditScreen(item: recipe),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                recipeProvider.removeRecipe(recipe.keyID);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
