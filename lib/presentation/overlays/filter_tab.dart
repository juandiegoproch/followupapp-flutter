import 'package:flutter/material.dart';
/*
class BottomDrawerFilter extends StatefulWidget {
  final Widget toggle, title, body;

  const BottomDrawerFilter({
    required this.toggle,
    required this.title,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BottomDrawerFilterState();
  }
}

class BottomDrawerFilterState extends State<BottomDrawerFilter> {
  BottomDrawerFilterState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          widget.title,
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: widget.toggle,
              ),
            ],
          ),
          widget.body,
        ],
      ),
    );
  }
}
*/

class BottomDrawerFilter extends StatelessWidget {
  final Widget toggle, title, body;
  const BottomDrawerFilter({
    required this.toggle,
    required this.title,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(children: [Expanded( child: title)]),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: toggle,
              ),
            ],
          ),
          body,
        ],
      ),
    );
  }
}
