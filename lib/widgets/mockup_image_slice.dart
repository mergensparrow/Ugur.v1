import 'package:flutter/material.dart';

/// Displays a photo region from one of the approved full-screen mock-ups.
///
/// The supplied reference JPEGs contain the exact clean photography used by
/// the approved design. Keeping the source files intact and slicing them at
/// render time avoids the blurred, caption-baked legacy city images.
class MockupImageSlice extends StatelessWidget {
  const MockupImageSlice({
    super.key,
    required this.asset,
    required this.sourceSize,
    required this.sourceRect,
  });

  final String asset;
  final Size sourceSize;
  final Rect sourceRect;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.fill,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: sourceRect.width,
          height: sourceRect.height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: -sourceRect.left,
                top: -sourceRect.top,
                width: sourceSize.width,
                height: sourceSize.height,
                child: Image.asset(
                  asset,
                  width: sourceSize.width,
                  height: sourceSize.height,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  excludeFromSemantics: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
