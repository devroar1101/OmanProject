import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  final int totalItems; // Total number of items
  final int initialPageSize; // Initial page size
  final int initialPage; // Initial page number
  final Function(int page, int pageSize) onPageChange; // Callback to parent

  const Pagination({
    super.key,
    required this.totalItems,
    this.initialPageSize = 30,
    this.initialPage = 1,
    required this.onPageChange,
  });

  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  late int currentPage;
  late int pageSize;
  late int totalItem;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    pageSize = widget.initialPageSize;
    totalItem = widget.totalItems;
    print('total count :$totalItem');
  }

  int get totalPages => (widget.totalItems / pageSize).ceil();
  int get startItem => ((currentPage - 1) * pageSize) + 1;
  int get endItem => (currentPage * pageSize > widget.totalItems)
      ? widget.totalItems
      : currentPage * pageSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: currentPage > 1 ? Colors.blue : Colors.grey,
          onPressed: currentPage > 1 ? _goToPreviousPage : null,
        ),

        // Current Page Display
        Text(
          '$startItem - $endItem / $totalItem',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),

        // Next Button
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: currentPage < totalPages ? Colors.blue : Colors.grey,
          onPressed: currentPage < totalPages ? _goToNextPage : null,
        ),

        // Page Size Dropdown
        const SizedBox(width: 10),
        DropdownButton<int>(
          value: pageSize,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          underline: Container(
            height: 0, // Remove default underline
          ),
          onChanged: (int? newPageSize) {
            if (newPageSize != null) {
              setState(() {
                pageSize = newPageSize;
                currentPage = 1; // Reset to the first page
              });
              widget.onPageChange(currentPage, pageSize);
            }
          },
          items: [15, 30, 50, 100].map<DropdownMenuItem<int>>((int size) {
            return DropdownMenuItem<int>(
              value: size,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: size == pageSize
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$size',
                  style: TextStyle(
                    color: size == pageSize ? Colors.blue : Colors.black,
                    fontWeight:
                        size == pageSize ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _goToPreviousPage() {
    setState(() {
      currentPage--;
    });
    widget.onPageChange(currentPage, pageSize);
  }

  void _goToNextPage() {
    setState(() {
      currentPage++;
    });
    widget.onPageChange(currentPage, pageSize);
  }
}
