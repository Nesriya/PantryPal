import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  final Map<String, String?> item;

  const ItemDetails({super.key, required this.item});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case "safe": return const Color(0xFF4CAF50);
      case "soon": return const Color(0xFF4CAF50);
      case "expired": return const Color(0xFFF44336);
      default: return Colors.grey;
    }
  }

  IconData getStatusIcon(String? status) {
    switch (status) {
      case "safe": return Icons.check_circle;
      case "soon": return Icons.schedule;
      case "expired": return Icons.warning;
      default: return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.item["name"] ?? "Item";
    final status = widget.item["status"] ?? "unknown";
    final produced = widget.item["produced"] ?? "--";
    final added = widget.item["added"] ?? "--";
    final expiry = widget.item["expiry"] ?? "--";
    final color = getStatusColor(status);

    return Scaffold(
      // 🍽️ FOODIE BACKGROUND
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF8E8C8), // Cream
              const Color(0xFFE8F5E8), // Mint
              const Color(0xFFFFF3E0), // Peach
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // 🍎 HERO APP BAR
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      // BACK BUTTON
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(offset: Offset(1, 2), blurRadius: 4, color: Colors.black45),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // 🥛 MAIN ITEM CARD
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: _buildMainItemCard(name, status, color),
                            );
                          },
                        ),

                        const SizedBox(height: 30),

                        // 📊 DATE INFO CARDS
                        _buildDateCard("📦 Produced", produced, const Color(0xFF2196F3)),
                        _buildDateCard("➕ Added to Pantry", added, const Color(0xFF9C27B0)),
                        _buildDateCard("⏳ Expires", expiry, getStatusColor(status)),

                        const SizedBox(height: 40),

                        // 🎚️ PROGRESS BAR (Days remaining)
                        _buildExpiryProgress(expiry),

                        const SizedBox(height: 40),

                        // 🔘 ACTION BUTTONS
                        _buildActionButtons(color),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainItemCard(String name, String status, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.25), Colors.white.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 30, spreadRadius: 0),
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          // 🥚 LARGE ICON
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 25)],
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name.runes.take(1).map((e) => String.fromCharCode(e)).join() : '🍎',
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // 📈 STATUS DISPLAY
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(getStatusIcon(status), color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1.2,
                  shadows: [Shadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black26)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(String title, String date, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.white.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.date_range, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryProgress(String expiry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Time Until Expiry", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
            Text("3 days left", style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF4CAF50)),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Color primaryColor) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.edit,
                label: "Edit Item",
                color: Colors.blue,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                icon: Icons.delete_outline,
                label: "Remove",
                color: Colors.red,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.restaurant_menu, size: 20),
            label: const Text("View Recipes", style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C851),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              shadowColor: const Color(0xFF00C851).withOpacity(0.4),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.1), Colors.transparent]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}