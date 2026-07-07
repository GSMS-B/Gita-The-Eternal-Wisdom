# Gita - The Eternal Wisdom 🦚

A beautiful, immersive, and elegantly designed Flutter application for reading and meditating upon the Bhagavad Gita. This app features a majestic UI, immersive hero banners, personalized daily verses, bookmarking, and complete offline reading capabilities.

## ✨ Features
- **Majestic User Interface:** Stunning visual design featuring custom hero banners, intricate chapter icons, and smooth micro-animations.
- **Offline First Database:** Powered by a pre-packaged SQLite database for lightning-fast, offline access to every verse and chapter without needing an internet connection.
- **Meditation Mode:** A dedicated meditation screen featuring continuous rippling waves for focus and mindfulness.
- **Reading Progress Tracking:** Easily track your progress, mark verses as read or unread, and pick up right where you left off.
- **Bookmarking & Search:** Save your favorite verses and search across the entire scripture instantly.

## 🤝 Acknowledgements & Dataset
This application relies on the incredibly comprehensive and open-source Bhagavad Gita dataset provided by the **Vedic Scriptures** project. 

We would like to deeply acknowledge and thank the creators and maintainers of that repository for making this rich data freely available to developers:
- **Dataset Repository:** [vedicscriptures/bhagavad-gita](https://github.com/vedicscriptures/bhagavad-gita)

## 🚀 Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.10.0 or higher)
- Android Studio / VS Code with Flutter extensions installed
- An Android Emulator or physical device for testing

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY-NAME.git
   cd YOUR-REPOSITORY-NAME
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App (Debug Mode):**
   ```bash
   flutter run
   ```

## 📦 Building for Production

### Android Release APK
To build a production-ready, highly optimized APK that you can install directly on any Android device, run the following command in your terminal:

```bash
flutter build apk --release
```
*The compiled APK will be successfully generated at:* `build/app/outputs/flutter-apk/app-release.apk`
