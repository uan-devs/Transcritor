import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/models/user.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/common/widgets/date_picker_field.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';
import 'package:transcritor/src/features/settings/user/user_profile_controller.dart';
import 'package:validatorless/validatorless.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  bool isEditing = false;
  bool isLoading = false;

  bool get isFormValid => _formKey.currentState?.validate() ?? false;

  void resetForm(User? user) {
    _formKey.currentState?.reset();

    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';
    _dateOfBirthController.text = user?.dateOfBirth ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final userController = ref.watch(userProfileControllerProvider);
    final user = userController.user;

    if (_firstNameController.text.isEmpty) {
      _firstNameController.text = user?.firstName ?? '';
    }
    if (_lastNameController.text.isEmpty) {
      _lastNameController.text = user?.lastName ?? '';
    }
    if (_dateOfBirthController.text.isEmpty) {
      _dateOfBirthController.text = user?.dateOfBirth ?? '';
    }

    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          await ref.read(authTranscritorProvider).getCurrentUserInfo();
          setState(() {
            isLoading = false;
          });
        },
        child: CustomScrollView(
          physics: isEditing
              ? const ClampingScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
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
              hasScrollBody: false,
              child: Builder(
                builder: (context) {
                  if (user == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Visibility(
                      visible: !isLoading,
                      replacement: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: isEditing
                                ? () async {
                                    await ref
                                        .read(userProfileControllerProvider)
                                        .pickImage(context);
                                  }
                                : null,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color:
                                      isEditing ? MyColors.green : Colors.grey,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: userController.image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        userController.image!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : user.profileImage != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                            user.profileImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 100,
                                        ),
                            ),
                          ),
                          // Display user information
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  ListTile(
                                    leading: const Icon(Icons.email),
                                    title: Text(
                                      user.email,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Conta criada em ${user.createdAt.substring(0, 10)}',
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  TextFormField(
                                    controller: _firstNameController,
                                    enabled: isEditing,
                                    onTapOutside: (_) =>
                                        FocusScope.of(context).unfocus(),
                                    onFieldSubmitted: (_) => setState(() {}),
                                    textInputAction: TextInputAction.done,
                                    validator: Validatorless.multiple([
                                      Validatorless.required(
                                          'Campo obrigatório'),
                                      Validatorless.min(3, 'Nome muito curto'),
                                    ]),
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
                                  const SizedBox(height: 25),
                                  TextFormField(
                                    controller: _lastNameController,
                                    enabled: isEditing,
                                    onTapOutside: (_) =>
                                        FocusScope.of(context).unfocus(),
                                    onFieldSubmitted: (_) => setState(() {}),
                                    textInputAction: TextInputAction.done,
                                    validator: Validatorless.multiple([
                                      Validatorless.required(
                                          'Campo obrigatório'),
                                      Validatorless.min(
                                          3, 'Sobrenome muito curto'),
                                    ]),
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
                                  const SizedBox(height: 25),
                                  if (user.dateOfBirth != null) ...[
                                    DatePickerField(
                                      enable:
                                          isEditing && user.dateOfBirth == null,
                                      label: 'Data de nascimento',
                                      initialDate: DateTime.parse(
                                        user.dateOfBirth!,
                                      ),
                                    )
                                  ],
                                  if (user.dateOfBirth == null &&
                                      isEditing) ...[
                                    DatePickerField(
                                      enable: isEditing,
                                      label: 'Data de nascimento',
                                      onChanged: (value) {
                                        _dateOfBirthController.text =
                                            value.toIso8601String();
                                      },
                                    )
                                  ],
                                  const SizedBox(height: 40),
                                  ElevatedButton(
                                    onPressed: isEditing && isFormValid
                                        ? () async {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            await ref
                                                .read(
                                                    userProfileControllerProvider)
                                                .updateProfile(
                                                  context: context,
                                                  firstName:
                                                      _firstNameController.text,
                                                  lastName:
                                                      _lastNameController.text,
                                                  birthDate:
                                                      _dateOfBirthController
                                                          .text,
                                                );

                                            setState(() {
                                              isLoading = false;
                                              isEditing = false;
                                            });
                                          }
                                        : null,
                                    child: const Text('Salvar'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading
            ? null
            : () {
                resetForm(user);
                setState(() {
                  isEditing = !isEditing;
                  debugPrint('isEditing: $isEditing');
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
