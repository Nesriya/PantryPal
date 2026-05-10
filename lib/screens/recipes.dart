import 'package:flutter/material.dart';
import '../user_data.dart';

class Recipes extends StatelessWidget {
  const Recipes({super.key});

  List<Map<String, dynamic>> getSuggestedRecipes() {
    // 1. Fetch names from the central database
    final pantryNames = UserDatabase.pantryItems
        .map((item) => item['name']?.toLowerCase() ?? "")
        .toList();

    List<Map<String, dynamic>> masterRecipeList = [
      {
        "name": "Quick Omelette",
        "ingredients": ["egg", "cheese", "milk"],
        "icon": Icons.egg_alt,
        "time": "5 min",
        "difficulty": "Easy"
      },
      {
        "name": "Tomato Pasta",
        "ingredients": ["pasta", "tomato", "garlic"],
        "icon": Icons.restaurant,
        "time": "15 min",
        "difficulty": "Medium"
      },
      {
        "name": "Fruit Bowl",
        "ingredients": ["apple", "banana", "yogurt"],
        "icon": Icons.apple,
        "time": "3 min",
        "difficulty": "Easy"
      },
    ];

    // 2. Filter logic to match pantry items to recipe ingredients
    return masterRecipeList.where((recipe) {
      List<String> ingredients = recipe['ingredients'] as List<String>;
      return ingredients.any((ing) => pantryNames.any((p) => p.contains(ing)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = getSuggestedRecipes();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/p1.jpg', fit: BoxFit.cover),
          ),
          // Dark Overlay for readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 6, 94, 51), // Dark Green Header
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 2),
                        Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                        SizedBox(height: 2),
                        Text(
                          "Pantry Matches",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
                  child: Row(
                    children: [
                      const Text(
                        "Suggested for you",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Text("${suggestions.length}",
                            style: const TextStyle(
                                color: Color(0xFF00C853),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ),

              suggestions.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState())
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildRecipeCard(suggestions[index]),
                          childCount: suggestions.length,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    final ValueNotifier<bool> isHovered = ValueNotifier(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isHovered,
      builder: (context, hovered, child) {
        return MouseRegion(
          onEnter: (_) => isHovered.value = true,
          onExit: (_) => isHovered.value = false,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 16),
            transform: hovered
                ? (Matrix4.identity()..translate(0, -5, 0))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: hovered ? Colors.white : Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color:
                        hovered ? Colors.black26 : Colors.black.withOpacity(0.1),
                    blurRadius: hovered ? 15 : 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: hovered
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFF2F7F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(recipe['icon'] as IconData,
                    color: const Color(0xFF00C853)),
              ),
              title: Text(recipe['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(recipe['time'],
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 12),
                      const Icon(Icons.bar_chart, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(recipe['difficulty'],
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Matches: ${(recipe['ingredients'] as List<String>).join(', ')}",
                    style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No matches found", style: TextStyle(color: Colors.white70)),
    );
  }
}