import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/widgets/date_picker_field.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authTranscritorProvider);
    final user = auth.user;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text('Meu perfil'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authTranscritorProvider).signOut();
                },
              ),
            ],
          ),
          SliverFillRemaining(
            child: Builder(
              builder: (context) {
                if (user == null) {
                  return const CircularProgressIndicator.adaptive();
                }

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Display user profile image
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.white,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: user.profileImage == null
                            ? const Icon(Icons.person, size: 20)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(180),
                                child: Image.network(user.profileImage!),
                              ),
                      ),
                      // Display user information
                      Expanded(
                        child: Form(
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              TextFormField(
                                enabled: isEditing,
                                initialValue: user.firstName,
                                decoration: InputDecoration(
                                  labelText: 'Nome',
                                  prefixIcon: const Icon(Icons.person),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {},
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                enabled: isEditing,
                                initialValue: user.lastName,
                                decoration: InputDecoration(
                                  labelText: 'Sobrenome',
                                  prefixIcon: const Icon(Icons.person),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {},
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                enabled: isEditing,
                                initialValue: user.email,
                                decoration: InputDecoration(
                                  labelText: 'E-mail',
                                  prefixIcon: const Icon(Icons.email),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {},
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              if (user.dateOfBirth != null) ...[
                                DatePickerField(
                                  enable: isEditing,
                                  label: 'Data de nascimento',
                                  initialDate: DateTime.parse(
                                    user.dateOfBirth!,
                                  ),
                                  minimumDate: DateTime(
                                    DateTime.now().year - 100,
                                  ),
                                  maximumDate: DateTime(
                                    DateTime.now().year - 18,
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
        },
        shape: const CircleBorder(),
        child: Icon(
          isEditing ? Icons.close : Icons.edit,
        ),
      ),
    );
  }
}
