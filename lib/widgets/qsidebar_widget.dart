import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:question_kitchen/pages/login_page.dart';

class QSideBarController extends StateNotifier<bool> {
  QSideBarController() : super(false);
  void set(bool newState) {
    EasyDebounce.debounce('--', const Duration(milliseconds: 100), () {
      state = newState;
    });
  }
}

final qSideBarControllerProvider =
    StateNotifierProvider<QSideBarController, bool>(
  (rf) {
    return QSideBarController();
  },
);

class QSideBar extends HookWidget {
  const QSideBar({
    Key? key,
    required this.right,
  }) : super(key: key);
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.lightBlue.shade600,
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 20.sp, color: Colors.white),
            child: IconTheme(
              data: IconThemeData(
                color: Colors.white,
                size: 25.sp,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MouseRegion(
                  onHover: (event) {
                    context.read(qSideBarControllerProvider.notifier).set(true);
                  },
                  onExit: (event) {
                    context
                        .read(qSideBarControllerProvider.notifier)
                        .set(false);
                  },
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        QSideBarEntry(
                          iconData: Icons.settings,
                          text: 'Settings',
                          hidden: ModalRoute.of(context)?.settings.name ==
                              '/settings',
                          onTap: () async {
                            Navigator.of(context).pushNamed('/settings');
                          },
                        ),
                        QSideBarEntry(
                          iconData: Icons.logout,
                          text: 'Logout',
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: right,
        ),
      ],
    );
  }
}
class QSideBarEntry extends HookWidget {
  const QSideBarEntry({
    Key? key,
    this.onTap,
    this.iconColor,
    required this.iconData,
    required this.text,
    this.hidden = false,
  }) : super(key: key);
  final VoidCallback? onTap;
  final IconData iconData;
  final Color? iconColor;
  final String text;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final opened = useProvider(qSideBarControllerProvider);
    return Visibility(
      visible: !hidden,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: iconColor),
            if (opened) SizedBox(width: 0.01.sw),
            if (opened) Text(text),
          ],
        ),
      ),
    );
  }
}
