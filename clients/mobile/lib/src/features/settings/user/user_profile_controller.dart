import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transcritor/src/common/models/user.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';

final userProfileControllerProvider = Provider<UserProfileController>(
  (ref) {
    final auth = ref.watch(authTranscritorProvider);

    return UserProfileController(
      auth: auth,
    );
  },
);

class UserProfileController {
  final TranscritorAuth auth;

  UserProfileController({required this.auth});

  File? image;
  User? get user => auth.user;

  Future<void> updateProfile({
    required BuildContext context,
    required String? firstName,
    required String? lastName,
    required String? birthDate,
}) async {
    final response = await auth.editUser(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      image: image,
    );

    response.fold(
      (error) {
        image = null;
        if (context.mounted) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: const Text('An error occur'),
                content: Text(error.toString()),
              );
            },
          );
        }
      },
      (user) => null,
    );
  }

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final imageSource = await handleImageSource(context);

    if (imageSource == null) return;

    XFile? imageFile = await picker.pickImage(
        source: imageSource,
        maxWidth: 600);

    if (imageFile == null) return;

    image = File(imageFile.path);
  }

  Future<ImageSource?> handleImageSource(BuildContext context) async {
    return await showAdaptiveActionSheet<ImageSource>(
      context: context,
      title: const Text('Selecione a fonte da imagem'),
      actions: [
        BottomSheetAction(
          title: const Text('Câmera'),
          onPressed: (context) {
            context.pop(ImageSource.camera);
          },
        ),
        BottomSheetAction(
          title: const Text('Galeria'),
          onPressed: (context) {
            context.pop(ImageSource.gallery);
          },
        ),
      ],
      cancelAction: CancelAction(
        title: const Text(
          'Cancelar',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
