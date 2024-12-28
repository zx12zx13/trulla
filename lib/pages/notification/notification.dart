// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';

class NotificationsSheet extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;
  final Function(int, bool)? onInvitationResponse;
  final Function(int)? onNotificationRemoved;
  final Function()? onAllNotificationsCleared;

  const NotificationsSheet({
    super.key,
    required this.notifications,
    this.onInvitationResponse,
    this.onNotificationRemoved,
    this.onAllNotificationsCleared,
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
  bool _isProcessing = false;
  Timer? _processingTimer;
  int? _processingIndex;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(widget.notifications);
    _initializeAnimations();
  }

  void _initializeAnimations() {
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

  void _resetProcessingState() {
    _processingTimer?.cancel();
    _processingTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _processingIndex = null;
        });
      }
    });
  }

  Future<void> _showSnackBar(String message, {Color? backgroundColor}) async {
    if (!mounted) return;

    // Tunggu sebentar untuk memastikan widget sudah ter-mount dengan benar
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    // Hitung posisi yang tepat untuk snackbar
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom:
              bottomPadding + viewInsets + 100, // Tambahkan offset yang cukup
          right: 20,
          left: 20,
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        dismissDirection: DismissDirection.horizontal,
        // Tambahkan animation untuk smooth transition
        animation: CurvedAnimation(
          parent: const AlwaysStoppedAnimation(1),
          curve: Curves.easeOutCirc,
        ),
      ),
    );
  }

  Future<void> _handleInvitationResponse(int index, bool accepted) async {
    if (_isProcessing) return;
    if (index < 0 || index >= _notifications.length) return;
    if (_processingIndex != null) return;

    setState(() {
      _isProcessing = true;
      _processingIndex = index;
    });

    try {
      await widget.onInvitationResponse?.call(index, accepted);

      if (!mounted) return;

      setState(() {
        _notifications.removeAt(index);
      });

      await _showSnackBar(
        accepted ? 'Invitation accepted' : 'Invitation declined',
        backgroundColor:
            accepted ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
      );
    } catch (e) {
      if (mounted) {
        await _showSnackBar(
          'Failed to process invitation',
          backgroundColor: Colors.red,
        );
      }
    } finally {
      _resetProcessingState();
    }
  }

  Future<void> _removeNotification(int index) async {
    if (_isProcessing) return;
    if (index < 0 || index >= _notifications.length) return;
    if (_processingIndex != null) return;

    try {
      // Panggil callback
      await widget.onNotificationRemoved?.call(index);

      if (!mounted) return;

      // Update state
      setState(() {
        _notifications.removeAt(index);
      });

      await _showSnackBar('Notification removed');
    } catch (e) {
      if (mounted) {
        await _showSnackBar(
          'Failed to remove notification',
          backgroundColor: Colors.red,
        );
      }
    } finally {
      _resetProcessingState();
    }
  }

  Future<void> _clearAllNotifications() async {
    if (_isProcessing) return;
    if (_processingIndex != null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await widget.onAllNotificationsCleared?.call();

      if (!mounted) return;

      setState(() {
        _notifications.clear();
      });

      await _showSnackBar('All notifications cleared');
    } catch (e) {
      if (mounted) {
        await _showSnackBar(
          'Failed to clear notifications',
          backgroundColor: Colors.red,
        );
      }
    } finally {
      _resetProcessingState();
    }
  }

  void _showMoreOptions(BuildContext context, int index) {
    if (_isProcessing) return;
    if (index < 0 || index >= _notifications.length) return;
    if (_processingIndex != null) return;

    final notification = _notifications[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF242938),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isDismissible: !_isProcessing,
      enableDrag: !_isProcessing,
      builder: (context) => WillPopScope(
        onWillPop: () async => !_isProcessing,
        child: SafeArea(
          child: Container(
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
                  },
                  isDestructive: true,
                ),
                if (notification['type'] == 'invitation') ...[
                  _buildOptionItem(
                    icon: Icons.check_circle_outline,
                    title: 'Accept Invitation',
                    onTap: () {
                      Navigator.pop(context);
                      _handleInvitationResponse(index, true);
                    },
                  ),
                  _buildOptionItem(
                    icon: Icons.cancel_outlined,
                    title: 'Decline Invitation',
                    onTap: () {
                      Navigator.pop(context);
                      _handleInvitationResponse(index, false);
                    },
                  ),
                ],
                const SizedBox(height: 8),
                if (!_isProcessing)
                  _buildOptionItem(
                    icon: Icons.close,
                    title: 'Cancel',
                    onTap: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !_isProcessing ? onTap : null,
        child: Opacity(
          opacity: _isProcessing ? 0.5 : 1.0,
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
                    color:
                        isDestructive ? const Color(0xFFFF5252) : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
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
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_notifications.isNotEmpty)
                    TextButton.icon(
                      onPressed: !_isProcessing ? _clearAllNotifications : null,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: const Text('Clear All'),
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
                ? _buildEmptyState()
                : _buildNotificationsList(scrollController),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            'No notifications',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
              opacity: _fadeAnimation,
              child: Dismissible(
                key: ValueKey('notification_${notification.hashCode}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  if (_isProcessing || _processingIndex != null) return false;

                  // Tambahkan setState di sini
                  setState(() {
                    _isProcessing = true;
                    _processingIndex = index;
                  });
                  return true;
                },
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
                onDismissed: (direction) async {
                  // Ubah ini menjadi async
                  await _removeNotification(index);

                  // Tambahkan setState setelah notifikasi dihapus
                  if (mounted) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                  }
                },
                child: _buildNotificationItem(notification, index),
              )),
        );
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, int index) {
    final isDeadline = notification['type'] == 'deadline';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E2D),
        borderRadius: BorderRadius.circular(12),
        border: isDeadline
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
          onTap: !_isProcessing ? () => _showMoreOptions(context, index) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconContainer(
                  icon: isDeadline
                      ? Icons.timer_outlined
                      : Icons.group_add_rounded,
                  color: isDeadline
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
                              notification['title'] ?? 'No Title',
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
                            onPressed: !_isProcessing
                                ? () => _showMoreOptions(context, index)
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['description'] ?? 'No description',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isDeadline)
                        _buildDeadlineInfo(notification)
                      else if (notification['type'] == 'invitation')
                        _buildInvitationActions(index),
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

  Widget _buildDeadlineInfo(Map<String, dynamic> notification) {
    return Row(
      children: [
        Text(
          'Due in ${notification['daysRemaining'] ?? 0} days',
          style: const TextStyle(
            color: Color(0xFFFF5252),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationActions(int index) {
    final isProcessingThis = _processingIndex == index;

    if (isProcessingThis) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Accept',
                  isPrimary: true,
                  onPressed: () => _handleInvitationResponse(index, true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Decline',
                  isPrimary: false,
                  onPressed: () => _handleInvitationResponse(index, false),
                ),
              ),
            ],
          ),
        ),
      ],
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
        onTap: !_isProcessing ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: _isProcessing ? 0.5 : 1.0,
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
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

// Extension untuk memvalidasi dan memformat notifikasi
extension NotificationValidation on Map<String, dynamic> {
  bool get isValid {
    return containsKey('type') &&
        containsKey('title') &&
        containsKey('description');
  }

  bool get isInvitation => this['type'] == 'invitation';
  bool get isDeadline => this['type'] == 'deadline';

  String get formattedTitle => this['title'] ?? 'No Title';
  String get formattedDescription => this['description'] ?? 'No Description';

  DateTime get timestamp {
    if (containsKey('timestamp') && this['timestamp'] != null) {
      return DateTime.tryParse(this['timestamp']) ?? DateTime.now();
    }
    return DateTime.now();
  }

  String get formattedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
