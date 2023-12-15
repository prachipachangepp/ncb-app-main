import 'package:flutter/material.dart';

class NcbButtonSmall extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const NcbButtonSmall({
    //  Key? key,
    required this.onTap,
    required this.child,
  });

  @override
  State<NcbButtonSmall> createState() => _NcbButtonSmallState();
}

class _NcbButtonSmallState extends State<NcbButtonSmall> {
  //: super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).colorScheme.primary,
        size: Theme.of(context).textTheme.bodyText2?.fontSize,
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: widget.child,
      ),
    );
  }
}
