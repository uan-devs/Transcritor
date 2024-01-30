import 'package:flutter/material.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';

class SignupFormStatusBar extends StatefulWidget {
  const SignupFormStatusBar(
      {super.key, required this.indexCount, required this.currentIndex});

  final int indexCount;
  final int currentIndex;

  @override
  State<SignupFormStatusBar> createState() => _SignupFormStatusBarState();
}

class _SignupFormStatusBarState extends State<SignupFormStatusBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final barWidth = size.width * 0.75;

    return SizedBox(
      width: barWidth,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      height: 8,
                      width: widget.currentIndex == 0
                          ? 0
                          : widget.currentIndex == widget.indexCount - 1
                              ? constraints.maxWidth
                              : constraints.maxWidth *
                                  (widget.currentIndex / widget.indexCount),
                      decoration: BoxDecoration(
                        color: MyColors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                widget.indexCount,
                (i) {
                  final isStepCompleted = i < widget.currentIndex;

                  return Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: isStepCompleted ? MyColors.green : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isStepCompleted ? Colors.black : MyColors.green,
                      ),
                    ),
                    child: Center(
                      child: isStepCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 14,
                            )
                          : Text(
                              '${i + 1}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
