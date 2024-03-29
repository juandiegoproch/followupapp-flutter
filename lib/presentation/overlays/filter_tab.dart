import 'package:flutter/material.dart';

class DrawerFilterChip extends StatefulWidget {
  final String title;
  final bool active;
  // final FilterState filter; // this is NOT copied as a reference!
  final Widget Function(BuildContext, void Function(void Function()))
      bodyBuilder;
  final Function() onClose;
  final Function() onBottomSheetOpen;
  final void Function(bool) onToggle;

  const DrawerFilterChip(
      {super.key,
      required this.title,
      required this.active,
      // required this.filter,
      required this.bodyBuilder,
      required this.onClose,
      required this.onBottomSheetOpen,
      required this.onToggle});
  @override
  State<StatefulWidget> createState() {
    return DrawerFilterChipState();
  }
}

class DrawerFilterChipState extends State<DrawerFilterChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FilterChip(
          label: Text(widget.title),
          selected: widget.active,
          onSelected: (v) async {
            await widget.onBottomSheetOpen();
            showModalBottomSheet(
                clipBehavior: Clip.antiAlias,
                context: context,
                builder: (c) {
                  return StatefulBuilder(
                    builder: (context, setStateL) => Column(
                      children: [
                        Row(children: [
                          Expanded(
                            child: Container(
                              color: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(widget.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          )
                        ]),
                        Row(
                          children: [
                            const Spacer(),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Switch(
                                value: widget.active,
                                onChanged: (v) {
                                  widget.onToggle(v);
                                  setStateL(() => {});
                                },
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: widget.bodyBuilder(context, setStateL),
                        ),
                      ],
                    ),
                  );
                }).then((value) => widget.onClose());
          },
        ));
  }
}
