import 'package:material_ui/material_ui.dart';

const _sideMargin = 20.0;
const _bottomMargin = 24.0;

EdgeInsets pageInsets(BuildContext context, {double top = 0, double extraBottom = 0}) =>
    EdgeInsets.fromLTRB(_sideMargin, top, _sideMargin, MediaQuery.paddingOf(context).bottom + _bottomMargin + extraBottom);
