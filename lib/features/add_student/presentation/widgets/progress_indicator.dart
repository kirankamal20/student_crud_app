import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SendingProgressIndicator extends StatefulWidget {
  final double progress;
  const SendingProgressIndicator({super.key, required this.progress});

  @override
  State<SendingProgressIndicator> createState() =>
      _SendingProgressIndicatorState();
}

class _SendingProgressIndicatorState extends State<SendingProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 50,
          lineWidth: 5,
          reverse: false,
          percent: widget.progress / 100,
          center: Text("${widget.progress.ceil().toString()}%",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          footer: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Uploading...",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
          ),
          circularStrokeCap: CircularStrokeCap.square,
          progressColor: Colors.amber,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
