import 'package:flutter/material.dart';

// User Model
class User {
  final String id;
  final String nameArabic;
  final String nameEnglish;

  User({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
  });
}

class SelectUserWidget extends StatefulWidget {
  final List<User> userList;
  final List<User> selectedUsers;
  final Function(List<User>) onSelectionChanged;

  SelectUserWidget({
    required this.userList,
    required this.selectedUsers,
    required this.onSelectionChanged,
  });

  @override
  _SelectUserWidgetState createState() => _SelectUserWidgetState();
}

class _SelectUserWidgetState extends State<SelectUserWidget> {
  late List<User> _userList;
  late List<User> _selectedUsers;

  @override
  void initState() {
    super.initState();
    _userList = List.from(widget.userList);
    _selectedUsers = List.from(widget.selectedUsers);
  }

  // Handle user selection and removal
  void _toggleUserSelection(User user) {
    setState(() {
      if (_selectedUsers.contains(user)) {
        _selectedUsers.remove(user);
        _userList.add(user);
      } else {
        _userList.remove(user);
        _selectedUsers.add(user);
      }
      widget.onSelectionChanged(_selectedUsers);
    });
  }

  // Select all users
  void _selectAll() {
    setState(() {
      _selectedUsers.addAll(_userList);
      _userList.clear();
      widget.onSelectionChanged(_selectedUsers);
    });
  }

  // Remove all users
  void _removeAll() {
    setState(() {
      _userList.addAll(_selectedUsers);
      _selectedUsers.clear();
      widget.onSelectionChanged(_selectedUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Directionality.of(context) will give us the current text direction (LTR or RTL)
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // User List Box
        _buildUserBox(
          title: 'User List',
          users: _userList,
          onUserTap: _toggleUserSelection,
          isRtl: isRtl,
        ),
        // Action Buttons
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectAll,
              child: Text('Select All'),
            ),
            ElevatedButton(
              onPressed: _removeAll,
              child: Text('Remove All'),
            ),
          ],
        ),
        // Selected Users Box
        _buildUserBox(
          title: 'Selected Users',
          users: _selectedUsers,
          onUserTap: _toggleUserSelection,
          isRtl: isRtl,
        ),
      ],
    );
  }

  // Build each user box
  Widget _buildUserBox({
    required String title,
    required List<User> users,
    required Function(User) onUserTap,
    required bool isRtl,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(
                      isRtl ? user.nameArabic : user.nameEnglish,
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    ),
                    onTap: () => onUserTap(user),
                    onLongPress: () =>
                        onUserTap(user), // Allow long press for toggle as well
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp2 extends StatefulWidget {
  MyApp2({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  List<User> userList = [
    User(id: '1', nameArabic: 'أحمد', nameEnglish: 'Ahmed'),
    User(id: '2', nameArabic: 'سارة', nameEnglish: 'Sara'),
    User(id: '3', nameArabic: 'محمد', nameEnglish: 'Mohamed'),
    User(id: '4', nameArabic: 'فاطمة', nameEnglish: 'Fatima'),
    User(id: '5', nameArabic: 'علي', nameEnglish: 'Ali'),
  ];

  List<User> selectedUsers = [];

  void _onSelectionChanged(List<User> selectedUsers) {
    setState(() {
      this.selectedUsers = selectedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection
            .ltr, // You can switch this to TextDirection.rtl for RTL mode
        child: Scaffold(
          appBar: AppBar(title: Text('User Selection')),
          body: Center(
            child: SelectUserWidget(
              userList: userList,
              selectedUsers: selectedUsers,
              onSelectionChanged: _onSelectionChanged,
            ),
          ),
        ),
      ),
    );
  }
}
