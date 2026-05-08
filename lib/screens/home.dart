import 'package:flutter/material.dart';
import 'addItem.dart';
import 'recipes.dart';

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
          color: Colors.transparent,
          child: Container(
            width: 270,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("🔔 Alerts",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                if (filtered.isEmpty)
                  const Text("No alerts 🎉")
                else
                  ...filtered.map((item) {
                    final status = item["status"] ?? "";
                    final isSoon = status == "soon";

                    final color = isSoon
                        ? const Color(0xFFFFB300)
                        : const Color(0xFFD50000);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${item["name"] ?? ""} → "
                              "${isSoon ? "Expiring" : "Expired"} on "
                              "${item["expiry"] ?? "--"}",
                            ),
                          ),
                        ],
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

  void showItemDetails(Map<String, String?> item) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(item["name"] ?? ""),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Produced: ${item["produced"] ?? "--"}"),
              Text("Added: ${item["added"] ?? "--"}"),
              Text("Expires: ${item["expiry"] ?? "--"}"),
            ],
          ),
        );
      },
    );
  }

  // 🖱 HOVER CARD WRAPPER (NEW FEATURE)
  Widget buildHoverCard(Map<String, String?> item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {}),
      child: Tooltip(
        message:
            "${item["name"]}\nStatus: ${item["status"]}\nExpires: ${item["expiry"]}",
        child: GestureDetector(
          onTap: () => showItemDetails(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                )
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                Text("📦 ${item["produced"] ?? "--"}"),
                Text("➕ ${item["added"] ?? "--"}"),
                Text("⏳ ${item["expiry"] ?? "--"}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F4),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "🥦 PantryPal ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: Color(0xFF00C853)),
            onPressed: openNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.person_outline,
                color: Color(0xFF00C853)),
            onPressed: openProfile,
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Smart Pantry AI Dashboard",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                  "Track expiry • Reduce waste • Smart suggestions",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (_, i) {
                return buildHoverCard(items[i]);
              },
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
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: "Pantry"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Recipes"),
        ],
      ),
    );
  }
}
