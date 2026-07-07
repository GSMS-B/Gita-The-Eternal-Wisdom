class AssetPaths {
  // DB
  static const String database = 'assets/data/gita.db';
  
  // Illustrations
  static const String loadingBg = 'assets/images/illustrations/splash_loading/loading_bg.png';
  static const String homeHero = 'assets/images/illustrations/home/hero_krishna_flute.png';
  static const String homeBanner = 'assets/images/illustrations/home/home_banner.png';
  static const String bookmarksEmpty = 'assets/images/illustrations/empty_states/bookmarks_empty.png';
  static const String searchEmpty = 'assets/images/illustrations/empty_states/search_empty.png';
  static const String offlineState = 'assets/images/illustrations/system_states/offline_state.png';
  static const String errorState = 'assets/images/illustrations/system_states/error_state.png';
  static const String readerHeader = 'assets/images/illustrations/reader_header.png';
  static const String chaptersHero = 'assets/images/illustrations/hero_chapters_list.png';  
  // Animations
  static const String loadingChariot = 'assets/images/animations/loader.png';
  static const String splashScreen = 'assets/images/logos/splash_screen.png';
  
  // Chapter Icons Base
  static const String chapterIcons = 'assets/images/chapter_icons/';
  static const String chapterHeroes = 'assets/images/chapter_heroes/';
  
  // Method to get chapter icon path by image_name
  static String getChapterIcon(String imageName) {
    return '$chapterIcons$imageName.png';
  }
  
  // Method to get chapter hero banner path by chapter number
  static String getChapterHero(int chapterNumber) {
    return '${chapterHeroes}chapter_$chapterNumber.png';
  }
}
