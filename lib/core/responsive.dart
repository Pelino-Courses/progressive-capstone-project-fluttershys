import 'package:flutter/material.dart';

import 'layout_breakpoints.dart';

enum ScreenSize { compact, medium, expanded }

ScreenSize screenSizeOf(double width) {
  if (width >= LayoutBreakpoints.expanded) return ScreenSize.expanded;
  if (width >= LayoutBreakpoints.medium) return ScreenSize.medium;
  return ScreenSize.compact;
}

bool useNavigationRail(double width) => width >= LayoutBreakpoints.compact;

int productGridCrossAxisCount(double width) {
  if (width >= LayoutBreakpoints.expanded) return 5;
  if (width >= LayoutBreakpoints.medium) return 4;
  if (width >= LayoutBreakpoints.compact) return 3;
  return 2;
}

double productGridChildAspectRatio(double width) {
  if (width >= LayoutBreakpoints.expanded) return 0.62;
  if (width >= LayoutBreakpoints.medium) return 0.64;
  return 0.66;
}

double productGridMaxExtent(double width) {
  if (width >= LayoutBreakpoints.expanded) return 260;
  if (width >= LayoutBreakpoints.medium) return 280;
  return 320;
}

Widget constrainContent(Widget child, {double? maxWidth}) {
  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? LayoutBreakpoints.maxContentWidth),
      child: child,
    ),
  );
}
