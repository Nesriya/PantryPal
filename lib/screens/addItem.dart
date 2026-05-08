import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController producedController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  String selectedCategory = "General";

  final List<String> categories = [
    "General",
    "Dairy",
    "Meat",
    "Fruits",
    "Vegetables",
    "Grains",
    "Drinks",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ BACKGROUND IMAGE ADDED HERE
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(""),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 50),

              // HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🥦 Add New Pantry Item",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Track expiry dates and reduce food waste easily.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ITEM NAME
              buildInputCard(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Item Name",
                    prefixIcon: Icon(
                      Icons.fastfood,
                      color: Color(0xFF00C853),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // CATEGORY
              buildInputCard(
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.category,
                      color: Color(0xFF00C853),
                    ),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 18),

              // PRODUCTION DATE
              buildInputCard(
                child: TextField(
                  controller: producedController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Production Date",
                    prefixIcon: Icon(
                      Icons.production_quantity_limits,
                      color: Color(0xFF00C853),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );

                    if (pickedDate != null) {
                      producedController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),
              ),

              const SizedBox(height: 18),

              // EXPIRY DATE
              buildInputCard(
                child: TextField(
                  controller: expiryController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Expiry Date",
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      color: Color(0xFF00C853),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2035),
                    );

                    if (pickedDate != null) {
                      expiryController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),
              ),

              const SizedBox(height: 35),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${nameController.text} added successfully 🎉",
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save Item",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }
}
