import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  const Pagination({super.key});

  @override
  _PaginationWidgetState createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<Pagination> {
  int currentPage = 1;
  int pageSize = 15; // Default page size
  final List<int> pageSizes = [15, 30, 45, 60, 75, 100];
  final int totalItems = 500; // Example total items in the dataset

  int get totalPages => (totalItems / pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First Page Button
          _buildIconButton(Icons.first_page, _goToFirstPage, currentPage > 1),

          // Previous Page Button
          _buildIconButton(
              Icons.chevron_left, _goToPreviousPage, currentPage > 1),

          // Current Page Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$currentPage / $totalPages',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // Next Page Button
          _buildIconButton(
              Icons.chevron_right, _goToNextPage, currentPage < totalPages),

          // Last Page Button
          _buildIconButton(
              Icons.last_page, _goToLastPage, currentPage < totalPages),

          // Page Size Selection
          const SizedBox(width: 16), // Spacing between buttons and page size
          GestureDetector(
            onTap: _showPageSizeMenu,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$pageSize',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build icon buttons with enable/disable logic
  Widget _buildIconButton(
      IconData icon, VoidCallback onPressed, bool isEnabled) {
    return IconButton(
      icon: Icon(
        icon,
        size: 24,
        color: isEnabled ? Colors.blueAccent : Colors.grey,
      ),
      onPressed: isEnabled ? onPressed : null,
    );
  }

  // Function to show page size popup menu
  void _showPageSizeMenu() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);

    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx, // Align horizontally
        offset.dy + button.size.height + 8, // Position below the text
        offset.dx + button.size.width,
        offset.dy,
      ),
      items: pageSizes.map((size) {
        return PopupMenuItem<int>(
          value: size,
          child: Center(
            child: Text(
              '$size',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    ).then((selectedSize) {
      if (selectedSize != null) {
        setState(() {
          pageSize = selectedSize;
          currentPage = 1; // Reset to the first page on size change
        });
      }
    });
  }

  // Navigation logic for buttons
  void _goToFirstPage() {
    setState(() {
      currentPage = 1;
    });
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  void _goToNextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _goToLastPage() {
    setState(() {
      currentPage = totalPages;
    });
  }
}
