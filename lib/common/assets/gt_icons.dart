import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/common/common.dart';

typedef GtIconData = IconData;

/// A centralized class for the application's custom icon font.
///
/// Ensure the `GtIconFont.ttf` file is added to your `assets/fonts/` directory
/// and declared in your `pubspec.yaml` under the family name `GtIconFont`.
class GtIcons {
  /// Private constructor to prevent instantiation of this utility class.
  GtIcons._();

  static const _f = GtFonts.icon;
  static const _p = 'gt_mobile_ui';

  /// ---------------------------------------------------------------------------
  /// NAVIGATION & CORE ICONS (Solid / High-Emphasis)
  /// ---------------------------------------------------------------------------
  static const userSolid = IconData(0xf110, fontFamily: _f, fontPackage: _p);
  static const spark = IconData(0xf112, fontFamily: _f, fontPackage: _p);
  static const shareSolid = IconData(0xf113, fontFamily: _f, fontPackage: _p);
  static const sendSolid = IconData(0xf114, fontFamily: _f, fontPackage: _p);
  static const search = IconData(0xf115, fontFamily: _f, fontPackage: _p);
  static const scan = IconData(0xf116, fontFamily: _f, fontPackage: _p);
  static const userScan = IconData(0xf127, fontFamily: _f, fontPackage: _p);
  static const refreshSolid = IconData(0xf117, fontFamily: _f, fontPackage: _p);
  static const qr = IconData(0xf118, fontFamily: _f, fontPackage: _p);
  static const qrMain = IconData(0xf119, fontFamily: _f, fontPackage: _p);
  static const notificationSolid = IconData(
    0xf11a,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const more = IconData(0xf11b, fontFamily: _f, fontPackage: _p);
  static const moreHorizontal = IconData(
    0xf12a,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const info = IconData(0xf11c, fontFamily: _f, fontPackage: _p);
  static const help = IconData(0xf11d, fontFamily: _f, fontPackage: _p);
  static const gem = IconData(0xf11e, fontFamily: _f, fontPackage: _p);
  static const filter = IconData(0xf16a, fontFamily: _f, fontPackage: _p);
  static const filterSolid = IconData(0xf11f, fontFamily: _f, fontPackage: _p);

  static const chevronUp = IconData(0xf120, fontFamily: _f, fontPackage: _p);
  static const chevronRight = IconData(0xf121, fontFamily: _f, fontPackage: _p);
  static const chevronLeft = IconData(0xf122, fontFamily: _f, fontPackage: _p);
  static const chevronDown = IconData(0xf123, fontFamily: _f, fontPackage: _p);

  static const checkSolid = IconData(0xf124, fontFamily: _f, fontPackage: _p);
  static const cautionSolid = IconData(0xf109, fontFamily: _f, fontPackage: _p);
  static const cancel = IconData(0xf126, fontFamily: _f, fontPackage: _p);
  static const add = IconData(0xf127, fontFamily: _f, fontPackage: _p);

  /// ---------------------------------------------------------------------------
  /// CREDIT CARD ICONS
  /// ---------------------------------------------------------------------------
  static const wechat = IconData(0xf102, fontFamily: _f, fontPackage: _p);
  static const visaLight = IconData(0xf103, fontFamily: _f, fontPackage: _p);
  static const visa = IconData(0xf104, fontFamily: _f, fontPackage: _p);
  static const unionpay = IconData(0xf105, fontFamily: _f, fontPackage: _p);
  static const shoppay = IconData(0xf107, fontFamily: _f, fontPackage: _p);
  static const paypal = IconData(0xf108, fontFamily: _f, fontPackage: _p);
  static const paypalAlt = IconData(0xf10A, fontFamily: _f, fontPackage: _p);
  static const mastercard = IconData(0xf10B, fontFamily: _f, fontPackage: _p);
  static const mastercardLight = IconData(
    0xf10C,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const masterCardDuoTone = IconData(
    0xf10D,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const jcbGrey = IconData(0xf10F, fontFamily: _f, fontPackage: _p);
  static const gpay = IconData(0xf111, fontFamily: _f, fontPackage: _p);
  static const eftpos = IconData(0xf12D, fontFamily: _f, fontPackage: _p);
  static const discover = IconData(0xf12E, fontFamily: _f, fontPackage: _p);
  static const dinersclub = IconData(0xf139, fontFamily: _f, fontPackage: _p);
  static const cvv = IconData(0xf13A, fontFamily: _f, fontPackage: _p);
  static const cardLight = IconData(0xf13E, fontFamily: _f, fontPackage: _p);
  static const cardDark = IconData(0xf13F, fontFamily: _f, fontPackage: _p);
  static const bitcoin = IconData(0xf140, fontFamily: _f, fontPackage: _p);
  static const bankCard = IconData(0xf141, fontFamily: _f, fontPackage: _p);
  static const applepay = IconData(0xf142, fontFamily: _f, fontPackage: _p);
  static const amex = IconData(0xf143, fontFamily: _f, fontPackage: _p);
  static const amazon = IconData(0xf144, fontFamily: _f, fontPackage: _p);
  static const alipay = IconData(0xf145, fontFamily: _f, fontPackage: _p);

  /// ---------------------------------------------------------------------------
  /// DEFAULT ICONS (Outline / Standard)
  /// ---------------------------------------------------------------------------
  static const scribble = IconData(0xf000, fontFamily: _f, fontPackage: _p);
  static const flame = IconData(0xf001, fontFamily: _f, fontPackage: _p);
  static const scissors = IconData(0xf002, fontFamily: _f, fontPackage: _p);
  static const flag = IconData(0xf003, fontFamily: _f, fontPackage: _p);
  static const scissorsCoupon = IconData(
    0xf004,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const fingerprint = IconData(0xf005, fontFamily: _f, fontPackage: _p);
  static const scale = IconData(0xf006, fontFamily: _f, fontPackage: _p);
  static const filters = IconData(0xf007, fontFamily: _f, fontPackage: _p);
  static const satellite = IconData(0xf008, fontFamily: _f, fontPackage: _p);
  static const funnel = IconData(0xf009, fontFamily: _f, fontPackage: _p);
  static const rulerPen = IconData(0xf00a, fontFamily: _f, fontPackage: _p);
  static const film = IconData(0xf00b, fontFamily: _f, fontPackage: _p);
  static const rotation360 = IconData(0xf00c, fontFamily: _f, fontPackage: _p);
  static const files = IconData(0xf00d, fontFamily: _f, fontPackage: _p);
  static const rocket = IconData(0xf00e, fontFamily: _f, fontPackage: _p);
  static const file = IconData(0xf00f, fontFamily: _f, fontPackage: _p);
  static const copyFilled = IconData(0xf125, fontFamily: _f, fontPackage: _p);
  static const roadmap = IconData(0xf010, fontFamily: _f, fontPackage: _p);
  static const fileContent = IconData(0xf011, fontFamily: _f, fontPackage: _p);
  static const refresh = IconData(0xf012, fontFamily: _f, fontPackage: _p);
  static const feather = IconData(0xf013, fontFamily: _f, fontPackage: _p);
  static const receipts = IconData(0xf014, fontFamily: _f, fontPackage: _p);
  static const question = IconData(0xf016, fontFamily: _f, fontPackage: _p);
  static const faceSmile = IconData(0xf017, fontFamily: _f, fontPackage: _p);
  static const qrCode = IconData(0xf018, fontFamily: _f, fontPackage: _p);
  static const facePlus = IconData(0xf019, fontFamily: _f, fontPackage: _p);
  static const puzzlePiece = IconData(0xf01a, fontFamily: _f, fontPackage: _p);
  static const eyeOpen = IconData(0xf01b, fontFamily: _f, fontPackage: _p);
  static const progressBar = IconData(0xf01c, fontFamily: _f, fontPackage: _p);
  static const eyeClosed = IconData(0xf01d, fontFamily: _f, fontPackage: _p);
  static const print = IconData(0xf01e, fontFamily: _f, fontPackage: _p);
  static const exchange = IconData(0xf01f, fontFamily: _f, fontPackage: _p);
  static const presentationScreen = IconData(
    0xf020,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const envelope = IconData(0xf021, fontFamily: _f, fontPackage: _p);
  static const pointer = IconData(0xf022, fontFamily: _f, fontPackage: _p);
  static const envelopeOpen = IconData(0xf023, fontFamily: _f, fontPackage: _p);
  static const plus = IconData(0xf024, fontFamily: _f, fontPackage: _p);
  static const envelopCheck = IconData(0xf025, fontFamily: _f, fontPackage: _p);
  static const plug = IconData(0xf026, fontFamily: _f, fontPackage: _p);
  static const calendarEmpty = IconData(
    0xf027,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const calendarEmptyFilled = IconData(
    0xf137,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const reorder = IconData(0xf12f, fontFamily: _f, fontPackage: _p);
  static const switchOutline = IconData(
    0xf138,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const pizzaSlice = IconData(0xf028, fontFamily: _f, fontPackage: _p);
  static const editDoc = IconData(0xf029, fontFamily: _f, fontPackage: _p);
  static const pinTack = IconData(0xf02a, fontFamily: _f, fontPackage: _p);
  static const earth = IconData(0xf02b, fontFamily: _f, fontPackage: _p);
  static const phonebook = IconData(0xf02c, fontFamily: _f, fontPackage: _p);
  static const drawCompass = IconData(0xf02d, fontFamily: _f, fontPackage: _p);
  static const phone = IconData(0xf02e, fontFamily: _f, fontPackage: _p);
  static const download = IconData(0xf02f, fontFamily: _f, fontPackage: _p);
  static const phoneShake = IconData(0xf030, fontFamily: _f, fontPackage: _p);
  static const dots = IconData(0xf031, fontFamily: _f, fontPackage: _p);
  static const phoneCheck = IconData(0xf032, fontFamily: _f, fontPackage: _p);
  static const desktopArrowDown = IconData(
    0xf033,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const percentage = IconData(0xf034, fontFamily: _f, fontPackage: _p);
  static const sortDescending = IconData(
    0xf035,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const penWriting = IconData(0xf036, fontFamily: _f, fontPackage: _p);
  static const darkLight = IconData(0xf037, fontFamily: _f, fontPackage: _p);
  static const penWritingAlt = IconData(
    0xf038,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const cryptography = IconData(0xf039, fontFamily: _f, fontPackage: _p);
  static const penSparkle = IconData(0xf03a, fontFamily: _f, fontPackage: _p);
  static const crosshairs = IconData(0xf03b, fontFamily: _f, fontPackage: _p);
  static const penNib = IconData(0xf03c, fontFamily: _f, fontPackage: _p);
  static const crosshairsSlash = IconData(
    0xf03d,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const pen = IconData(0xf03e, fontFamily: _f, fontPackage: _p);
  static const pencil = IconData(0xf106, fontFamily: _f, fontPackage: _p);
  static const password = IconData(0xf040, fontFamily: _f, fontPackage: _p);
  static const passcode = IconData(0xf13c, fontFamily: _f, fontPackage: _p);
  static const copy = IconData(0xf041, fontFamily: _f, fontPackage: _p);
  static const paperclip = IconData(0xf042, fontFamily: _f, fontPackage: _p);
  static const cookie = IconData(0xf043, fontFamily: _f, fontPackage: _p);
  static const paperPlane = IconData(0xf044, fontFamily: _f, fontPackage: _p);
  static const computer = IconData(0xf045, fontFamily: _f, fontPackage: _p);
  static const paintbrush = IconData(0xf046, fontFamily: _f, fontPackage: _p);
  static const cloud = IconData(0xf047, fontFamily: _f, fontPackage: _p);
  static const orderedList = IconData(0xf048, fontFamily: _f, fontPackage: _p);
  static const clipboard = IconData(0xf049, fontFamily: _f, fontPackage: _p);
  static const office = IconData(0xf04a, fontFamily: _f, fontPackage: _p);
  static const clipboardSlash = IconData(
    0xf04b,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const notification = IconData(0xf04c, fontFamily: _f, fontPackage: _p);
  static const clipboardCheck = IconData(
    0xf04d,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const nodes = IconData(0xf04e, fontFamily: _f, fontPackage: _p);
  static const circleInfo = IconData(0xf04f, fontFamily: _f, fontPackage: _p);
  static const musicNoteSparkle = IconData(
    0xf050,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const circleHashtag = IconData(
    0xf051,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const messages = IconData(0xf052, fontFamily: _f, fontPackage: _p);
  static const circleDottedCheck = IconData(
    0xf053,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const msgWriting = IconData(0xf054, fontFamily: _f, fontPackage: _p);
  static const circleCompose = IconData(
    0xf055,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const xmark = IconData(0xf056, fontFamily: _f, fontPackage: _p);
  static const msgSmile = IconData(0xf057, fontFamily: _f, fontPackage: _p);
  static const chevronUpOutline = IconData(
    0xf058,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const x = IconData(0xf059, fontFamily: _f, fontPackage: _p);
  static const msgBubbleUser = IconData(
    0xf05a,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const chevronRightOutline = IconData(
    0xf05b,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const windowPointer = IconData(
    0xf05c,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const moneyBillCoin = IconData(
    0xf05d,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const chevronLeftOutline = IconData(
    0xf05e,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const windowExpandBottomRight = IconData(
    0xf05f,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const mobile = IconData(0xf060, fontFamily: _f, fontPackage: _p);
  static const chevronExpandY = IconData(
    0xf061,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const windowChartLine = IconData(
    0xf062,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const minus = IconData(0xf063, fontFamily: _f, fontPackage: _p);
  static const chevronDownOutline = IconData(
    0xf064,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const whatsapp = IconData(0xf065, fontFamily: _f, fontPackage: _p);
  static const microphone = IconData(0xf066, fontFamily: _f, fontPackage: _p);
  static const checkOutline = IconData(0xf067, fontFamily: _f, fontPackage: _p);
  static const watch = IconData(0xf068, fontFamily: _f, fontPackage: _p);
  static const microphoneSlash = IconData(
    0xf069,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const checkBox = IconData(0xf06a, fontFamily: _f, fontPackage: _p);
  static const wandSparkle = IconData(0xf06b, fontFamily: _f, fontPackage: _p);
  static const message = IconData(0xf06c, fontFamily: _f, fontPackage: _p);
  static const chartBarTrendUp = IconData(
    0xf06d,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const wallet = IconData(0xf06e, fontFamily: _f, fontPackage: _p);
  static const map = IconData(0xf06f, fontFamily: _f, fontPackage: _p);
  static const chair = IconData(0xf070, fontFamily: _f, fontPackage: _p);
  static const volume = IconData(0xf071, fontFamily: _f, fontPackage: _p);
  static const magnifier = IconData(0xf072, fontFamily: _f, fontPackage: _p);
  static const cautionOutline = IconData(
    0xf073,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const volumeUp = IconData(0xf074, fontFamily: _f, fontPackage: _p);
  static const magnifierFaceWorried = IconData(
    0xf075,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const cashEmpty = IconData(0xf076, fontFamily: _f, fontPackage: _p);
  static const video = IconData(0xf077, fontFamily: _f, fontPackage: _p);
  static const magicWand = IconData(0xf078, fontFamily: _f, fontPackage: _p);
  static const cartShopping = IconData(0xf079, fontFamily: _f, fontPackage: _p);
  static const vending = IconData(0xf07a, fontFamily: _f, fontPackage: _p);
  static const lock = IconData(0xf07b, fontFamily: _f, fontPackage: _p);
  static const cardCheck = IconData(0xf07c, fontFamily: _f, fontPackage: _p);
  static const vault = IconData(0xf07d, fontFamily: _f, fontPackage: _p);
  static const lockOpen = IconData(0xf07e, fontFamily: _f, fontPackage: _p);
  static const camera = IconData(0xf07f, fontFamily: _f, fontPackage: _p);
  static const users = IconData(0xf080, fontFamily: _f, fontPackage: _p);
  static const location = IconData(0xf081, fontFamily: _f, fontPackage: _p);
  static const cameraAlt = IconData(0xf082, fontFamily: _f, fontPackage: _p);
  static const user = IconData(0xf083, fontFamily: _f, fontPackage: _p);
  static const loader = IconData(0xf084, fontFamily: _f, fontPackage: _p);
  static const calendar = IconData(0xf085, fontFamily: _f, fontPackage: _p);
  static const userSearch = IconData(0xf086, fontFamily: _f, fontPackage: _p);
  static const link = IconData(0xf087, fontFamily: _f, fontPackage: _p);
  static const calendarDays = IconData(0xf088, fontFamily: _f, fontPackage: _p);
  static const userLaptop = IconData(0xf089, fontFamily: _f, fontPackage: _p);
  static const lightbulb = IconData(0xf08a, fontFamily: _f, fontPackage: _p);
  static const bullhorn = IconData(0xf08b, fontFamily: _f, fontPackage: _p);
  static const uploadOutline = IconData(
    0xf08c,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const lifeRing = IconData(0xf08d, fontFamily: _f, fontPackage: _p);
  static const bug = IconData(0xf08e, fontFamily: _f, fontPackage: _p);
  static const uploadFolder = IconData(0xf08f, fontFamily: _f, fontPackage: _p);
  static const leaf = IconData(0xf090, fontFamily: _f, fontPackage: _p);
  static const bugSlash = IconData(0xf091, fontFamily: _f, fontPackage: _p);
  static const unorderedList = IconData(
    0xf092,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const layers = IconData(0xf093, fontFamily: _f, fontPackage: _p);
  static const box = IconData(0xf094, fontFamily: _f, fontPackage: _p);
  static const unhide = IconData(0xf095, fontFamily: _f, fontPackage: _p);
  static const laptop = IconData(0xf096, fontFamily: _f, fontPackage: _p);
  static const boxArchive = IconData(0xf097, fontFamily: _f, fontPackage: _p);
  static const umbrella = IconData(0xf098, fontFamily: _f, fontPackage: _p);
  static const laptopMobile = IconData(0xf099, fontFamily: _f, fontPackage: _p);
  static const bookmarks = IconData(0xf09a, fontFamily: _f, fontPackage: _p);
  static const ufo = IconData(0xf09b, fontFamily: _f, fontPackage: _p);
  static const language = IconData(0xf09c, fontFamily: _f, fontPackage: _p);
  static const bookmark = IconData(0xf09d, fontFamily: _f, fontPackage: _p);
  static const triangleWarning = IconData(
    0xf09e,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const keyboard = IconData(0xf09f, fontFamily: _f, fontPackage: _p);
  static const bookmarkSlash = IconData(
    0xf0a0,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const trash = IconData(0xf0a1, fontFamily: _f, fontPackage: _p);
  static const key = IconData(0xf0a2, fontFamily: _f, fontPackage: _p);
  static const bookOpen = IconData(0xf0a3, fontFamily: _f, fontPackage: _p);
  static const transfer = IconData(0xf0a4, fontFamily: _f, fontPackage: _p);
  static const industry = IconData(0xf0a5, fontFamily: _f, fontPackage: _p);
  static const bookBookmark = IconData(0xf0a6, fontFamily: _f, fontPackage: _p);
  static const toggle = IconData(0xf0a7, fontFamily: _f, fontPackage: _p);
  static const inboxArrowDown = IconData(
    0xf0a8,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const bolt = IconData(0xf0a9, fontFamily: _f, fontPackage: _p);
  static const timer = IconData(0xf0aa, fontFamily: _f, fontPackage: _p);
  static const images = IconData(0xf0ab, fontFamily: _f, fontPackage: _p);
  static const boltSlash = IconData(0xf0ac, fontFamily: _f, fontPackage: _p);
  static const ticket = IconData(0xf0ad, fontFamily: _f, fontPackage: _p);
  static const image = IconData(0xf0ae, fontFamily: _f, fontPackage: _p);
  static const boltLightning = IconData(
    0xf0af,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const thumbsUp = IconData(0xf0b0, fontFamily: _f, fontPackage: _p);
  static const imageSparkle = IconData(0xf0b1, fontFamily: _f, fontPackage: _p);
  static const bicycle = IconData(0xf0b2, fontFamily: _f, fontPackage: _p);
  static const textTool = IconData(0xf0b3, fontFamily: _f, fontPackage: _p);
  static const imageMountain = IconData(
    0xf0b4,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const bell = IconData(0xf0b5, fontFamily: _f, fontPackage: _p);
  static const textHighlight = IconData(
    0xf0b6,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const imageDepth = IconData(0xf0b7, fontFamily: _f, fontPackage: _p);
  static const battery = IconData(0xf0b8, fontFamily: _f, fontPackage: _p);
  static const tasks = IconData(0xf0b9, fontFamily: _f, fontPackage: _p);
  static const house = IconData(0xf0ba, fontFamily: _f, fontPackage: _p);
  static const batteryHigh = IconData(0xf0bb, fontFamily: _f, fontPackage: _p);
  static const target = IconData(0xf0bc, fontFamily: _f, fontPackage: _p);
  static const houseAlt = IconData(0xf0bd, fontFamily: _f, fontPackage: _p);
  static const basketShopping = IconData(
    0xf0be,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const tags = IconData(0xf0bf, fontFamily: _f, fontPackage: _p);
  static const hotDrink = IconData(0xf0c0, fontFamily: _f, fontPackage: _p);
  static const ballBasket = IconData(0xf0c1, fontFamily: _f, fontPackage: _p);
  static const tag = IconData(0xf0c2, fontFamily: _f, fontPackage: _p);
  static const hide = IconData(0xf0c3, fontFamily: _f, fontPackage: _p);
  static const bagShopping = IconData(0xf0c4, fontFamily: _f, fontPackage: _p);
  static const suitcase = IconData(0xf0c5, fontFamily: _f, fontPackage: _p);
  static const heart = IconData(0xf0c6, fontFamily: _f, fontPackage: _p);
  static const badge = IconData(0xf0c7, fontFamily: _f, fontPackage: _p);
  static const subscription = IconData(0xf0c8, fontFamily: _f, fontPackage: _p);
  static const heartHand = IconData(0xf0c9, fontFamily: _f, fontPackage: _p);
  static const award = IconData(0xf0ca, fontFamily: _f, fontPackage: _p);
  static const awardFilled = IconData(0xf149, fontFamily: _f, fontPackage: _p);
  static const piggyBank = IconData(0xf147, fontFamily: _f, fontPackage: _p);
  static const piggyBankFilled = IconData(
    0xf148,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const stopwatch = IconData(0xf0cb, fontFamily: _f, fontPackage: _p);
  static const heartBreak = IconData(0xf0cc, fontFamily: _f, fontPackage: _p);
  static const awardCertificate = IconData(
    0xf0cd,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const stickerSmile = IconData(0xf0ce, fontFamily: _f, fontPackage: _p);
  static const headset = IconData(0xf0cf, fontFamily: _f, fontPackage: _p);
  static const attach = IconData(0xf0d0, fontFamily: _f, fontPackage: _p);
  static const star = IconData(0xf0d1, fontFamily: _f, fontPackage: _p);
  static const handshake = IconData(0xf0d2, fontFamily: _f, fontPackage: _p);
  static const atSign = IconData(0xf0d3, fontFamily: _f, fontPackage: _p);
  static const starSparkle = IconData(0xf0d4, fontFamily: _f, fontPackage: _p);
  static const hand = IconData(0xf0d5, fontFamily: _f, fontPackage: _p);
  static const aspectRatioSquare = IconData(
    0xf0d6,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const stackPerspective = IconData(
    0xf0d7,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const halfDottedCirclePlay = IconData(
    0xf0d8,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const art = IconData(0xf0d9, fontFamily: _f, fontPackage: _p);
  static const squarePlus = IconData(0xf0da, fontFamily: _f, fontPackage: _p);
  static const gridCirclePlus = IconData(
    0xf0db,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const rotateAnticlockwise = IconData(
    0xf0dc,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const squareMinus = IconData(0xf0dd, fontFamily: _f, fontPackage: _p);
  static const graduationCap = IconData(
    0xf0de,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const arrowDoorOut = IconData(0xf0df, fontFamily: _f, fontPackage: _p);
  static const arrowBottomRight = IconData(
    0xf0e0,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const globePointer = IconData(0xf0e1, fontFamily: _f, fontPackage: _p);
  static const arrowDoorIn = IconData(0xf0e2, fontFamily: _f, fontPackage: _p);
  static const sparkle = IconData(0xf0e3, fontFamily: _f, fontPackage: _p);
  static const gift = IconData(0xf0e4, fontFamily: _f, fontPackage: _p);
  static const android = IconData(0xf0e5, fontFamily: _f, fontPackage: _p);
  static const sliders = IconData(0xf0e6, fontFamily: _f, fontPackage: _p);
  static const gemSparkle = IconData(0xf0e7, fontFamily: _f, fontPackage: _p);
  static const anchor = IconData(0xf0e8, fontFamily: _f, fontPackage: _p);
  static const sitemap = IconData(0xf0e9, fontFamily: _f, fontPackage: _p);
  static const gear = IconData(0xf0ea, fontFamily: _f, fontPackage: _p);
  static const alignVertical = IconData(
    0xf0eb,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const signal = IconData(0xf0ec, fontFamily: _f, fontPackage: _p);
  static const gauge = IconData(0xf0ed, fontFamily: _f, fontPackage: _p);
  static const alignTop = IconData(0xf0ee, fontFamily: _f, fontPackage: _p);
  static const sideProfile = IconData(0xf0ef, fontFamily: _f, fontPackage: _p);
  static const gasPump = IconData(0xf0f0, fontFamily: _f, fontPackage: _p);
  static const alignRight = IconData(0xf0f1, fontFamily: _f, fontPackage: _p);
  static const shop = IconData(0xf0f2, fontFamily: _f, fontPackage: _p);
  static const gamingButtons = IconData(
    0xf0f3,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const alignLeft = IconData(0xf0f4, fontFamily: _f, fontPackage: _p);
  static const shieldCheck = IconData(0xf0f5, fontFamily: _f, fontPackage: _p);
  static const gamepad = IconData(0xf0f6, fontFamily: _f, fontPackage: _p);
  static const alignHorizontal = IconData(
    0xf0f7,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const share = IconData(0xf0f8, fontFamily: _f, fontPackage: _p);
  static const forklift = IconData(0xf0f9, fontFamily: _f, fontPackage: _p);
  static const alignBottom = IconData(0xf0fa, fontFamily: _f, fontPackage: _p);
  static const shareIos = IconData(0xf0fb, fontFamily: _f, fontPackage: _p);
  static const folder = IconData(0xf0fc, fontFamily: _f, fontPackage: _p);
  static const alert = IconData(0xf0fd, fontFamily: _f, fontPackage: _p);
  static const shapes = IconData(0xf0fe, fontFamily: _f, fontPackage: _p);
  static const folderOpen = IconData(0xf0ff, fontFamily: _f, fontPackage: _p);
  static const alarmClock = IconData(0xf100, fontFamily: _f, fontPackage: _p);

  /// ---------------------------------------------------------------------------
  /// BOTTOM NAVIGATION ICONS (Outline / Standard)
  /// ---------------------------------------------------------------------------
  static const home = IconData(0xf101, fontFamily: _f, fontPackage: _p);
  static const homeFilled = IconData(0xf132, fontFamily: _f, fontPackage: _p);
  static const payment = IconData(0xf133, fontFamily: _f, fontPackage: _p);
  static const paymentFilled = IconData(
    0xf134,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const product = IconData(0xf135, fontFamily: _f, fontPackage: _p);
  static const productFilled = IconData(
    0xf136,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const card = IconData(0xf131, fontFamily: _f, fontPackage: _p);
  static const cardFilled = IconData(0xf154, fontFamily: _f, fontPackage: _p);
  static const cardEdit = IconData(0xf155, fontFamily: _f, fontPackage: _p);
  static const fileFilled = IconData(0xf130, fontFamily: _f, fontPackage: _p);
  static const helpInfo = IconData(0xf10e, fontFamily: _f, fontPackage: _p);

  static const delete = IconData(0xf129, fontFamily: _f, fontPackage: _p);
  static const faceId = IconData(0xf128, fontFamily: _f, fontPackage: _p);

  static const temple = IconData(0xf12c, fontFamily: _f, fontPackage: _p);
  static const childHead = IconData(0xf146, fontFamily: _f, fontPackage: _p);
  static const verifiedUsers = IconData(
    0xf12b,
    fontFamily: _f,
    fontPackage: _p,
  );

  static const airtime = IconData(0xf14d, fontFamily: _f, fontPackage: _p);
  static const cuppedHand = IconData(0xf14c, fontFamily: _f, fontPackage: _p);
  static const eyeOutline = IconData(0xf14b, fontFamily: _f, fontPackage: _p);
  static const snowFlake = IconData(0xf14a, fontFamily: _f, fontPackage: _p);

  static const keyPadA = IconData(0xf150, fontFamily: _f, fontPackage: _p);
  static const play = IconData(0xf14f, fontFamily: _f, fontPackage: _p);
  static const alignLeftLines = IconData(
    0xf151,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const contact = IconData(0xf14e, fontFamily: _f, fontPackage: _p);

  static const trendUpSolid = IconData(0xf015, fontFamily: _f, fontPackage: _p);
  static const logout = IconData(0xf13d, fontFamily: _f, fontPackage: _p);
  static const clock = IconData(0xf152, fontFamily: _f, fontPackage: _p);
  static const arrowNorthEast = IconData(
    0xf153,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const notificationUnread = IconData(
    0xf13b,
    fontFamily: _f,
    fontPackage: _p,
  );

  static const pos = IconData(0xf03F, fontFamily: _f, fontPackage: _p);
  static const palmTree = IconData(0xf156, fontFamily: _f, fontPackage: _p);
  static const car = IconData(0xf157, fontFamily: _f, fontPackage: _p);
  static const bag = IconData(0xf158, fontFamily: _f, fontPackage: _p);

  static const cashCoin = IconData(0xf168, fontFamily: _f, fontPackage: _p);
  static const clockCheck = IconData(0xf167, fontFamily: _f, fontPackage: _p);
  static const cuppedHandDot = IconData(
    0xf166,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const document = IconData(0xf165, fontFamily: _f, fontPackage: _p);
  static const fileLink = IconData(0xf164, fontFamily: _f, fontPackage: _p);
  static const invoice = IconData(0xf163, fontFamily: _f, fontPackage: _p);
  static const move = IconData(0xf161, fontFamily: _f, fontPackage: _p);
  static const notes = IconData(0xf160, fontFamily: _f, fontPackage: _p);
  static const retryCircle = IconData(0xf15f, fontFamily: _f, fontPackage: _p);
  static const scanAlt = IconData(0xf15e, fontFamily: _f, fontPackage: _p);
  static const settings = IconData(0xf15d, fontFamily: _f, fontPackage: _p);
  static const split = IconData(0xf15c, fontFamily: _f, fontPackage: _p);
  static const support = IconData(0xf15b, fontFamily: _f, fontPackage: _p);
  static const useStar = IconData(0xf15a, fontFamily: _f, fontPackage: _p);
  static const verified = IconData(0xf159, fontFamily: _f, fontPackage: _p);
  static const trendUp = IconData(0xf162, fontFamily: _f, fontPackage: _p);
  static const trendDown = IconData(0xf169, fontFamily: _f, fontPackage: _p);
  static const waterBill = IconData(0xf16b, fontFamily: _f, fontPackage: _p);
  static const wasteBill = IconData(0xf16c, fontFamily: _f, fontPackage: _p);
  static const walletAlt = IconData(0xf16d, fontFamily: _f, fontPackage: _p);
  static const refreshAlt = IconData(0xf16f, fontFamily: _f, fontPackage: _p);
  static const locationPin = IconData(0xf170, fontFamily: _f, fontPackage: _p);
  static const landBill = IconData(0xf171, fontFamily: _f, fontPackage: _p);

  /// A list containing all available [IconData] constants defined in [GtIcons].
  ///
  /// This is particularly useful for cataloging, testing, or building
  /// icon galleries (e.g., in Widgetbook).
  static List<({String label, IconData value})> get all => [
    (label: 'add', value: add),
    (label: 'airtime', value: airtime),
    (label: 'alarmClock', value: alarmClock),
    (label: 'alert', value: alert),
    (label: 'alignBottom', value: alignBottom),
    (label: 'alignHorizontal', value: alignHorizontal),
    (label: 'alignLeft', value: alignLeft),
    (label: 'alignLeftLines', value: alignLeftLines),
    (label: 'alignRight', value: alignRight),
    (label: 'alignTop', value: alignTop),
    (label: 'alignVertical', value: alignVertical),
    (label: 'alipay', value: alipay),
    (label: 'amazon', value: amazon),
    (label: 'amex', value: amex),
    (label: 'anchor', value: anchor),
    (label: 'android', value: android),
    (label: 'applepay', value: applepay),
    (label: 'arrowBottomRight', value: arrowBottomRight),
    (label: 'arrowDoorIn', value: arrowDoorIn),
    (label: 'arrowDoorOut', value: arrowDoorOut),
    (label: 'arrowNorthEast', value: arrowNorthEast),
    (label: 'art', value: art),
    (label: 'aspectRatioSquare', value: aspectRatioSquare),
    (label: 'atSign', value: atSign),
    (label: 'attach', value: attach),
    (label: 'award', value: award),
    (label: 'awardCertificate', value: awardCertificate),
    (label: 'awardFilled', value: awardFilled),
    (label: 'badge', value: badge),
    (label: 'bag', value: bag),
    (label: 'bagShopping', value: bagShopping),
    (label: 'ballBasket', value: ballBasket),
    (label: 'bankCard', value: bankCard),
    (label: 'basketShopping', value: basketShopping),
    (label: 'battery', value: battery),
    (label: 'batteryHigh', value: batteryHigh),
    (label: 'bell', value: bell),
    (label: 'bicycle', value: bicycle),
    (label: 'bitcoin', value: bitcoin),
    (label: 'bolt', value: bolt),
    (label: 'boltLightning', value: boltLightning),
    (label: 'boltSlash', value: boltSlash),
    (label: 'bookBookmark', value: bookBookmark),
    (label: 'bookmark', value: bookmark),
    (label: 'bookmarks', value: bookmarks),
    (label: 'bookmarkSlash', value: bookmarkSlash),
    (label: 'bookOpen', value: bookOpen),
    (label: 'box', value: box),
    (label: 'boxArchive', value: boxArchive),
    (label: 'bug', value: bug),
    (label: 'bugSlash', value: bugSlash),
    (label: 'bullhorn', value: bullhorn),
    (label: 'calendar', value: calendar),
    (label: 'calendarDays', value: calendarDays),
    (label: 'calendarEmpty', value: calendarEmpty),
    (label: 'calendarEmptyFilled', value: calendarEmptyFilled),
    (label: 'camera', value: camera),
    (label: 'cameraAlt', value: cameraAlt),
    (label: 'cancel', value: cancel),
    (label: 'car', value: car),
    (label: 'card', value: card),
    (label: 'cardCheck', value: cardCheck),
    (label: 'cardDark', value: cardDark),
    (label: 'cardEdit', value: cardEdit),
    (label: 'cardFilled', value: cardFilled),
    (label: 'cardLight', value: cardLight),
    (label: 'cartShopping', value: cartShopping),
    (label: 'cashEmpty', value: cashEmpty),
    (label: 'cautionOutline', value: cautionOutline),
    (label: 'cautionSolid', value: cautionSolid),
    (label: 'chair', value: chair),
    (label: 'chartBarTrendUp', value: chartBarTrendUp),
    (label: 'checkBox', value: checkBox),
    (label: 'checkOutline', value: checkOutline),
    (label: 'checkSolid', value: checkSolid),
    (label: 'chevronDown', value: chevronDown),
    (label: 'chevronDownOutline', value: chevronDownOutline),
    (label: 'chevronExpandY', value: chevronExpandY),
    (label: 'chevronLeft', value: chevronLeft),
    (label: 'chevronLeftOutline', value: chevronLeftOutline),
    (label: 'chevronRight', value: chevronRight),
    (label: 'chevronRightOutline', value: chevronRightOutline),
    (label: 'chevronUp', value: chevronUp),
    (label: 'chevronUpOutline', value: chevronUpOutline),
    (label: 'childHead', value: childHead),
    (label: 'circleCompose', value: circleCompose),
    (label: 'circleDottedCheck', value: circleDottedCheck),
    (label: 'circleHashtag', value: circleHashtag),
    (label: 'circleInfo', value: circleInfo),
    (label: 'clipboard', value: clipboard),
    (label: 'clipboardCheck', value: clipboardCheck),
    (label: 'clipboardSlash', value: clipboardSlash),
    (label: 'clock', value: clock),
    (label: 'cloud', value: cloud),
    (label: 'computer', value: computer),
    (label: 'contact', value: contact),
    (label: 'cookie', value: cookie),
    (label: 'copy', value: copy),
    (label: 'copyFilled', value: copyFilled),
    (label: 'crosshairs', value: crosshairs),
    (label: 'crosshairsSlash', value: crosshairsSlash),
    (label: 'cryptography', value: cryptography),
    (label: 'cuppedHand', value: cuppedHand),
    (label: 'cvv', value: cvv),
    (label: 'darkLight', value: darkLight),
    (label: 'delete', value: delete),
    (label: 'desktopArrowDown', value: desktopArrowDown),
    (label: 'dinersclub', value: dinersclub),
    (label: 'discover', value: discover),
    (label: 'dots', value: dots),
    (label: 'download', value: download),
    (label: 'drawCompass', value: drawCompass),
    (label: 'earth', value: earth),
    (label: 'editDoc', value: editDoc),
    (label: 'eftpos', value: eftpos),
    (label: 'envelopCheck', value: envelopCheck),
    (label: 'envelope', value: envelope),
    (label: 'envelopeOpen', value: envelopeOpen),
    (label: 'exchange', value: exchange),
    (label: 'eyeClosed', value: eyeClosed),
    (label: 'eyeOpen', value: eyeOpen),
    (label: 'eyeOutline', value: eyeOutline),
    (label: 'faceId', value: faceId),
    (label: 'facePlus', value: facePlus),
    (label: 'faceSmile', value: faceSmile),
    (label: 'feather', value: feather),
    (label: 'file', value: file),
    (label: 'fileContent', value: fileContent),
    (label: 'fileFilled', value: fileFilled),
    (label: 'files', value: files),
    (label: 'film', value: film),
    (label: 'funnel', value: funnel),
    (label: 'filter', value: filter),
    (label: 'filterSolid', value: filterSolid),
    (label: 'filters', value: filters),
    (label: 'fingerprint', value: fingerprint),
    (label: 'flag', value: flag),
    (label: 'flame', value: flame),
    (label: 'folder', value: folder),
    (label: 'folderOpen', value: folderOpen),
    (label: 'forklift', value: forklift),
    (label: 'gamepad', value: gamepad),
    (label: 'gamingButtons', value: gamingButtons),
    (label: 'gasPump', value: gasPump),
    (label: 'gauge', value: gauge),
    (label: 'gear', value: gear),
    (label: 'gem', value: gem),
    (label: 'gemSparkle', value: gemSparkle),
    (label: 'gift', value: gift),
    (label: 'globePointer', value: globePointer),
    (label: 'gpay', value: gpay),
    (label: 'graduationCap', value: graduationCap),
    (label: 'gridCirclePlus', value: gridCirclePlus),
    (label: 'halfDottedCirclePlay', value: halfDottedCirclePlay),
    (label: 'hand', value: hand),
    (label: 'handshake', value: handshake),
    (label: 'headset', value: headset),
    (label: 'heart', value: heart),
    (label: 'heartBreak', value: heartBreak),
    (label: 'heartHand', value: heartHand),
    (label: 'help', value: help),
    (label: 'helpInfo', value: helpInfo),
    (label: 'hide', value: hide),
    (label: 'home', value: home),
    (label: 'homeFilled', value: homeFilled),
    (label: 'hotDrink', value: hotDrink),
    (label: 'house', value: house),
    (label: 'houseAlt', value: houseAlt),
    (label: 'image', value: image),
    (label: 'imageDepth', value: imageDepth),
    (label: 'imageMountain', value: imageMountain),
    (label: 'images', value: images),
    (label: 'imageSparkle', value: imageSparkle),
    (label: 'inboxArrowDown', value: inboxArrowDown),
    (label: 'industry', value: industry),
    (label: 'info', value: info),
    (label: 'jcbGrey', value: jcbGrey),
    (label: 'key', value: key),
    (label: 'keyboard', value: keyboard),
    (label: 'keyPadA', value: keyPadA),
    (label: 'landBill', value: landBill),
    (label: 'language', value: language),
    (label: 'laptop', value: laptop),
    (label: 'laptopMobile', value: laptopMobile),
    (label: 'layers', value: layers),
    (label: 'leaf', value: leaf),
    (label: 'lifeRing', value: lifeRing),
    (label: 'lightbulb', value: lightbulb),
    (label: 'link', value: link),
    (label: 'loader', value: loader),
    (label: 'location', value: location),
    (label: 'locationPin', value: locationPin),
    (label: 'lock', value: lock),
    (label: 'lockOpen', value: lockOpen),
    (label: 'logout', value: logout),
    (label: 'magicWand', value: magicWand),
    (label: 'magnifier', value: magnifier),
    (label: 'magnifierFaceWorried', value: magnifierFaceWorried),
    (label: 'map', value: map),
    (label: 'mastercard', value: mastercard),
    (label: 'masterCardDuoTone', value: masterCardDuoTone),
    (label: 'mastercardLight', value: mastercardLight),
    (label: 'message', value: message),
    (label: 'messages', value: messages),
    (label: 'microphone', value: microphone),
    (label: 'microphoneSlash', value: microphoneSlash),
    (label: 'minus', value: minus),
    (label: 'mobile', value: mobile),
    (label: 'moneyBillCoin', value: moneyBillCoin),
    (label: 'more', value: more),
    (label: 'moreHorizontal', value: moreHorizontal),
    (label: 'msgBubbleUser', value: msgBubbleUser),
    (label: 'msgSmile', value: msgSmile),
    (label: 'msgWriting', value: msgWriting),
    (label: 'musicNoteSparkle', value: musicNoteSparkle),
    (label: 'nodes', value: nodes),
    (label: 'notification', value: notification),
    (label: 'notificationSolid', value: notificationSolid),
    (label: 'notificationUnread', value: notificationUnread),
    (label: 'office', value: office),
    (label: 'orderedList', value: orderedList),
    (label: 'paintbrush', value: paintbrush),
    (label: 'palmTree', value: palmTree),
    (label: 'paperclip', value: paperclip),
    (label: 'paperPlane', value: paperPlane),
    (label: 'password', value: password),
    (label: 'passcode', value: passcode),
    (label: 'payment', value: payment),
    (label: 'paymentFilled', value: paymentFilled),
    (label: 'paypal', value: paypal),
    (label: 'paypalAlt', value: paypalAlt),
    (label: 'pen', value: pen),
    (label: 'pencil', value: pencil),
    (label: 'penNib', value: penNib),
    (label: 'penSparkle', value: penSparkle),
    (label: 'penWriting', value: penWriting),
    (label: 'penWritingAlt', value: penWritingAlt),
    (label: 'percentage', value: percentage),
    (label: 'phone', value: phone),
    (label: 'phonebook', value: phonebook),
    (label: 'phoneCheck', value: phoneCheck),
    (label: 'phoneShake', value: phoneShake),
    (label: 'piggyBank', value: piggyBank),
    (label: 'piggyBankFilled', value: piggyBankFilled),
    (label: 'pinTack', value: pinTack),
    (label: 'pizzaSlice', value: pizzaSlice),
    (label: 'play', value: play),
    (label: 'plug', value: plug),
    (label: 'plus', value: plus),
    (label: 'pointer', value: pointer),
    (label: 'pos', value: pos),
    (label: 'presentationScreen', value: presentationScreen),
    (label: 'print', value: print),
    (label: 'product', value: product),
    (label: 'productFilled', value: productFilled),
    (label: 'progressBar', value: progressBar),
    (label: 'puzzlePiece', value: puzzlePiece),
    (label: 'qr', value: qr),
    (label: 'qrCode', value: qrCode),
    (label: 'qrMain', value: qrMain),
    (label: 'question', value: question),
    (label: 'receipts', value: receipts),
    (label: 'refresh', value: refresh),
    (label: 'refreshAlt', value: refreshAlt),
    (label: 'refreshSolid', value: refreshSolid),
    (label: 'reorder', value: reorder),
    (label: 'roadmap', value: roadmap),
    (label: 'rocket', value: rocket),
    (label: 'rotateAnticlockwise', value: rotateAnticlockwise),
    (label: 'rotation360', value: rotation360),
    (label: 'rulerPen', value: rulerPen),
    (label: 'satellite', value: satellite),
    (label: 'scale', value: scale),
    (label: 'scan', value: scan),
    (label: 'scissors', value: scissors),
    (label: 'scissorsCoupon', value: scissorsCoupon),
    (label: 'scribble', value: scribble),
    (label: 'search', value: search),
    (label: 'sendSolid', value: sendSolid),
    (label: 'shapes', value: shapes),
    (label: 'share', value: share),
    (label: 'shareIos', value: shareIos),
    (label: 'shareSolid', value: shareSolid),
    (label: 'shieldCheck', value: shieldCheck),
    (label: 'shop', value: shop),
    (label: 'shoppay', value: shoppay),
    (label: 'sideProfile', value: sideProfile),
    (label: 'signal', value: signal),
    (label: 'sitemap', value: sitemap),
    (label: 'sliders', value: sliders),
    (label: 'snowFlake', value: snowFlake),
    (label: 'sortDescending', value: sortDescending),
    (label: 'spark', value: spark),
    (label: 'sparkle', value: sparkle),
    (label: 'squareMinus', value: squareMinus),
    (label: 'squarePlus', value: squarePlus),
    (label: 'stackPerspective', value: stackPerspective),
    (label: 'star', value: star),
    (label: 'starSparkle', value: starSparkle),
    (label: 'stickerSmile', value: stickerSmile),
    (label: 'stopwatch', value: stopwatch),
    (label: 'subscription', value: subscription),
    (label: 'suitcase', value: suitcase),
    (label: 'switchOutline', value: switchOutline),
    (label: 'tag', value: tag),
    (label: 'tags', value: tags),
    (label: 'target', value: target),
    (label: 'tasks', value: tasks),
    (label: 'temple', value: temple),
    (label: 'textHighlight', value: textHighlight),
    (label: 'textTool', value: textTool),
    (label: 'thumbsUp', value: thumbsUp),
    (label: 'ticket', value: ticket),
    (label: 'timer', value: timer),
    (label: 'toggle', value: toggle),
    (label: 'transfer', value: transfer),
    (label: 'trash', value: trash),
    (label: 'trendUpSolid', value: trendUpSolid),
    (label: 'triangleWarning', value: triangleWarning),
    (label: 'ufo', value: ufo),
    (label: 'umbrella', value: umbrella),
    (label: 'unhide', value: unhide),
    (label: 'unionpay', value: unionpay),
    (label: 'unorderedList', value: unorderedList),
    (label: 'uploadFolder', value: uploadFolder),
    (label: 'uploadOutline', value: uploadOutline),
    (label: 'user', value: user),
    (label: 'userLaptop', value: userLaptop),
    (label: 'users', value: users),
    (label: 'userSearch', value: userSearch),
    (label: 'userSolid', value: userSolid),
    (label: 'userScan', value: userScan),
    (label: 'vault', value: vault),
    (label: 'vending', value: vending),
    (label: 'verifiedUsers', value: verifiedUsers),
    (label: 'video', value: video),
    (label: 'visa', value: visa),
    (label: 'visaLight', value: visaLight),
    (label: 'volume', value: volume),
    (label: 'volumeUp', value: volumeUp),
    (label: 'wallet', value: wallet),
    (label: 'walletAlt', value: walletAlt),
    (label: 'wandSparkle', value: wandSparkle),
    (label: 'wasteBill', value: wasteBill),
    (label: 'waterBill', value: waterBill),
    (label: 'watch', value: watch),
    (label: 'wechat', value: wechat),
    (label: 'whatsapp', value: whatsapp),
    (label: 'windowChartLine', value: windowChartLine),
    (label: 'windowExpandBottomRight', value: windowExpandBottomRight),
    (label: 'windowPointer', value: windowPointer),
    (label: 'x', value: x),
    (label: 'xmark', value: xmark),
    (label: 'cashCoin', value: cashCoin),
    (label: 'clockCheck', value: clockCheck),
    (label: 'cuppedHandDot', value: cuppedHandDot),
    (label: 'document', value: document),
    (label: 'fileLink', value: fileLink),
    (label: 'invoice', value: invoice),
    (label: 'move', value: move),
    (label: 'notes', value: notes),
    (label: 'retryCircle', value: retryCircle),
    (label: 'scanAlt', value: scanAlt),
    (label: 'settings', value: settings),
    (label: 'split', value: split),
    (label: 'support', value: support),
    (label: 'useStar', value: useStar),
    (label: 'verified', value: verified),
    (label: 'trendUp', value: trendUp),
    (label: 'trendDown', value: trendDown),
  ];
}
