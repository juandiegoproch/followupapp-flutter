import 'package:flutter/material.dart';

class LongPressButton extends StatefulWidget
{
  final Function()? onLongPress;
  final Function()? onLongPressUp;
  final Widget child;

  const LongPressButton({super.key,this.onLongPress, this.onLongPressUp, required this.child});

  @override
  State<StatefulWidget> createState() {
    return LongPressButtonState();
  }
}

class LongPressButtonState extends State<LongPressButton>
{
  bool isHeldDown = false;
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
          child: Container(
            padding: isHeldDown?const EdgeInsets.all(4):const EdgeInsets.all(7),
              decoration:
                  BoxDecoration(color: Colors.green, border: isHeldDown?Border.all(width: 3, color: Colors.redAccent):null, shape: BoxShape.circle),
              child: widget.child),
          onLongPress: () {
            setState(() => isHeldDown = true);
            widget.onLongPress?.call();
          },
          onLongPressUp: () {
            setState(() => isHeldDown = false);
            widget.onLongPressUp?.call();
          },
        );
  }
}