import 'package:flutter/material.dart';

class MeetingMinutesForm extends StatelessWidget {
  const MeetingMinutesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Meeting Minutes'),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Row (Scan Type)
              Row(
                children: [
                  const Text(
                    "Scan Type",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Radio(value: true, groupValue: true, onChanged: (_) {}),
                      const Text("Letter"),
                      const SizedBox(width: 16),
                      Radio(value: false, groupValue: true, onChanged: (_) {}),
                      const Text("Meeting Minutes"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // File Name & Code
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'File Name & Code',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.lock),
                    onPressed: () {},
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tender Board / Meeting Minutes',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),

              // Meeting Number
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Meeting Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Date
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {},
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Priority
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('High')),
                  DropdownMenuItem(value: '2', child: Text('Medium')),
                  DropdownMenuItem(value: '3', child: Text('Low')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Classification
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Classification',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'A', child: Text('A')),
                  DropdownMenuItem(value: 'B', child: Text('B')),
                  DropdownMenuItem(value: 'C', child: Text('C')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Subject
              TextFormField(
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Comment
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Clear Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text('CLEAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
