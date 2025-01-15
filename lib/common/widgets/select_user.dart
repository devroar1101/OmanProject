import 'package:flutter/material.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';

class SelectUserWidget extends StatelessWidget {
  final List<User> userList;
  final List<User> selectedUsers;
  final Function(List<User>) onSelectionChanged;

  const SelectUserWidget({
    super.key,
    required this.userList,
    required this.selectedUsers,
    required this.onSelectionChanged,
  });

  // Handle user selection and removal
  void _toggleUserSelection(User user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
      userList.add(user);
    } else {
      userList.remove(user);
      selectedUsers.add(user);
    }
    onSelectionChanged(selectedUsers);
  }

  // Select all users
  void _selectAll() {
    selectedUsers.addAll(userList);
    userList.clear();
    onSelectionChanged(selectedUsers);
  }

  // Remove all users
  void _removeAll() {
    userList.addAll(selectedUsers);
    selectedUsers.clear();
    onSelectionChanged(selectedUsers);
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
          users: userList,
          onUserTap: _toggleUserSelection,
          isRtl: isRtl,
        ),
        // Action Buttons
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectAll,
              child: const Text('Select All'),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: _removeAll,
              child: const Text('Remove All'),
            ),
          ],
        ),
        // Selected Users Box
        _buildUserBox(
          title: 'Selected Users',
          users: selectedUsers,
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
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  String initials = user.name.length >= 2
                      ? user.systemName.substring(0, 2).toUpperCase()
                      : user.systemName
                          .toUpperCase(); // Use first two letters or full name if short

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          getRandomColor(), // Random background color
                      child: Text(
                        initials,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      user.systemName,
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
