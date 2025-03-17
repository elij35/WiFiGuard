import 'package:flutter/material.dart';

/// Tile builder for all Help and Guidance sub-pages

class TileBuilder {
  // Method to build a tile with step content
  static Widget buildStepTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3.0,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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

  // Method to build a Tips section
  static Widget buildTipsSection(String tips) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            tips,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Method to wrap all content in Padding without RefreshIndicator
  static Widget buildBody(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [child],
      ),
    );
  }
}
