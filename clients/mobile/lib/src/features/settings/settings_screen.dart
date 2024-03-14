import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/common/routes/app_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            title: Text('Configurações'),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Perfil'),
                    leading: const Icon(Icons.person),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.goNamed(AppRoutes.userProfile.name);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
