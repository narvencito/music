// ignore_for_file: prefer_initializing_formals, use_key_in_widget_constructors, must_be_immutable, lines_longer_than_80_chars, cascade_invocations, strict_raw_type, directives_ordering, always_put_required_named_parameters_first, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:music/utils/constans.dart';

const double _movement = 18;

class AppTapBar extends StatefulWidget {
  AppTapBar({
    super.key,
    this.backGroundColor = Colors.white,
    this.selectedColor = Colors.blue,
    required this.items,
    required this.onTapChanged,
    this.initialIndex = 0,
  });
  final Color backGroundColor;
  final Color selectedColor;
  final List<ItemTapBar> items;
  final ValueChanged<int> onTapChanged;
  final int initialIndex;

  final state = AppTapBarState();

  void onChangeSelectedTab(int index) {
    state.onChangeSelectedTab(index);
  }

  @override
  State<AppTapBar> createState() => AppTapBarState();
}

class AppTapBarState extends State<AppTapBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animationCircleItemElevationIn;
  late Animation _animationCircleItemElevationOut;

  late int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    _animationCircleItemElevationIn = CurveTween(curve: const Interval(0, 0.5, curve: Curves.easeIn)).animate(_controller);
    _animationCircleItemElevationOut = CurveTween(curve: const Interval(0.5, 1, curve: Curves.easeIn)).animate(_controller);
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onChangeSelectedTab(int index) {
    widget.onTapChanged(index);
    setState(() {
      currentIndex = index;
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    var currentElevation = 0.0;

    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          currentElevation = -_movement * double.parse(_animationCircleItemElevationIn.value.toString()) +
              (_movement - kBottomNavigationBarHeight / 4) *
                  double.parse(
                    _animationCircleItemElevationOut.value.toString(),
                  );
          return DecoratedBox(
            decoration: BoxDecoration(
              color: widget.backGroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(widget.items.length, (index) {
                final child = widget.items[index];
                child.isSelected = index == currentIndex;
                if (index == currentIndex) {
                  return Transform.translate(
                    offset: Offset(0, currentElevation),
                    child: child,
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      onChangeSelectedTab(index);
                    },
                    child: child,
                  );
                }
              }),
            ),
          );
        },
      ),
    );
  }
}

class ItemTapBar extends StatefulWidget {
  ItemTapBar({
    bool isSelected = false,
    required IconData iconData,
    required String label,
    Color selectedColor = ConstantsApp.primaryColor,
  }) {
    this.isSelected = isSelected;
    this.iconData = iconData;
    this.label = label;
    this.selectedColor = selectedColor;
  }
  bool isSelected = false;
  late IconData iconData;
  String label = '';
  Color selectedColor = ConstantsApp.primaryColor;

  @override
  State<ItemTapBar> createState() => _ItemTapBarState();
}

class _ItemTapBarState extends State<ItemTapBar> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: widget.isSelected ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceEvenly,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, -4),
                      ),
                    ]
                  : [],
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.isSelected ? Colors.white : Colors.transparent,
                width: widget.isSelected ? 4.0 : 0.0,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(
                left: 4,
                top: 4,
                right: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: CircleAvatar(
                radius: widget.isSelected ? 16.0 : 15.0,
                backgroundColor: widget.isSelected ? widget.selectedColor : Colors.white,
                child: Icon(
                  widget.iconData,
                  color: widget.isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
          Text(
            widget.label,
            style: TextStyle(
              color: widget.isSelected ? widget.selectedColor : Colors.grey,
              fontSize: widget.isSelected ? 13 : 12,
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
              // fontFamily: widget.isSelected ? ConstantsApp.QSBold : ConstantsApp.QSMedium,
            ),
          ),
        ],
      ),
    );
  }
}
