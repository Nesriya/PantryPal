import 'package:flutter/material.dart';
import 'dart:ui';
import 'addItem.dart'; 
import 'recipes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String username = "User";
  final String email = "user@gmail.com";
  OverlayEntry? _activeOverlay;
  bool isDimmed = false;

  final Color primaryGreen = const Color(0xFF2D6A4F);
  final Color lightMint = const Color(0xFFD8F3DC);

  // Updated items with actual static dates instead of null
  final List<Map<String, String>> items = [
    {"name": "Milk", "status": "soon", "qty": "1L", "loc": "Fridge", "expiry": "May 12", "prod": "May 05"},
    {"name": "Eggs", "status": "safe", "qty": "12pk", "loc": "Fridge", "expiry": "May 20", "prod": "May 01"},
    {"name": "Bread", "status": "expired", "qty": "1 loaf", "loc": "Pantry", "expiry": "May 8", "prod": "May 04"},
    {"name": "Chicken", "status": "soon", "qty": "500g", "loc": "Freezer", "expiry": "May 11", "prod": "May 02"},
  ];

  String _getPantrySummary() {
    int expired = items.where((i) => i['status'] == 'expired').length;
    int soon = items.where((i) => i['status'] == 'soon').length;
    return "$expired Expired • $soon Soon";
  }

  // --- OVERLAY & HOVER LOGIC ---
  void _showTopRightPopup({required Widget content}) {
    _closeOverlay();
    setState(() => isDimmed = true);

    _activeOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(onTap: _closeOverlay, child: Container(color: Colors.transparent)),
          Positioned(
            top: 80, right: 20,
            child: Material(
              color: Colors.transparent,
              child: _buildGlassContainer(
                width: 280, 
                borderRadius: 25, 
                padding: const EdgeInsets.all(20),
                containerColor: Colors.black.withOpacity(0.85),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_activeOverlay!);
  }

  void _closeOverlay() {
    if (_activeOverlay != null) {
      _activeOverlay!.remove();
      _activeOverlay = null;
    }
    setState(() => isDimmed = false);
  }

  Widget _buildHoverAction({required Widget child, double scale = 1.15, VoidCallback? onTap}) {
    double currentScale = 1.0;
    return StatefulBuilder(
      builder: (context, setInternalState) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setInternalState(() => currentScale = scale),
          onExit: (_) => setInternalState(() => currentScale = 1.0),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: currentScale,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutBack,
              child: child,
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/p1.jpg', fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: primaryGreen))),
          AnimatedContainer(duration: const Duration(milliseconds: 300), color: isDimmed ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.3)),
          
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(),
                    _buildSmartDashboard(),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isLargeScreen ? 4 : 2, 
                          crossAxisSpacing: 15, 
                          mainAxisSpacing: 15, 
                          childAspectRatio: 1.02, 
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) => _buildProductCard(index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomDock(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [Icon(Icons.eco_rounded, color: lightMint, size: 30), const SizedBox(width: 8), const Text("PantryPal", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))]),
          Row(
            children: [
              _buildHoverAction(onTap: () => _showTopRightPopup(content: _alertsContent()), child: _buildGlassCircleIcon(Icons.notifications_none_rounded)),
              const SizedBox(width: 15),
              _buildHoverAction(onTap: () => _showTopRightPopup(content: _profileContent()), child: _buildGlassCircleIcon(Icons.person_outline_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartDashboard() {
    return _buildGlassContainer(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(18),
      borderRadius: 25,
      containerColor: primaryGreen.withOpacity(0.7),
      child: Row(
        children: [
          const Icon(Icons.analytics_outlined, color: Colors.white, size: 32),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text("Pantry Insight", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Waste reduced by 12%", style: TextStyle(color: Colors.white70, fontSize: 12)),
            ]
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("STATUS", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.2)),
              Text(_getPantrySummary(), style: TextStyle(color: lightMint, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final item = items[index];
    return _buildGlassContainer(
      borderRadius: 20, padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(item['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
              _buildStatusBadge(item['status']!),
            ],
          ),
          const SizedBox(height: 8),
          _cardRow(Icons.inventory_2_outlined, item['qty']!),
          _cardRow(Icons.location_on_outlined, item['loc']!),
          _cardRow(Icons.event_available_outlined, "Prod: ${item['prod']}"), 
          const Spacer(),
          Text("Exp: ${item['expiry']!}", style: TextStyle(color: lightMint, fontWeight: FontWeight.w900, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == 'safe' ? Colors.greenAccent : (status == 'soon' ? Colors.orangeAccent : Colors.redAccent);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.4))),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.bold)),
    );
  }

  Widget _cardRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [Icon(icon, color: Colors.white38, size: 12), const SizedBox(width: 5), Text(text, style: const TextStyle(color: Colors.white60, fontSize: 10))]),
    );
  }

  Widget _buildGlassCircleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.white.withOpacity(0.2))),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildGlassContainer({required double borderRadius, required Widget child, double? width, EdgeInsetsGeometry? padding, EdgeInsetsGeometry? margin, Color? containerColor}) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: width, padding: padding,
            decoration: BoxDecoration(
              color: containerColor ?? Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // --- POPUP CONTENT ---
  Widget _alertsContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [Icon(Icons.bolt, color: lightMint), const SizedBox(width: 10), const Text("Quick Alerts", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
        const Divider(color: Colors.white24, height: 25),
        ...items.where((i) => i['status'] != 'safe').map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: item['status'] == 'expired' ? Colors.redAccent : Colors.orangeAccent)),
            const SizedBox(width: 10),
            Expanded(child: Text("${item['name']} expires ${item['expiry']}", style: const TextStyle(color: Colors.white70, fontSize: 12))),
          ]),
        )),
      ],
    );
  }

  Widget _profileContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 30, backgroundColor: lightMint.withOpacity(0.2), child: Icon(Icons.person, color: lightMint, size: 35)),
        const SizedBox(height: 12),
        Text(username, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(email, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const Divider(color: Colors.white24, height: 30),
        _profileRow(Icons.history, "Recent Activity"),
        _profileRow(Icons.settings, "Account Settings"),
        const SizedBox(height: 15),
        TextButton.icon(onPressed: () {}, icon: const Icon(Icons.logout, color: Colors.redAccent, size: 18), label: const Text("Logout", style: TextStyle(color: Colors.redAccent))),
      ],
    );
  }

  Widget _profileRow(IconData icon, String text) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [Icon(icon, color: Colors.white70, size: 18), const SizedBox(width: 12), Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))]));
  }

  Widget _buildBottomDock() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: _buildGlassContainer(
          borderRadius: 40, width: 260,
          containerColor: primaryGreen.withOpacity(0.6),
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHoverAction(child: const Icon(Icons.grid_view_rounded, color: Colors.white)),
                _buildHoverAction(
                  scale: 1.2,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const addItem())),
                  child: CircleAvatar(backgroundColor: lightMint, radius: 24, child: Icon(Icons.add_rounded, color: primaryGreen, size: 28)),
                ),
                _buildHoverAction(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Recipes())), child: const Icon(Icons.restaurant_menu_rounded, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}