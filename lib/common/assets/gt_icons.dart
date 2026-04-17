import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/common/common.dart';

class GtIconData extends IconData {
  const GtIconData(super.codePoint)
    : super(fontFamily: GtFonts.icon, fontPackage: 'gt_mobile_ui');
}

/// A centralized class for the application's custom icon font.
///
/// Ensure the `GtIconFont.ttf` file is added to your `assets/fonts/` directory
/// and declared in your `pubspec.yaml` under the family name `GtIconFont`.
class GtIcons {
  /// Private constructor to prevent instantiation of this utility class.
  GtIcons._();

  /// ---------------------------------------------------------------------------
  /// NAVIGATION & CORE ICONS (Solid / High-Emphasis)
  /// ---------------------------------------------------------------------------
  static const userSolid = GtIconData(0xf110);
  static const spark = GtIconData(0xf112);
  static const shareSolid = GtIconData(0xf113);
  static const sendSolid = GtIconData(0xf114);
  static const search = GtIconData(0xf115);
  static const scan = GtIconData(0xf116);
  static const refreshSolid = GtIconData(0xf117);
  static const qr = GtIconData(0xf118);
  static const qrMain = GtIconData(0xf119);
  static const notificationSolid = GtIconData(0xf11a);
  static const more = GtIconData(0xf11b);
  static const info = GtIconData(0xf11c);
  static const help = GtIconData(0xf11d);
  static const gem = GtIconData(0xf11e);
  static const filterSolid = GtIconData(0xf11f);

  static const chevronUp = GtIconData(0xf120);
  static const chevronRight = GtIconData(0xf121);
  static const chevronLeft = GtIconData(0xf122);
  static const chevronDown = GtIconData(0xf123);

  static const checkSolid = GtIconData(0xf124);
  static const cautionSolid = GtIconData(0xf125);
  static const cancel = GtIconData(0xf126);
  static const add = GtIconData(0xf127);

  static const rotate360 = GtIconData(0xf128);
  static const rotate270 = GtIconData(0xf129);
  static const rotate180 = GtIconData(0xf12a);
  static const rotate90 = GtIconData(0xf12b);
  static const rotate0 = GtIconData(0xf12c);

  /// ---------------------------------------------------------------------------
  /// DECORATIVE ICONS
  /// ---------------------------------------------------------------------------
  static const transferSolid = GtIconData(0xf101);
  static const send = GtIconData(0xf102);
  static const docDecorative1 = GtIconData(0xf103);
  static const docDecorative2 = GtIconData(0xf104);
  static const docDecorative3 = GtIconData(0xf105);

