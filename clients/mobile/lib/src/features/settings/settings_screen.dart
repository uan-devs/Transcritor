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
          SliverAppBar(
            stretch: true,
            pinned: true,
            floating: true,
            snap: true,
            elevation: 0,
            stretchTriggerOffset: 200.0,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              centerTitle: false,
              title: Text(
                'Configurações',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
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
                      context.pushNamed(AppRoutes.userProfile.name);
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
