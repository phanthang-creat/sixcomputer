import 'package:flutter/material.dart';


typedef CustomCheckBoxCallback = Function(bool);

class CustomCheckBox extends StatefulWidget {
  final CustomCheckBoxCallback? callback;
  const CustomCheckBox({super.key, this.callback});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        checked = !checked;
        if (widget.callback != null) {
          widget.callback!(checked);
        }

        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        color: Colors.transparent,
        child: Row(children: [
          !checked
              ? const Icon(Icons.check_box_outline_blank, color: Colors.grey)
              : const Icon(Icons.check_box, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('dont_show_again',
              style: TextStyle(fontSize: 16))
        ]),
      ),
    );
  }
}

class CustomCheckBox2 extends StatefulWidget {
  final Widget child;
  final bool checked;
  final Widget? validate;
  final CustomCheckBoxCallback? callback;
  const CustomCheckBox2(
      {super.key, required this.child,
      this.checked = false,
      this.validate,
      this.callback});

  @override
  State<CustomCheckBox2> createState() => _CustomCheckBoxState2();
}

class _CustomCheckBoxState2 extends State<CustomCheckBox2> {
  bool checked = false;

  @override
  void initState() {
    checked = widget.checked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            checked = !checked;
            if (widget.callback != null) {
              widget.callback!(checked);
            }

            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            color: Colors.transparent,
            child: Row(children: [
              Expanded(child: widget.child),
              const SizedBox(width: 8),
              Image.asset(
                  checked
                      ? 'assets/images/check_box_checked.png'
                      : 'assets/images/check_box.png',
                  height: 20)
            ]),
          ),
        ),
        widget.validate == null
            ? const SizedBox()
            : (checked ? const SizedBox() : widget.validate!)
      ],
    );
  }
}
