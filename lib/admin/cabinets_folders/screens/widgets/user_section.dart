import 'package:flutter/material.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_permission.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';

class UserPane extends StatelessWidget {
  final List<UserMaster> users;
  final List<FolderPermission> permissions;
  final int cabinetId;
  final int folderId;
  final Function(String) onSearch;
  final Function(int) onTogglePermission;

  const UserPane({
    super.key,
    required this.users,
    required this.permissions,
    required this.cabinetId,
    required this.folderId,
    required this.onSearch,
    required this.onTogglePermission,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search Users',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: onSearch,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final hasPermission = permissions.any(
                (permission) =>
                    permission.folderId == folderId &&
                    permission.userId == user.id,
              );

              return ListTile(
                title: Text(user.name),
                trailing: folderId != -1
                    ? Icon(
                        hasPermission
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: hasPermission ? Colors.green : Colors.grey,
                      )
                    : const SizedBox.shrink(),
                onTap: () => onTogglePermission(user.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
