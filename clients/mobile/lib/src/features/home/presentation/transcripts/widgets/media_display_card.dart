import 'package:flutter/material.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';

class MediaDisplayCard extends StatelessWidget {
  const MediaDisplayCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 40),
        width: double.infinity,
        height: 380,
        decoration: BoxDecoration(
          color: MyColors.grey600,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(
            Icons.music_note,
            size: 150,
            color: MyColors.green,
          ),
        ));
  }
}