import 'package:flutter/material.dart';
import 'package:transcritor/src/common/models/transcription.dart';

class TranscriptItem extends StatelessWidget {
  const TranscriptItem({
    super.key,
    required this.transcription,
    required this.createdAt,
    required this.onTap,
  });

  final Transcription transcription;
  final String createdAt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        tileColor: Colors.transparent,
        onTap: onTap,
        title: Text(
          transcription.multimedia!.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          transcription.text.length > 30
              ? '${transcription.text.substring(0, 30)}...'
              : transcription.text,
        ),
        trailing: Text(
          createdAt,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        leading: const Icon(Icons.lyrics),
      ),
    );
  }
}