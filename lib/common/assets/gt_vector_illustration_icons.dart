/// A utility class that holds the paths to all vector illustrations (SVGs) used in the application.
///
/// This class centralizes asset paths to prevent typos and make them easily accessible
/// throughout the app.
class GtVectorIllustrationIcons {
  static const _basePath = "assets/images/vector/illustrations";

  // region ICONS

  /// Path to the book icon SVG.
  static const bookIcon = "$_basePath/book_icon.svg";

  /// Path to the charity icon SVG.
  static const charityIcon = "$_basePath/charity_icon.svg";

  /// Path to the debit icon SVG.
  static const debitIcon = "$_basePath/debit_icon.svg";

  /// Path to the education icon SVG.
  static const educationIcon = "$_basePath/education_icon.svg";

  /// Path to the emergency icon SVG.
  static const emergencyIcon = "$_basePath/emergency_icon.svg";

  /// Path to the family icon SVG.
  static const familyIcon = "$_basePath/family_icon.svg";

  /// Path to the fitness icon SVG.
  static const fitnessIcon = "$_basePath/fitness_icon.svg";

  /// Path to the food icon SVG.
  static const foodIcon = "$_basePath/food_icon.svg";

  /// Path to the gift icon SVG.
  static const giftIcon = "$_basePath/gift_icon.svg";

  /// Path to the health icon SVG.
  static const healthIcon = "$_basePath/health_icon.svg";

  /// Path to the holiday icon SVG.
  static const holidayIcon = "$_basePath/holiday_icon.svg";

  /// Path to the house icon SVG.
  static const houseIcon = "$_basePath/house_icon.svg";

  /// Path to the money icon SVG.
  static const moneyIcon = "$_basePath/money_icon.svg";

  /// Path to the payroll icon SVG.
  static const payrollIcon = "$_basePath/payroll_icon.svg";

  /// Path to the savings icon SVG.
  static const savingsIcon = "$_basePath/savings_icon.svg";

  /// Path to the shopping icon SVG.
  static const shoppingIcon = "$_basePath/shopping_icon.svg";

  /// Path to the transfer icon SVG.
  static const transferIcon = "$_basePath/transfer_icon.svg";

  /// Path to the transport icon SVG.
  static const transportIcon = "$_basePath/transport_icon.svg";

  /// Path to the wallet icon SVG.
  static const walletIcon = "$_basePath/wallet_icon.svg";

  /// A list containing all available vector illustration paths.
  static List<String> get all => [
        bookIcon,
        charityIcon,
        debitIcon,
        educationIcon,
        emergencyIcon,
        familyIcon,
        fitnessIcon,
        foodIcon,
        giftIcon,
        healthIcon,
        holidayIcon,
        houseIcon,
        moneyIcon,
        payrollIcon,
        savingsIcon,
        shoppingIcon,
        transferIcon,
        transportIcon,
        walletIcon,
      ];
}
