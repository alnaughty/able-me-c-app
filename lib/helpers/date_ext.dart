import 'package:intl/intl.dart';

extension TIMEAGO on DateTime {
  String get formatTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      final formattedDate = DateFormat('MMM dd, yyyy').format(this);
      return formattedDate;
    }
  }
}
