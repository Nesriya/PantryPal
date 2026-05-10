import 'package:flutter/material.dart';

class UserDatabase {
  // Added default items so "Pantry Matches" isn't empty on first run
  static List<Map<String, String>> pantryItems = [
    {"name": "egg"},
    {"name": "tomato"},
    {"name": "pasta"},
    {"name": "cheese"},
  ];

  // Stores accounts created during the current session
  static List<Map<String, String>> registeredUsers = [];
 static Map<String, String>? currentEmail;
}