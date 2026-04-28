import 'package:flutter/animation.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// Represents the ColorSets from the AlignUI Design System.
enum GtColors {
  // ---------------------------------------------------------------------------
  // PRIMITIVE ColorSets
  // ---------------------------------------------------------------------------
  white(ColorSet(0xFFFFFFFF)),
  black(ColorSet(0xFF000000)),
  transparent(ColorSet(0x00000000)),

  // ---------------------------------------------------------------------------
  // NEUTRAL / TEXT
  // ---------------------------------------------------------------------------
  neutral950(ColorSet(0xFF111111, 0xFFFFFFFF)),
  neutral800(ColorSet(0xFF262626, 0xFFEBEBEB)),
  neutral700(ColorSet(0xFF333333, 0xFFEBEBEB)),
  neutral600(ColorSet(0xFF5C5C5C, 0xFFA3A3A3)),
  neutral500(ColorSet(0xFF7B7B7B, 0xFF7B7B7B)),
  neutral400(ColorSet(0xFFA3A3A3, 0xFF7B7B7B)),
  neutral300(ColorSet(0xFFD1D1D1, 0xFF5C5C5C)),
  neutral200(ColorSet(0xFFEBEBEB, 0xFF333333)),
  neutral100(ColorSet(0xFFF5F5F5, 0x2999A0AE)),
  neutral50(ColorSet(0xFFF7F7F7, 0xFF262626)),
  neutral25(ColorSet(0xFFF8F8F8, 0xFF272727)),
  neutral0(ColorSet(0xFFFFFFFF, 0xFF111111)),

