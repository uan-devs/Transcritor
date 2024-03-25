import 'package:flutter/material.dart';
import 'package:record/record.dart';

class RealtimeRecorder extends StatefulWidget {
  const RealtimeRecorder({super.key, required this.recorder});

  final AudioRecorder recorder;

  @override
  State<RealtimeRecorder> createState() => _RealtimeRecorderState();
}

class _RealtimeRecorderState extends State<RealtimeRecorder> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Realtime Recorder'),
    );
  }
}
