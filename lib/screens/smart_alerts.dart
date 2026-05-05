import 'package:flutter/material.dart';

class SmartAlerts extends StatelessWidget {
  const SmartAlerts({super.key});

  final List<Map<String, String>> items = const [
    {"name": "Bread", "status": "expired", "expiry": "Apr 29"},
    {"name": "Milk", "status": "soon", "expiry": "May 2"},
    {"name": "Chicken", "status": "soon", "expiry": "May 1"},
    {"name": "Eggs", "status": "safe", "expiry": "May 10"},
    {"name": "Rice", "status": "safe", "expiry": "Jun 1"},
  ];

  Color getColor(String status) {
    switch (status) {
      case "expired":
        return const Color(0xFFE53935);
      case "soon":
        return const Color(0xFFFFB300);
      case "safe":
        return const Color(0xFF43A047);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expired = items.where((e) => e["status"] == "expired").toList();
    final soon = items.where((e) => e["status"] == "soon").toList();
    final safe = items.where((e) => e["status"] == "safe").toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Smart Alerts"),
        backgroundColor: const Color(0xFF00C853),
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // 🔥 HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00C853),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    " Items sorted by urgency",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔴 EXPIRED
          _sectionTitle("Expired", Colors.red),
          const SizedBox(height: 10),
          ...expired.map((item) => _itemCard(item, Colors.red)),

          const SizedBox(height: 20),

          // 🟠 SOON
          _sectionTitle("Use Soon", Colors.orange),
          const SizedBox(height: 10),
          ...soon.map((item) => _itemCard(item, Colors.orange)),

          const SizedBox(height: 20),

          // 🟢 SAFE
          _sectionTitle("Safe Items", Colors.green),
          const SizedBox(height: 10),
          ...safe.map((item) => _itemCard(item, Colors.green)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _itemCard(Map<String, String> item, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [

          // status dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          // name
          Expanded(
            child: Text(
              item["name"]!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // expiry
          Text(
            item["expiry"]!,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}