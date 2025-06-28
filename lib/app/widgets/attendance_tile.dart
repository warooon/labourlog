import 'package:flutter/material.dart';

class AttendanceTile extends StatefulWidget {
  final Map employee;
  final String initialStatus;
  final bool initiallySelected;
  final Function(String status) onStatusChange;
  final Function(bool selected)? onSelect;

  const AttendanceTile({
    super.key,
    required this.employee,
    required this.initialStatus,
    required this.initiallySelected,
    required this.onStatusChange,
    this.onSelect,
  });

  @override
  State<AttendanceTile> createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  late String status;
  late bool selected;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
    selected = widget.initiallySelected;
  }

  Color _getShadowColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green.withValues(alpha: 0.3);
      case 'leave':
        return Colors.yellow.withValues(alpha: 0.3);
      default:
        return Colors.red.withValues(alpha: 0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = widget.employee['name'] ?? '';
    final category = widget.employee['category'] ?? '';
    final avatarUrl = widget.employee['avatar_url'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() => selected = !selected);
        widget.onSelect?.call(selected);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _getShadowColor(status),
              blurRadius: selected ? 10 : 4,
              offset: Offset(0, selected ? 6 : 2),
            ),
          ],
          border:
              selected
                  ? Border.all(color: Colors.black.withValues(alpha: 0.2))
                  : null,
        ),
        child: ListTile(
          leading:
              avatarUrl != null
                  ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
                  : CircleAvatar(
                    backgroundColor: (isDark ? Colors.white : Colors.black),
                    child: Text(
                      name.isNotEmpty ? name[0] : '?',
                      style: TextStyle(
                        color: (isDark ? Colors.black : Colors.white),
                      ),
                    ),
                  ),
          title: Text(
            name,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          ),
          subtitle: Text(category),
          trailing: DropdownButton<String>(
            value: status,
            underline: SizedBox(),
            items:
                ['present', 'absent', 'leave']
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s[0].toUpperCase() + s.substring(1)),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => status = value);
                widget.onStatusChange(value);
              }
            },
          ),
        ),
      ),
    );
  }
}
