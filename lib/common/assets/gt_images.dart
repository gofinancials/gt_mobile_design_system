/// A utility class containing constants for remote network image URLs.
///
/// This includes illustrations, category icons, and avatar templates hosted remotely.
class GtNetworkImages {
  /// The base URL for all network images.
  static const String _baseUrl =
      'https://raw.githubusercontent.com/gofinancials/gt_images/refs/heads/main';

  /// Image URL for the bill illustration.
  static const String bill = '$_baseUrl/Bill.webp';

  /// Image URL for the books illustration.
  static const String books = '$_baseUrl/Books.webp';

  /// Image URL for the box illustration.
  static const String box = '$_baseUrl/Box.webp';

  /// Image URL for the business illustration.
  static const String business = '$_baseUrl/Business.webp';

  /// Image URL for the calendar illustration.
  static const String calendar = '$_baseUrl/Calendar.webp';

  /// Image URL for the card illustration.
  static const String card = '$_baseUrl/Card.webp';

  /// Image URL for the cash illustration.
  static const String cash = '$_baseUrl/Cash.webp';

  /// Image URL for the charity illustration.
  static const String charity = '$_baseUrl/Charity.webp';

  /// Image URL for the emergency illustration.
  static const String emergency = '$_baseUrl/Emergency.webp';

  /// Image URL for the fun illustration.
  static const String fun = '$_baseUrl/Fun.webp';

  /// Image URL for the gym illustration.
  static const String gym = '$_baseUrl/Gym.webp';

  /// Image URL for the health illustration.
  static const String health = '$_baseUrl/Health.webp';

  /// Image URL for the household illustration.
  static const String household = '$_baseUrl/Household.webp';

  /// Image URL for the medal illustration.
  static const String medal = '$_baseUrl/Medal.webp';

  /// Image URL for the others illustration.
  static const String others = '$_baseUrl/Others.webp';

  /// Image URL for the personal illustration.
  static const String personal = '$_baseUrl/Personal.webp';

  /// Image URL for the refund illustration.
  static const String refund = '$_baseUrl/Refund.webp';

  /// Image URL for the savings illustration.
  static const String savings = '$_baseUrl/Savings.webp';

  /// Image URL for the shopping illustration.
  static const String shopping = '$_baseUrl/Shopping.webp';

  /// Image URL for the transfer illustration.
  static const String transfer = '$_baseUrl/Transfer.webp';

  /// Image URL for the vacation illustration.
  static const String vacation = '$_baseUrl/Vacation.webp';

  /// Image URL for the vacations illustration.
  static const String vacations = '$_baseUrl/Vacations.webp';

  /// Image URL for the vault illustration.
  static const String vault = '$_baseUrl/Vault.webp';

  /// Image URL for the primary wallet illustration.
  static const String wallet1 = '$_baseUrl/Wallet-1.webp';

  /// Image URL for the standard wallet illustration.
  static const String wallet = '$_baseUrl/Wallet.webp';

  /// Image URL for the first sample avatar.
  static const String sampleAvatar1 = '$_baseUrl/sample_avatar_1.webp';

  /// Image URL for the second sample avatar.
  static const String sampleAvatar2 = '$_baseUrl/sample_avatar_2.webp';

  /// Image URL for the kids app splash background
  static const String kidsPattern = '$_baseUrl/kids.webp';

  /// Image URL for the flex app splash background
  static const String flexPattern = '$_baseUrl/flex.webp';

  /// Image URL for the first 3D avatar template.
  static const String avatar3d1 = '$_baseUrl/avatar_templates/3d_1.webp';

  /// Image URL for the second 3D avatar template.
  static const String avatar3d2 = '$_baseUrl/avatar_templates/3d_2.webp';

  /// Image URL for the third 3D avatar template.
  static const String avatar3d3 = '$_baseUrl/avatar_templates/3d_3.webp';

  /// Image URL for the fourth 3D avatar template.
  static const String avatar3d4 = '$_baseUrl/avatar_templates/3d_4.webp';

  /// Image URL for the fifth 3D avatar template.
  static const String avatar3d5 = '$_baseUrl/avatar_templates/3d_5.webp';

  /// Image URL for the sixth 3D avatar template.
  static const String avatar3d6 = '$_baseUrl/avatar_templates/3d_6.webp';

  /// Image URL for the first texture avatar template.
  static const String avatarTexture1 =
      '$_baseUrl/avatar_templates/texture_1.webp';

  /// Image URL for the second texture avatar template.
  static const String avatarTexture2 =
      '$_baseUrl/avatar_templates/texture_2.webp';

  /// Image URL for the third texture avatar template.
  static const String avatarTexture3 =
      '$_baseUrl/avatar_templates/texture_3.webp';

  /// Image URL for the fourth texture avatar template.
  static const String avatarTexture4 =
      '$_baseUrl/avatar_templates/texture_4.webp';

  /// Image URL for the fifth texture avatar template.
  static const String avatarTexture5 =
      '$_baseUrl/avatar_templates/texture_5.webp';

  /// A collection containing all 3D avatar template URLs.
  static const threeDAvatars = [
    avatar3d1,
    avatar3d2,
    avatar3d3,
    avatar3d4,
    avatar3d5,
    avatar3d6,
  ];

  /// A collection containing all texture avatar template URLs.
  static const textureAvatars = [
    avatarTexture1,
    avatarTexture2,
    avatarTexture3,
    avatarTexture4,
    avatarTexture5,
  ];

  /// A combined collection of all avatar template URLs (both 3D and texture).
  static const allAvatars = [...threeDAvatars, ...textureAvatars];
}

/// A utility class containing constants for local raster asset image paths.
///
/// These images are bundled locally within the package assets.
class GtAssetImages {
  /// The base path for raster image assets within the package.
  static const _basePath = "packages/gt_mobile_ui/assets/images/raster";

  /// The asset path for the default avatar image.
  static const String avatar = '$_basePath/avatar.png';

  /// A collection containing all local raster asset image paths.
  static const all = [avatar];
}