  /// ---------------------------------------------------------------------------
  /// DEFAULT ICONS (Outline / Standard)
  /// ---------------------------------------------------------------------------
  static const scribble = GtIconData(0xf000);
  static const flame = GtIconData(0xf001);
  static const scissors = GtIconData(0xf002);
  static const flag = GtIconData(0xf003);
  static const scissorsCoupon = GtIconData(0xf004);
  static const fingerprint = GtIconData(0xf005);
  static const scale = GtIconData(0xf006);
  static const filters = GtIconData(0xf007);
  static const satellite = GtIconData(0xf008);
  static const filter = GtIconData(0xf009);
  static const rulerPen = GtIconData(0xf00a);
  static const film = GtIconData(0xf00b);
  static const rotation360 = GtIconData(0xf00c);
  static const files = GtIconData(0xf00d);
  static const rocket = GtIconData(0xf00e);
  static const file = GtIconData(0xf00f);
  static const roadmap = GtIconData(0xf010);
  static const fileContent = GtIconData(0xf011);
  static const refresh = GtIconData(0xf012);
  static const feather = GtIconData(0xf013);
  static const receipts = GtIconData(0xf014);
  static const facialRecognition = GtIconData(0xf015);
  static const question = GtIconData(0xf016);
  static const faceSmile = GtIconData(0xf017);
  static const qrCode = GtIconData(0xf018);
  static const facePlus = GtIconData(0xf019);
  static const puzzlePiece = GtIconData(0xf01a);
  static const eyeOpen = GtIconData(0xf01b);
  static const progressBar = GtIconData(0xf01c);
  static const eyeClosed = GtIconData(0xf01d);
  static const print = GtIconData(0xf01e);
  static const exchange = GtIconData(0xf01f);
  static const presentationScreen = GtIconData(0xf020);
  static const envelope = GtIconData(0xf021);
  static const pointer = GtIconData(0xf022);
  static const envelopeOpen = GtIconData(0xf023);
  static const plus = GtIconData(0xf024);
  static const envelopCheck = GtIconData(0xf025);
  static const plug = GtIconData(0xf026);
  static const calendarEmpty = GtIconData(0xf027);
  static const pizzaSlice = GtIconData(0xf028);
  static const editDoc = GtIconData(0xf029);
  static const pinTack = GtIconData(0xf02a);
  static const earth = GtIconData(0xf02b);
  static const phonebook = GtIconData(0xf02c);
  static const drawCompass = GtIconData(0xf02d);
  static const phone = GtIconData(0xf02e);
  static const download = GtIconData(0xf02f);
  static const phoneShake = GtIconData(0xf030);
  static const dots = GtIconData(0xf031);
  static const phoneCheck = GtIconData(0xf032);
  static const desktopArrowDown = GtIconData(0xf033);
  static const percentage = GtIconData(0xf034);
  static const sortDescending = GtIconData(0xf035);
  static const penWriting = GtIconData(0xf036);
  static const darkLight = GtIconData(0xf037);
  static const penWritingAlt = GtIconData(0xf038);
  static const cryptography = GtIconData(0xf039);
  static const penSparkle = GtIconData(0xf03a);
  static const crosshairs = GtIconData(0xf03b);
  static const penNib = GtIconData(0xf03c);
  static const crosshairsSlash = GtIconData(0xf03d);
  static const pen = GtIconData(0xf03e);
  static const creditCard = GtIconData(0xf03f);
  static const password = GtIconData(0xf040);
  static const copy = GtIconData(0xf041);
  static const paperclip = GtIconData(0xf042);
  static const cookie = GtIconData(0xf043);
  static const paperPlane = GtIconData(0xf044);
  static const computer = GtIconData(0xf045);
  static const paintbrush = GtIconData(0xf046);
  static const cloud = GtIconData(0xf047);
  static const orderedList = GtIconData(0xf048);
  static const clipboard = GtIconData(0xf049);
  static const office = GtIconData(0xf04a);
  static const clipboardSlash = GtIconData(0xf04b);
  static const notification = GtIconData(0xf04c);
  static const clipboardCheck = GtIconData(0xf04d);
  static const nodes = GtIconData(0xf04e);
  static const circleInfo = GtIconData(0xf04f);
  static const musicNoteSparkle = GtIconData(0xf050);
  static const circleHashtag = GtIconData(0xf051);
  static const messages = GtIconData(0xf052);
  static const circleDottedCheck = GtIconData(0xf053);
  static const msgWriting = GtIconData(0xf054);
  static const circleCompose = GtIconData(0xf055);
  static const xmark = GtIconData(0xf056);
  static const msgSmile = GtIconData(0xf057);
  static const chevronUpOutline = GtIconData(0xf058);
  static const x = GtIconData(0xf059);
  static const msgBubbleUser = GtIconData(0xf05a);
  static const chevronRightOutline = GtIconData(0xf05b);
  static const windowPointer = GtIconData(0xf05c);
  static const moneyBillCoin = GtIconData(0xf05d);
  static const chevronLeftOutline = GtIconData(0xf05e);
  static const windowExpandBottomRight = GtIconData(0xf05f);
  static const mobile = GtIconData(0xf060);
  static const chevronExpandY = GtIconData(0xf061);
  static const windowChartLine = GtIconData(0xf062);
  static const minus = GtIconData(0xf063);
  static const chevronDownOutline = GtIconData(0xf064);
  static const whatsapp = GtIconData(0xf065);
  static const microphone = GtIconData(0xf066);
  static const checkOutline = GtIconData(0xf067);
  static const watch = GtIconData(0xf068);
  static const microphoneSlash = GtIconData(0xf069);
  static const checkBox = GtIconData(0xf06a);
  static const wandSparkle = GtIconData(0xf06b);
  static const message = GtIconData(0xf06c);
  static const chartBarTrendUp = GtIconData(0xf06d);
  static const wallet = GtIconData(0xf06e);
  static const map = GtIconData(0xf06f);
  static const chair = GtIconData(0xf070);
  static const volume = GtIconData(0xf071);
  static const magnifier = GtIconData(0xf072);
  static const cautionOutline = GtIconData(0xf073);
  static const volumeUp = GtIconData(0xf074);
  static const magnifierFaceWorried = GtIconData(0xf075);
  static const cashEmpty = GtIconData(0xf076);
  static const video = GtIconData(0xf077);
  static const magicWand = GtIconData(0xf078);
  static const cartShopping = GtIconData(0xf079);
  static const vending = GtIconData(0xf07a);
  static const lock = GtIconData(0xf07b);
  static const cardCheck = GtIconData(0xf07c);
  static const vault = GtIconData(0xf07d);
  static const lockOpen = GtIconData(0xf07e);
  static const camera = GtIconData(0xf07f);
  static const users = GtIconData(0xf080);
  static const location = GtIconData(0xf081);
  static const cameraAlt = GtIconData(0xf082);
  static const user = GtIconData(0xf083);
  static const loader = GtIconData(0xf084);
  static const calendar = GtIconData(0xf085);
  static const userSearch = GtIconData(0xf086);
  static const link = GtIconData(0xf087);
  static const calendarDays = GtIconData(0xf088);
  static const userLaptop = GtIconData(0xf089);
  static const lightbulb = GtIconData(0xf08a);
  static const bullhorn = GtIconData(0xf08b);
  static const uploadOutline = GtIconData(0xf08c);
  static const lifeRing = GtIconData(0xf08d);
  static const bug = GtIconData(0xf08e);
  static const uploadFolder = GtIconData(0xf08f);
  static const leaf = GtIconData(0xf090);
  static const bugSlash = GtIconData(0xf091);
  static const unorderedList = GtIconData(0xf092);
  static const layers = GtIconData(0xf093);
  static const box = GtIconData(0xf094);
  static const unhide = GtIconData(0xf095);
  static const laptop = GtIconData(0xf096);
  static const boxArchive = GtIconData(0xf097);
  static const umbrella = GtIconData(0xf098);
  static const laptopMobile = GtIconData(0xf099);
  static const bookmarks = GtIconData(0xf09a);
  static const ufo = GtIconData(0xf09b);
  static const language = GtIconData(0xf09c);
  static const bookmark = GtIconData(0xf09d);
  static const triangleWarning = GtIconData(0xf09e);
  static const keyboard = GtIconData(0xf09f);
  static const bookmarkSlash = GtIconData(0xf0a0);
  static const trash = GtIconData(0xf0a1);
  static const key = GtIconData(0xf0a2);
  static const bookOpen = GtIconData(0xf0a3);
  static const transfer = GtIconData(0xf0a4);
  static const industry = GtIconData(0xf0a5);
  static const bookBookmark = GtIconData(0xf0a6);
  static const toggle = GtIconData(0xf0a7);
  static const inboxArrowDown = GtIconData(0xf0a8);
  static const bolt = GtIconData(0xf0a9);
  static const timer = GtIconData(0xf0aa);
  static const images = GtIconData(0xf0ab);
  static const boltSlash = GtIconData(0xf0ac);
  static const ticket = GtIconData(0xf0ad);
  static const image = GtIconData(0xf0ae);
  static const boltLightning = GtIconData(0xf0af);
  static const thumbsUp = GtIconData(0xf0b0);
  static const imageSparkle = GtIconData(0xf0b1);
  static const bicycle = GtIconData(0xf0b2);
  static const textTool = GtIconData(0xf0b3);
  static const imageMountain = GtIconData(0xf0b4);
  static const bell = GtIconData(0xf0b5);
  static const textHighlight = GtIconData(0xf0b6);
  static const imageDepth = GtIconData(0xf0b7);
  static const battery = GtIconData(0xf0b8);
  static const tasks = GtIconData(0xf0b9);
  static const house = GtIconData(0xf0ba);
  static const batteryHigh = GtIconData(0xf0bb);
  static const target = GtIconData(0xf0bc);
  static const houseAlt = GtIconData(0xf0bd);
  static const basketShopping = GtIconData(0xf0be);
  static const tags = GtIconData(0xf0bf);
  static const hotDrink = GtIconData(0xf0c0);
  static const ballBasket = GtIconData(0xf0c1);
  static const tag = GtIconData(0xf0c2);
  static const hide = GtIconData(0xf0c3);
  static const bagShopping = GtIconData(0xf0c4);
  static const suitcase = GtIconData(0xf0c5);
  static const heart = GtIconData(0xf0c6);
  static const badge = GtIconData(0xf0c7);
  static const subscription = GtIconData(0xf0c8);
  static const heartHand = GtIconData(0xf0c9);
  static const award = GtIconData(0xf0ca);
  static const stopwatch = GtIconData(0xf0cb);
  static const heartBreak = GtIconData(0xf0cc);
  static const awardCertificate = GtIconData(0xf0cd);
  static const stickerSmile = GtIconData(0xf0ce);
  static const headset = GtIconData(0xf0cf);
  static const attach = GtIconData(0xf0d0);
  static const star = GtIconData(0xf0d1);
  static const handshake = GtIconData(0xf0d2);
  static const atSign = GtIconData(0xf0d3);
  static const starSparkle = GtIconData(0xf0d4);
  static const hand = GtIconData(0xf0d5);
  static const aspectRatioSquare = GtIconData(0xf0d6);
  static const stackPerspective = GtIconData(0xf0d7);
  static const halfDottedCirclePlay = GtIconData(0xf0d8);
  static const art = GtIconData(0xf0d9);
  static const squarePlus = GtIconData(0xf0da);
  static const gridCirclePlus = GtIconData(0xf0db);
  static const rotateAnticlockwise = GtIconData(0xf0dc);
  static const squareMinus = GtIconData(0xf0dd);
  static const graduationCap = GtIconData(0xf0de);
  static const arrowDoorOut = GtIconData(0xf0df);
  static const arrowBottomRight = GtIconData(0xf0e0);
  static const globePointer = GtIconData(0xf0e1);
  static const arrowDoorIn = GtIconData(0xf0e2);
  static const sparkle = GtIconData(0xf0e3);
  static const gift = GtIconData(0xf0e4);
  static const android = GtIconData(0xf0e5);
  static const sliders = GtIconData(0xf0e6);
  static const gemSparkle = GtIconData(0xf0e7);
  static const anchor = GtIconData(0xf0e8);
  static const sitemap = GtIconData(0xf0e9);
  static const gear = GtIconData(0xf0ea);
  static const alignVertical = GtIconData(0xf0eb);
  static const signal = GtIconData(0xf0ec);
  static const gauge = GtIconData(0xf0ed);
  static const alignTop = GtIconData(0xf0ee);
  static const sideProfile = GtIconData(0xf0ef);
  static const gasPump = GtIconData(0xf0f0);
  static const alignRight = GtIconData(0xf0f1);
  static const shop = GtIconData(0xf0f2);
  static const gamingButtons = GtIconData(0xf0f3);
  static const alignLeft = GtIconData(0xf0f4);
  static const shieldCheck = GtIconData(0xf0f5);
  static const gamepad = GtIconData(0xf0f6);
  static const alignHorizontal = GtIconData(0xf0f7);
  static const share = GtIconData(0xf0f8);
  static const forklift = GtIconData(0xf0f9);
  static const alignBottom = GtIconData(0xf0fa);
  static const shareIos = GtIconData(0xf0fb);
  static const folder = GtIconData(0xf0fc);
  static const alert = GtIconData(0xf0fd);
  static const shapes = GtIconData(0xf0fe);
  static const folderOpen = GtIconData(0xf0ff);
  static const alarmClock = GtIconData(0xf100);

