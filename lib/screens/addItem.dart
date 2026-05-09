import 'dart:ui';
import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController producedController =
      TextEditingController();

  final TextEditingController expiryController =
      TextEditingController();

  final TextEditingController quantityController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final Color primaryGreen = const Color(0xFF2D6A4F);
  final Color lightMint = const Color(0xFFD8F3DC);

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
      body: Stack(
        children: [

          // BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/p1.jpg',
              fit: BoxFit.cover,

              // improves image quality
              filterQuality: FilterQuality.high,

              errorBuilder:
                  (context, error, stackTrace) {
                return Container(
                  color: primaryGreen,
                );
              },
            ),
          ),

          // DARK OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),

          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 700,
                ),

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),

                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      // TOP BAR
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [

                          Row(
                            children: [

                              Icon(
                                Icons.eco_rounded,
                                color: lightMint,
                                size: 30,
                              ),

                              const SizedBox(
                                  width: 10),

                              const Text(
                                "Add Item",
                                style: TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 26,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
                              ),
                            ],
                          ),

                          _buildGlassCircleIcon(
                            Icons.person_outline,
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // HEADER CARD
                      _buildGlassContainer(
                        borderRadius: 30,

                        padding:
                            const EdgeInsets.all(
                                22),

                        containerColor:
                            primaryGreen
                                .withOpacity(0.6),

                        child: Row(
                          children: [

                            Container(
                              padding:
                                  const EdgeInsets
                                      .all(14),

                              decoration:
                                  BoxDecoration(
                                color: Colors.white
                                    .withOpacity(
                                        0.15),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            18),
                              ),

                              child: const Icon(
                                Icons
                                    .add_box_rounded,
                                color:
                                    Colors.white,
                                size: 34,
                              ),
                            ),

                            const SizedBox(
                                width: 18),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(
                                    "Add Pantry Product",
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                          21,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          6),

                                  Text(
                                    "Track freshness and reduce waste efficiently.",
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white70,
                                      fontSize:
                                          13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ITEM NAME
                      _buildInputCard(
                        child: TextField(
                          controller:
                              nameController,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(
                            border:
                                InputBorder.none,

                            hintText:
                                "Item Name",

                            hintStyle:
                                TextStyle(
                              color: Colors
                                  .white
                                  .withOpacity(
                                      0.55),
                            ),

                            prefixIcon: Icon(
                              Icons
                                  .fastfood_rounded,
                              color: lightMint,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // CATEGORY
                      _buildInputCard(
                        child:
                            DropdownButtonFormField<
                                String>(
                          dropdownColor:
                              primaryGreen,

                          value:
                              selectedCategory,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(
                            border:
                                InputBorder.none,

                            prefixIcon: Icon(
                              Icons
                                  .category_rounded,
                              color: lightMint,
                            ),
                          ),

                          items: categories
                              .map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child:
                                  Text(category),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              selectedCategory =
                                  value!;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      // QUANTITY
                      _buildInputCard(
                        child: TextField(
                          controller:
                              quantityController,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(
                            border:
                                InputBorder.none,

                            hintText:
                                "Quantity",

                            hintStyle:
                                TextStyle(
                              color: Colors
                                  .white
                                  .withOpacity(
                                      0.55),
                            ),

                            prefixIcon: Icon(
                              Icons
                                  .inventory_2_outlined,
                              color: lightMint,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // STORAGE LOCATION
                      _buildInputCard(
                        child: TextField(
                          controller:
                              locationController,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(
                            border:
                                InputBorder.none,

                            hintText:
                                "Storage Location",

                            hintStyle:
                                TextStyle(
                              color: Colors
                                  .white
                                  .withOpacity(
                                      0.55),
                            ),

                            prefixIcon: Icon(
                              Icons
                                  .location_on_outlined,
                              color: lightMint,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // PRODUCTION DATE
                      _buildInputCard(
                        child: TextField(
                          controller:
                              producedController,

                          readOnly: true,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(
                            border:
                                InputBorder.none,

                            hintText:
                                "Production Date",

                            hintStyle:
                                TextStyle(
                              color: Colors
                                  .white
                                  .withOpacity(
                                      0.55),
                            ),

                            prefixIcon: Icon(
                              Icons
                                  .event_available_outlined,
                              color: lightMint,
                            ),
                          ),

                          onTap: () async {
                            DateTime?
                                pickedDate =
                                await showDatePicker(
                              context: context,

                              initialDate:
                                  DateTime.now(),

                              firstDate:
                                  DateTime(
                                      2020),

                              lastDate:
                                  DateTime(
                                      2035),
                            );

                            if (pickedDate !=
                                null) {
                              producedController
                                  .text =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      // EXPIRY DATE
                      _buildInputCard(
                        child: TextField(
                          controller:
                              expiryController,

                          readOnly: true,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              InputDecoration(
                            border:
                                InputBorder.none,

                            hintText:
                                "Expiry Date",

                            hintStyle:
                                TextStyle(
                              color: Colors
                                  .white
                                  .withOpacity(
                                      0.55),
                            ),

                            prefixIcon: Icon(
                              Icons
                                  .calendar_month_outlined,
                              color: lightMint,
                            ),
                          ),

                          onTap: () async {
                            DateTime?
                                pickedDate =
                                await showDatePicker(
                              context: context,

                              initialDate:
                                  DateTime.now(),

                              firstDate:
                                  DateTime.now(),

                              lastDate:
                                  DateTime(
                                      2035),
                            );

                            if (pickedDate !=
                                null) {
                              expiryController
                                  .text =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 62,

                        child: ElevatedButton(
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                lightMint,

                            elevation: 0,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          22),
                            ),
                          ),

                          onPressed: () {

                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    primaryGreen,

                                content: Text(
                                  "${nameController.text} added successfully 🎉",
                                ),
                              ),
                            );

                            Navigator.pop(
                                context);
                          },

                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              Icon(
                                Icons
                                    .save_rounded,
                                color:
                                    primaryGreen,
                              ),

                              const SizedBox(
                                  width: 10),

                              Text(
                                "Save Item",
                                style:
                                    TextStyle(
                                  color:
                                      primaryGreen,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // SMART TIP
                      _buildGlassContainer(
                        borderRadius: 22,

                        padding:
                            const EdgeInsets.all(
                                18),

                        child: Row(
                          children: [

                            Icon(
                              Icons.auto_awesome,
                              color: lightMint,
                            ),

                            const SizedBox(
                                width: 12),

                            const Expanded(
                              child: Text(
                                "Smart Tip: Add products immediately after shopping for accurate expiry tracking.",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // INPUT CARD
  Widget _buildInputCard({
    required Widget child,
  }) {
    return _buildGlassContainer(
      borderRadius: 20,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      child: child,
    );
  }

  // GLASS CONTAINER
  Widget _buildGlassContainer({
    required double borderRadius,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? containerColor,
  }) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(
              borderRadius),

      child: BackdropFilter(
        filter: ImageFilter.blur(

          // reduced blur for clarity
          sigmaX: 5,
          sigmaY: 5,
        ),

        child: Container(
          padding: padding,

          decoration: BoxDecoration(
            color: containerColor ??
                Colors.white
                    .withOpacity(0.10),

            borderRadius:
                BorderRadius.circular(
                    borderRadius),

            border: Border.all(
              color: Colors.white
                  .withOpacity(0.18),
            ),
          ),

          child: child,
        ),
      ),
    );
  }

  // GLASS ICON
  Widget _buildGlassCircleIcon(
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: Colors.white
            .withOpacity(0.10),

        border: Border.all(
          color: Colors.white
              .withOpacity(0.18),
        ),
      ),

      child: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}
