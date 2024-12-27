// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class NotificationsSheet extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;

  const NotificationsSheet({
    super.key,
    required this.notifications,
  });

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<Map<String, dynamic>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(widget.notifications);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  void _handleInvitationResponse(int index, bool accepted) {
    setState(() {
      // Tampilkan snackbar sesuai response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accepted ? 'Invitation received' : 'Invitation declined',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor:
              accepted ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20,
          ),
        ),
      );

      // Hapus notifikasi setelah direspon
      _removeNotification(index);
    });
  }

  void _removeNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _showMoreOptions(BuildContext context, int index) {
    final notification = _notifications[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF242938),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildOptionItem(
              icon: Icons.delete_outline,
              title: 'Delete Notification',
              onTap: () {
                Navigator.pop(context);
                _removeNotification(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification removed'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              isDestructive: true,
            ),
            if (notification['type'] == 'invitation') ...[
              _buildOptionItem(
                icon: Icons.check_circle_outline,
                title: 'Receive an Invitation',
                onTap: () {
                  Navigator.pop(context);
                  _handleInvitationResponse(index, true);
                },
              ),
              _buildOptionItem(
                icon: Icons.cancel_outlined,
                title: 'Decline the Invitation',
                onTap: () {
                  Navigator.pop(context);
                  _handleInvitationResponse(index, false);
                },
              ),
            ],
            const SizedBox(height: 8),
            _buildOptionItem(
              icon: Icons.close,
              title: 'Batal',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? const Color(0xFFFF5252) : Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? const Color(0xFFFF5252) : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Column(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_notifications.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _notifications.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All notifications cleared'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: const Text('Delete All'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada notifikasi',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Dismissible(
                            key: Key('notification_$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5252),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              _removeNotification(index);
                            },
                            child: _buildNotificationItem(
                              _notifications[index],
                              index,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E2D),
        borderRadius: BorderRadius.circular(12),
        border: notification['type'] == 'deadline'
            ? Border.all(
                color: const Color(0xFFFF5252).withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle tap on notification
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconContainer(
                  icon: notification['type'] == 'deadline'
                      ? Icons.timer_outlined
                      : Icons.group_add_rounded,
                  color: notification['type'] == 'deadline'
                      ? const Color(0xFFFF5252)
                      : const Color(0xFF2196F3),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                            onPressed: () => _showMoreOptions(context, index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['description'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      if (notification['type'] == 'deadline') ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildActionButton(
                              'See Details',
                              onPressed: () {
                                // Handle view detail
                              },
                            ),
                            const Spacer(),
                            Text(
                              'Remaining: ${notification['daysRemaining']} Days',
                              style: const TextStyle(
                                color: Color(0xFFFF5252),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (notification['type'] == 'invitation') ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildActionButton(
                              'Accept',
                              isPrimary: true,
                              onPressed: () =>
                                  _handleInvitationResponse(index, true),
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              'Decline',
                              isPrimary: false,
                              onPressed: () =>
                                  _handleInvitationResponse(index, false),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildActionButton(
    String label, {
    bool isPrimary = true,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isPrimary
                ? const Color(0xFF2196F3)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
