import 'package:flutter/material.dart';

class CustomAppBar {
  /// A method to create and return a custom AppBar widget.
  static PreferredSizeWidget build({
    required String side,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 3), // Offset in x and y direction
            ),
          ],
        ),
        child:side == 'Admin'? AppBar(
          automaticallyImplyLeading: false, // Removes the pop-back icon
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/gstb_logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          actions: [
              IconButton(
                icon: const Icon(Icons.dashboard),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ],
        ): AppBar(
          automaticallyImplyLeading: false, // Removes the pop-back icon
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/gstb_logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          actions: [
              IconButton(
                icon: const Icon(Icons.dashboard),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.inbox),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.outbox),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ],
        ),
      ),
    );
  }
}
