import 'package:flutter/material.dart';
import 'additem.dart';
import 'recipes.dart';
import 'item_details.dart';
import 'smart_alerts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  String username = "Nesriya";
  String email = "nesriya@email.com";

  OverlayEntry? _notificationEntry;

  final List<Map<String, String?>> items = [
    {"name": "Milk", "status": "soon", "produced": "Apr 25", "added": "Apr 28", "expiry": "May 2"},
    {"name": "Eggs", "status": "safe", "produced": "Apr 20", "added": "Apr 27", "expiry": "May 10"},
    {"name": "Bread", "status": "expired", "produced": "Apr 22", "added": "Apr 25", "expiry": "Apr 29"},
    {"name": "Rice", "status": "safe", "produced": "Mar 10", "added": "Apr 20", "expiry": "Jun 1"},
    {"name": "Chicken", "status": "soon", "produced": "Apr 27", "added": "Apr 29", "expiry": "May 1"},
    {"name": "Apple", "status": "safe", "produced": "Apr 24", "added": "Apr 26", "expiry": "May 5"},
  ];

  Color getColor(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case "safe":
        return const Color(0xFF00C853);
      case "soon":
        return const Color(0xFFFFB300);
      case "expired":
        return const Color(0xFFD50000);
      default:
        return Colors.grey;
    }
  }

  IconData getIcon(String? name) {
    switch ((name ?? "").toLowerCase()) {
      case "milk":
        return Icons.water_drop;
      case "eggs":
        return Icons.egg;
      case "bread":
        return Icons.bakery_dining;
      case "chicken":
        return Icons.set_meal;
      case "apple":
        return Icons.apple;
      default:
        return Icons.fastfood;
    }
  }

  // ---------------- NAVIGATION ----------------

  void goToAddItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddItem()),
    );
  }

  void goToRecipes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Recipes()),
    );
  }

  void goToAlerts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SmartAlerts()),
    );
  }

  // ---------------- PROFILE ----------------

  void openProfile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFF00C853),
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 10),
              Text(username,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(email, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- SMART ALERTS OVERLAY ----------------

  void openNotifications() {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    if (_notificationEntry != null) {
      _notificationEntry!.remove();
      _notificationEntry = null;
      return;
    }

    final filtered = items.where((item) {
      final status = item["status"] ?? "";
      return status == "soon" || status == "expired";
    }).toList();

    _notificationEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: 80,
        right: 16,
        child: Material(
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Smart Alerts",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (filtered.isEmpty)
                  const Text("No alerts 🎉")
                else
                  ...filtered.map((item) {
                    final isSoon = item["status"] == "soon";
                    final color =
                        isSoon ? Colors.orange : Colors.red;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${item["name"]} → ${item["expiry"]}",
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_notificationEntry!);
  }

  // ---------------- ITEM DETAILS ----------------

  void showItemDetails(Map<String, String?> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemDetails(item: item),
      ),
    );
  }

  // ---------------- UI CARD ----------------

  Widget buildCard(Map<String, String?> item) {
    return GestureDetector(
      onTap: () => showItemDetails(item),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(getIcon(item["name"]),
                    color: const Color(0xFF00C853)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getColor(item["status"]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (item["status"] ?? "").toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(item["name"] ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("⏳ ${item["expiry"] ?? "--"}"),
          ],
        ),
      ),
    );
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F4),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("🥦 PantryPal",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF00C853)),
            onPressed: goToAlerts,
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF00C853)),
            onPressed: openProfile,
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
              ),
            ),
            child: const Text(
              "Smart Pantry Dashboard",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (_, i) => buildCard(items[i]),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C853),
        onPressed: goToAddItem,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFF00C853),
        onTap: (i) {
          setState(() => selectedIndex = i);

          if (i == 1) goToRecipes();
          if (i == 2) goToAlerts();
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.kitchen), label: "Pantry"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: "Recipes"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Alerts"),
        ],
      ),
    );
  }
}