  // ---------------------------------------------------------------------------
  // NEUTRAL / GRAY
  // ---------------------------------------------------------------------------
  neutralGray950(ColorSet(0xFF171717)),
  neutralGray900(ColorSet(0xFF1C1C1C)),
  neutralGray800(ColorSet(0xFF262626)),
  neutralGray700(ColorSet(0xFF333333)),
  neutralGray600(ColorSet(0xFF5C5C5C)),
  neutralGray500(ColorSet(0xFF7B7B7B)),
  neutralGray400(ColorSet(0xFFA3A3A3)),
  neutralGray300(ColorSet(0xFFD1D1D1)),
  neutralGray200(ColorSet(0xFFEBEBEB)),
  neutralGray100(ColorSet(0xFFF5F5F5)),
  neutralGray50(ColorSet(0xFFF7F7F7)),
  neutralWarm50(ColorSet(0xFFF7F5F1, 0xFF111111)),
  neutralGray0(ColorSet(0xFFFFFFFF)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - BLUE
  // ---------------------------------------------------------------------------
  blue950(ColorSet(0xFF122368)),
  blue900(ColorSet(0xFF182F8B)),
  blue800(ColorSet(0xFF1F3BAD)),
  blue700(ColorSet(0xFF2547D0)),
  blue600(ColorSet(0xFF3559E9)),
  blue500(ColorSet(0xFF335CFF)),
  blue400(ColorSet(0xFF6895FF)),
  blue300(ColorSet(0xFF97BAFF)),
  blue200(ColorSet(0xFFC0D5FF)),
  blue100(ColorSet(0xFFD5E2FF)),
  blue50(ColorSet(0xFFEBF1FF)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - ORANGE
  // ---------------------------------------------------------------------------
  orange950(ColorSet(0xFF71330A)),
  orange900(ColorSet(0xFF96440D)),
  orange800(ColorSet(0xFFB75310)),
  orange700(ColorSet(0xFFCE5E12)),
  orange600(ColorSet(0xFFE16614)),
  orange500(ColorSet(0xFFFA7319)),
  orange400(ColorSet(0xFFFFA468)),
  orange300(ColorSet(0xFFFFC197)),
  orange200(ColorSet(0xFFFFD9C0)),
  orange100(ColorSet(0xFFFFE6D5)),
  orange50(ColorSet(0xFFFFF3EB)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - RED
  // ---------------------------------------------------------------------------
  red950(ColorSet(0xFF681219)),
  red900(ColorSet(0xFF8B1822)),
  red800(ColorSet(0xFFAD1F2B)),
  red700(ColorSet(0xFFD02533)),
  red600(ColorSet(0xFFE93544)),
  red500(ColorSet(0xFFFB3748)),
  red400(ColorSet(0xFFFF6B75)),
  red300(ColorSet(0xFFFF97A0)),
  red200(ColorSet(0xFFFFC0C5)),
  red100(ColorSet(0xFFFFD5D8)),
  red50(ColorSet(0xFFFFEBEC)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - GREEN
  // ---------------------------------------------------------------------------
  green950(ColorSet(0xFF0B4627)),
  green900(ColorSet(0xFF16643B)),
  green800(ColorSet(0xFF1A7544)),
  green700(ColorSet(0xFF178C4E)),
  green600(ColorSet(0xFF1DAF61)),
  green500(ColorSet(0xFF1FC16B)),
  green400(ColorSet(0xFF3EE089)),
  green300(ColorSet(0xFF84EBB4)),
  green200(ColorSet(0xFFC2F5DA)),
  green100(ColorSet(0xFFD0FBE9)),
  green50(ColorSet(0xFFE0FAEC)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - YELLOW
  // ---------------------------------------------------------------------------
  yellow950(ColorSet(0xFF624C18)),
  yellow900(ColorSet(0xFF86661D)),
  yellow800(ColorSet(0xFFA78025)),
  yellow700(ColorSet(0xFFC99A2C)),
  yellow600(ColorSet(0xFFE6A819)),
  yellow500(ColorSet(0xFFF6B51E)),
  yellow400(ColorSet(0xFFFFD268)),
  yellow300(ColorSet(0xFFFFE097)),
  yellow200(ColorSet(0xFFFFECC0)),
  yellow100(ColorSet(0xFFFFEFCC)),
  yellow50(ColorSet(0xFFFFFAEB)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - PURPLE
  // ---------------------------------------------------------------------------
  purple950(ColorSet(0xFF351A75)),
  purple900(ColorSet(0xFF3D1D86)),
  purple800(ColorSet(0xFF4C25A7)),
  purple700(ColorSet(0xFF5B2CC9)),
  purple600(ColorSet(0xFF693EE0)),
  purple500(ColorSet(0xFF7D52F4)),
  purple400(ColorSet(0xFF8C71F6)),
  purple300(ColorSet(0xFFA897FF)),
  purple200(ColorSet(0xFFCAC0FF)),
  purple100(ColorSet(0xFFDCD5FF)),
  purple50(ColorSet(0xFFEFEBFF)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - SKY
  // ---------------------------------------------------------------------------
  sky950(ColorSet(0xFF124B68)),
  sky900(ColorSet(0xFF18658B)),
  sky800(ColorSet(0xFF1F7EAD)),
  sky700(ColorSet(0xFF2597D0)),
  sky600(ColorSet(0xFF35ADE9)),
  sky500(ColorSet(0xFF47C2FF)),
  sky400(ColorSet(0xFF68CDFF)),
  sky300(ColorSet(0xFF97DCFF)),
  sky200(ColorSet(0xFFC0EAFF)),
  sky100(ColorSet(0xFFD5F1FF)),
  sky50(ColorSet(0xFFEBF8FF)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - PINK
  // ---------------------------------------------------------------------------
  pink950(ColorSet(0xFF68123D)),
  pink900(ColorSet(0xFF8B1852)),
  pink800(ColorSet(0xFFAD1F66)),
  pink700(ColorSet(0xFFD0257A)),
  pink600(ColorSet(0xFFE9358F)),
  pink500(ColorSet(0xFFFB4BA3)),
  pink400(ColorSet(0xFFFF6BB3)),
  pink300(ColorSet(0xFFFF97CB)),
  pink200(ColorSet(0xFFFFC0DF)),
  pink100(ColorSet(0xFFFFD5EA)),
  pink50(ColorSet(0xFFFFEBF4)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - TEAL
  // ---------------------------------------------------------------------------
  teal950(ColorSet(0xFF0B463E)),
  teal900(ColorSet(0xFF006255)),
  teal800(ColorSet(0xFF1A7569)),
  teal700(ColorSet(0xFF178C7D)),
  teal600(ColorSet(0xFF1DAF9C)),
  teal500(ColorSet(0xFF22D3BB)),
  teal400(ColorSet(0xFF3FDEC9)),
  teal300(ColorSet(0xFF84EBDD)),
  teal200(ColorSet(0xFFC2F5EE)),
  teal100(ColorSet(0xFFD0FBF5)),
  teal50(ColorSet(0xFFE4FBF8)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - TEAL BLUE
  // ---------------------------------------------------------------------------
  // tealBlue950(ColorSet(0xFF0C3B48)),
  // tealBlue800(ColorSet(0xFF0C3B48)),
  tealBlue800(ColorSet(0xFF0C3B48)),
  tealBlue700(ColorSet(0xFF2787A1)),
  tealBlue600(ColorSet(0xFF01CBEA)),

  // ---------------------------------------------------------------------------
  // VIBRANTS - MAROON
  // ---------------------------------------------------------------------------
  maroon800(ColorSet(0xFF6F0F11)),
  maroon700(ColorSet(0xFF9C191C)),
  maroon600(ColorSet(0xFFCB0828)),

  // ---------------------------------------------------------------------------
  // ALPHA ColorSetS
  // (Hex prefixes: 24% = 3D, 16% = 29, 10% = 1A)
  // ---------------------------------------------------------------------------
  blueAlpha24(ColorSet(0x3D476CFF)),
  blueAlpha16(ColorSet(0x29476CFF)),
  blueAlpha10(ColorSet(0x1A476CFF)),

  orangeAlpha24(ColorSet(0x3DFA7319)),
  orangeAlpha16(ColorSet(0x29FA7319)),
  orangeAlpha10(ColorSet(0x1AFA7319)),

  redAlpha24(ColorSet(0x3DFB3748)),
  redAlpha16(ColorSet(0x29FB3748)),
  redAlpha10(ColorSet(0x1AFB3748)),

  greenAlpha24(ColorSet(0x3D1FC16B)),
  greenAlpha16(ColorSet(0x291FC16B)),
  greenAlpha10(ColorSet(0x1A1FC16B)),

  yellowAlpha24(ColorSet(0x3DFBC64B)),
  yellowAlpha16(ColorSet(0x29FBC64B)),
  yellowAlpha10(ColorSet(0x1AFBC64B)),

  skyAlpha24(ColorSet(0x3D47C2FF)),
  skyAlpha16(ColorSet(0x2947C2FF)),
  skyAlpha10(ColorSet(0x1A47C2FF)),

  purpleAlpha24(ColorSet(0x3D7B4DEF)),
  purpleAlpha16(ColorSet(0x297B4DEF)),
  purpleAlpha10(ColorSet(0x1A7B4DEF)),

  pinkAlpha24(ColorSet(0x3DFB4BA3)),
  pinkAlpha16(ColorSet(0x29FB4BA3)),
  pinkAlpha10(ColorSet(0x1AFB4BA3)),

  tealAlpha24(ColorSet(0x3D22D3BB)),
  tealAlpha16(ColorSet(0x2922D3BB)),
  tealAlpha10(ColorSet(0x1A22D3BB)),

  tealBlueAlpha24(ColorSet(0x3D01A4BD)),
  tealBlueAlpha16(ColorSet(0x2901A4BD)),
  tealBlueAlpha10(ColorSet(0x1A01A4BD)),

  whiteAlpha24(ColorSet(0x3DFFFFFF)),
  whiteAlpha16(ColorSet(0x29FFFFFF)),
  whiteAlpha10(ColorSet(0x1AFFFFFF)),

  neutralAlpha24(ColorSet(0x3DFFFFFF)),
  neutralAlpha16(ColorSet(0x29FFFFFF)),

  blackAlpha24(ColorSet(0x3D171717)),
  blackAlpha16(ColorSet(0x29171717)),
  blackAlpha10(ColorSet(0x1A171717)),

  maroonAlpha24(ColorSet(0x3DCB0828)),
  maroonAlpha16(ColorSet(0x29CB0828)),
  maroonAlpha10(ColorSet(0x1ACB0828)),

  darkGreen(ColorSet(0xFF004045)),
  lemon(ColorSet(0xFF26E36B));

  final ColorSet _color;

  const GtColors(this._color);

  Color get value => _color;
  Color get dark => _color.dark;
  Color forTheme(bool inDarkMode) => _color.forTheme(inDarkMode);
}
