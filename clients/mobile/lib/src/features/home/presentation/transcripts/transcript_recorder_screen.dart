import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record/record.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/tabs/realtime_recorder.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/tabs/upload_recorder.dart';

class TranscriptRecorderScreen extends StatefulWidget {
  const TranscriptRecorderScreen({super.key});

  @override
  State<TranscriptRecorderScreen> createState() =>
      _TranscriptRecorderScreenState();
}

class _TranscriptRecorderScreenState extends State<TranscriptRecorderScreen> {
  int _currentIndex = 0;
  bool _hasPermission = false;
  late PageController _pageController;
  late AudioRecorder _recorder;

  Future<void> handlePermission() async {
    final hasPermission = await _recorder.hasPermission();

    setState(() {
      _hasPermission = hasPermission;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _recorder = AudioRecorder();
    handlePermission();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Colors.grey[800]!,
                MyColors.black87,
              ],
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisAlignment: _hasPermission
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              if (_hasPermission) ...[
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          iconSize: 50,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            }
                          },
                        ),
                      ),
                    ),
                    const Text(
                      'Gravar áudio',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                Container(
                  width: 200,
                  height: 50,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _currentIndex == 0
                                    ? MyColors.green
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Normal',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _currentIndex == 1
                                    ? MyColors.green
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Tempo real',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: [
                      UploadRecorder(recorder: _recorder),
                      RealtimeRecorder(recorder: _recorder),
                    ],
                  ),
                ),
              ] else ...[
                const Text(
                  'Sem permissão para gravar áudio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handlePermission,
                  child: const Text('Conceder permissão'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