  /// A list containing all available [IconData] constants defined in [GtIcons].
  ///
  /// This is particularly useful for cataloging, testing, or building
  /// icon galleries (e.g., in Widgetbook).
  static List<IconData> get all => [
    userSolid,
    spark,
    shareSolid,
    sendSolid,
    search,
    scan,
    refreshSolid,
    qr,
    qrMain,
    notificationSolid,
    more,
    info,
    help,
    gem,
    filterSolid,
    chevronUp,
    chevronRight,
    chevronLeft,
    chevronDown,
    checkSolid,
    cautionSolid,
    cancel,
    add,
    rotate360,
    rotate270,
    rotate180,
    rotate90,
    rotate0,
    transferSolid,
    send,
    docDecorative1,
    docDecorative2,
    docDecorative3,
    scribble,
    flame,
    scissors,
    flag,
    scissorsCoupon,
    fingerprint,
    scale,
    filters,
    satellite,
    filter,
    rulerPen,
    film,
    rotation360,
    files,
    rocket,
    file,
    roadmap,
    fileContent,
    refresh,
    feather,
    receipts,
    facialRecognition,
    question,
    faceSmile,
    qrCode,
    facePlus,
    puzzlePiece,
    eyeOpen,
    progressBar,
    eyeClosed,
    print,
    exchange,
    presentationScreen,
    envelope,
    pointer,
    envelopeOpen,
    plus,
    envelopCheck,
    plug,
    calendarEmpty,
    pizzaSlice,
    editDoc,
    pinTack,
    earth,
    phonebook,
    drawCompass,
    phone,
    download,
    phoneShake,
    dots,
    phoneCheck,
    desktopArrowDown,
    percentage,
    sortDescending,
    penWriting,
    darkLight,
    penWritingAlt,
    cryptography,
    penSparkle,
    crosshairs,
    penNib,
    crosshairsSlash,
    pen,
    creditCard,
    password,
    copy,
    paperclip,
    cookie,
    paperPlane,
    computer,
    paintbrush,
    cloud,
    orderedList,
    clipboard,
    office,
    clipboardSlash,
    notification,
    clipboardCheck,
    nodes,
    circleInfo,
    musicNoteSparkle,
    circleHashtag,
    messages,
    circleDottedCheck,
    msgWriting,
    circleCompose,
    xmark,
    msgSmile,
    chevronUpOutline,
    x,
    msgBubbleUser,
    chevronRightOutline,
    windowPointer,
    moneyBillCoin,
    chevronLeftOutline,
    windowExpandBottomRight,
    mobile,
    chevronExpandY,
    windowChartLine,
    minus,
    chevronDownOutline,
    whatsapp,
    microphone,
    checkOutline,
    watch,
    microphoneSlash,
    checkBox,
    wandSparkle,
    message,
    chartBarTrendUp,
    wallet,
    map,
    chair,
    volume,
    magnifier,
    cautionOutline,
    volumeUp,
    magnifierFaceWorried,
    cashEmpty,
    video,
    magicWand,
    cartShopping,
    vending,
    lock,
    cardCheck,
    vault,
    lockOpen,
    camera,
    users,
    location,
    cameraAlt,
    user,
    loader,
    calendar,
    userSearch,
    link,
    calendarDays,
    userLaptop,
    lightbulb,
    bullhorn,
    uploadOutline,
    lifeRing,
    bug,
    uploadFolder,
    leaf,
    bugSlash,
    unorderedList,
    layers,
    box,
    unhide,
    laptop,
    boxArchive,
    umbrella,
    laptopMobile,
    bookmarks,
    ufo,
    language,
    bookmark,
    triangleWarning,
    keyboard,
    bookmarkSlash,
    trash,
    key,
    bookOpen,
    transfer,
    industry,
    bookBookmark,
    toggle,
    inboxArrowDown,
    bolt,
    timer,
    images,
    boltSlash,
    ticket,
    image,
    boltLightning,
    thumbsUp,
    imageSparkle,
    bicycle,
    textTool,
    imageMountain,
    bell,
    textHighlight,
    imageDepth,
    battery,
    tasks,
    house,
    batteryHigh,
    target,
    houseAlt,
    basketShopping,
    tags,
    hotDrink,
    ballBasket,
    tag,
    hide,
    bagShopping,
    suitcase,
    heart,
    badge,
    subscription,
    heartHand,
    award,
    stopwatch,
    heartBreak,
    awardCertificate,
    stickerSmile,
    headset,
    attach,
    star,
    handshake,
    atSign,
    starSparkle,
    hand,
    aspectRatioSquare,
    stackPerspective,
    halfDottedCirclePlay,
    art,
    squarePlus,
    gridCirclePlus,
    rotateAnticlockwise,
    squareMinus,
    graduationCap,
    arrowDoorOut,
    arrowBottomRight,
    globePointer,
    arrowDoorIn,
    sparkle,
    gift,
    android,
    sliders,
    gemSparkle,
    anchor,
    sitemap,
    gear,
    alignVertical,
    signal,
    gauge,
    alignTop,
    sideProfile,
    gasPump,
    alignRight,
    shop,
    gamingButtons,
    alignLeft,
    shieldCheck,
    gamepad,
    alignHorizontal,
    share,
    forklift,
    alignBottom,
    shareIos,
    folder,
    alert,
    shapes,
    folderOpen,
    alarmClock,
  ];
}
