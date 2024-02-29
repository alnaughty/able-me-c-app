import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationToggler extends ConsumerStatefulWidget {
  const NotificationToggler({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationTogglerState();
}

class _NotificationTogglerState extends ConsumerState<NotificationToggler> {
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final state = ref.watch(notificationProvider);
    return ListTile(
      leading: Icon(
        Icons.notifications_none_rounded,
        color: textColor,
      ),
      title: const Text("Notification"),
      titleTextStyle: context.fontTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      trailing: Switch.adaptive(
        value: state != null,
        // inactiveThumbColor: Colors.grey,
        activeTrackColor: context.theme.colorScheme.background,
        // activeColor: ,

        onChanged: (f) {
          ref
              .watch(notificationProvider.notifier)
              .update((state) => f ? "something" : null);
          if (mounted) setState(() {});
        },
      ),
    );
  }
}
