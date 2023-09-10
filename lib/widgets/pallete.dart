import 'package:flutter/material.dart';
import 'package:optimal_routing/consts/styles.dart';

class Palette extends StatefulWidget {
  const Palette({Key? key}) : super(key: key);

  @override
  State<Palette> createState() => _PaletteState();
}

class _PaletteState extends State<Palette> {
  bool active = false;

  List<Widget> items = [
    _ColorItem(theme: Style.theme1),
    _ColorItem(theme: Style.theme2),
    _ColorItem(theme: Style.theme3),
  ];

  double get length => Style.block * (items.length * 2.2);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Style.block * 1.5,
      width: length,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Style.block * 1.5 / 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(Style.block * 1.5 / 2)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: Style.block * 1.5,
                  width: active ? length : Style.block * 1.5,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: length,
                      padding: EdgeInsets.only(right: Style.block * 1.8, left: Style.block * 0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: items,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: Style.block * 1.5,
              width: Style.block * 1.5,
              child: ElevatedButton(
                onPressed: () => setState(() => active = !active),
                style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: EdgeInsets.zero,
                    fixedSize: Size(Style.block * 1.1, Style.block * 1.1),
                    elevation: 0),
                child: Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                  size: Style.block * 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorItem extends StatefulWidget {
  final ThemeData theme;

  const _ColorItem({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  State<_ColorItem> createState() => _ColorItemState();
}

class _ColorItemState extends State<_ColorItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => (Style.changeTheme ?? (_) {})(widget.theme),
      child: Container(
        height: Style.block * 1.1,
        width: Style.block * 1.1,
        decoration: BoxDecoration(
          color: widget.theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            height: Style.block * 0.5,
            width: Style.block * 0.5,
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
