import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/scanner.dart';
import 'package:tenderboard/office/document_search/screens/document_search_form.dart';

class DocumentSearchHome extends StatefulWidget {
  const DocumentSearchHome({super.key});
  @override
  _StackWithSliderState createState() => _StackWithSliderState();
}

class _StackWithSliderState extends State<DocumentSearchHome> {
  bool _isSliderVisible = false; // Controls the slider visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
          child: AppBar(
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _isSliderVisible = !_isSliderVisible;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Base layer: Row with DisplayDetails and Scanner
          const Row(
            children: [
              Expanded(
                flex: 1,
                child: DisplayDetails(
                  detailKey: 'objectId',
                  headers: [
                    'Subject',
                    'Reference #',
                    'Received Date',
                    'Tender Number',
                  ],
                  data: [
                    'subject'
                        'jobReferenceNumber',
                    'receivedDate',
                    'tenderNumber',
                  ],
                  details: [],
                ),
              ),
              Expanded(
                flex: 1,
                child: Scanner(),
              ),
            ],
          ),
          // Sliding DocumentSearchForm
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right:
                _isSliderVisible ? 0 : -MediaQuery.of(context).size.width * 0.5,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.5, // Slider width
            child: const Material(
              elevation: 0,
              color: Colors.white,
              child: DocumentSearchForm(),
            ),
          ),
        ],
      ),
    );
  }
}

// Example Widgets: DisplayDetails, Scanner, DocumentSearchForm


  





