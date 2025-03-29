import 'package:flutter/material.dart';

/// Tile builder for all Help and Guidance sub-pages

class TileBuilder {
  // Method to build a tile with step content
  static Widget buildStepTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        child: ListTile(
          title: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  // Method to build a title with the same style for consistency
  static Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Method to create a standard AppBar for each screen
  static AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(title),
    );
  }

  // Method to wrap all content in Padding without RefreshIndicator
  static Widget buildBody(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [child],
      ),
    );
  }
}
