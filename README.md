# SocioVerse 📱

![Flutter Version](https://img.shields.io/badge/Flutter-%5E3.12.0-blue.svg?logo=flutter)
![Dart Version](https://img.shields.io/badge/Dart-3.x-blue.svg?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen.svg)

**SocioVerse** is a modern, high-performance, TikTok-style short video social application built entirely with Flutter. It offers a seamless, immersive, and interactive experience for users to watch, create, discover, and interact with short-form video content.

## 🌟 Key Features

* **📱 Immersive Video Feed**: Infinite scrolling full-screen vertical video feed with auto-play and optimized video caching.
* **🎥 Video Creation & Editing**: Integrated camera for recording, picking videos from the gallery, and a comprehensive video editor.
* **🔍 Discover & Search**: Explore trending videos, search for creators, and discover hashtags with a dynamic discover screen.
* **👤 User Profiles**: Detailed user profiles showcasing user details, their uploaded videos, follower/following counts, and an edit profile feature.
* **🔔 Inbox & Notifications**: Stay updated with a dedicated inbox for notifications, new followers, likes, and interactions.
* **🔐 Authentication**: Secure login and signup flows.
* **🎨 Modern UI/UX**: Clean, responsive, and engaging user interface with modern typography, smooth animations, and interactive elements.

## 🛠 Tech Stack & Architecture

SocioVerse is built using robust and scalable modern Flutter architecture patterns.

### Core Technologies
* **Framework:** [Flutter](https://flutter.dev/) SDK `^3.12.0`
* **Language:** Dart `3.x`
* **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`) for robust, scalable, and type-safe state management.
* **Routing:** [GoRouter](https://pub.dev/packages/go_router) for declarative routing.

### Key Packages & Dependencies
* **Video Playback:** `video_player`, `chewie` (for advanced video controls and optimized playback)
* **Networking:** `dio` for HTTP networking, `cached_network_image` for seamless image caching.
* **Local Storage:** `hive_flutter` for fast, lightweight NoSQL key-value database storage.
* **Media Capture:** `camera`, `image_picker` for seamless device integration.
* **UI/UX:** `google_fonts` for typography.
* **Utilities:** `intl` (internationalization/formatting), `uuid` (unique ID generation).

## 📁 Project Structure

The project follows a **Feature-First (Layered)** architecture to ensure modularity, scalability, and maintainability.

```text
lib/
├── core/                   # Shared configurations, themes, routers, widgets, utils
│   ├── config.dart         # App-wide configurations
│   ├── router/             # GoRouter setup and route definitions
│   ├── theme/              # App colors, typography, and dark/light themes
│   ├── utils/              # Helper extensions, formatters, debouncers
│   └── widgets/            # Reusable UI components (Buttons, Avatars, Bottom Nav, Shimmer)
├── features/               # Independent feature modules
│   ├── auth/               # Login, Registration, Auth state
│   ├── create/             # Camera capture, Video picking, Video editing
│   ├── discover/           # Search functionality, Trending, HashTags
│   ├── feed/               # Main video scrolling feed, Video Post Models, Action bars
│   ├── inbox/              # Activity, Notifications, Messages
│   └── profile/            # User profile view, Edit profile
└── app.dart & main.dart    # Application entry points
```

## 🚀 Getting Started

Follow these steps to set up the project locally on your machine.

### Prerequisites
1. Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version `3.12.0` or higher).
2. Set up an IDE like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with the Flutter/Dart plugins.
3. Ensure you have an Android Emulator or iOS Simulator running, or a physical device connected.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/MohdAltamish/Socio_Verse.git
   cd socio_verse
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App:**
   ```bash
   flutter run
   ```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---
*Built with ❤️ using Flutter.*
