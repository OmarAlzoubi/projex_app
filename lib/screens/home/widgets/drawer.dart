import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projex_app/screens/profile/widgets/profile_screen_image.dart';
import 'package:projex_app/state/auth.dart';
import 'package:projex_app/state/locale.dart';

class PDrawer extends ConsumerWidget {
  const PDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFuture = ref.watch(pCurrentUserProvider);
    final translations = ref.watch(translationProvider).translations;

    return Drawer(
      child: ListView(
        children: [
          userFuture.when(
            data: (user) {
              if (user != null) {
                return GestureDetector(
                  onTap: () {
                    context.go('/profile/${user.id}');
                  },
                  child: UserAccountsDrawerHeader(
                    currentAccountPicture: ProfileScreenImage(
                      user: user,
                      borderWidth: 2,
                    ),
                    accountName: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.map(
                            student: (std) => translations.profile.studentType,
                            instructor: (inst) =>
                                translations.profile.instructorType,
                          ),
                        ),
                        Text(user.name),
                      ],
                    ),
                    accountEmail: Text(user.email),
                  ),
                );
              } else {
                ref.refresh(pCurrentUserProvider);
                return Container();
              }
            },
            error: (err, st) {
              debugPrint(err.toString());
              debugPrint(st.toString());
              return Container();
            },
            loading: () {
              return Container();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(translations.settings.name),
            onTap: () {
              context.goNamed('settings');
            },
          ),
        ],
      ),
    );
  }
}
