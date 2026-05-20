# Flutter Short-Video App — Complete Build Prompt

> Minimal, clean, dark-first UI inspired by TikTok. Every screen, every widget, every interaction defined.

---

## 1. PROJECT OVERVIEW

Build a **Flutter short-video social app** with a minimal, modern dark UI. The design language is:
- Pure black backgrounds (`#000000`, `#0A0A0A`)
- White text, soft grey secondary text
- Single accent: vivid pink/magenta (`#EE1D52`) for CTAs and active states
- No gradients on UI chrome — gradients only on video overlays
- Rounded corners everywhere (cards: 12px, avatars: full circle, bottom nav pills)
- Generous whitespace, no visual clutter

---

## 2. TECH STACK

| Layer | Choice |
|---|---|
| Framework | Flutter 3.19+ (Dart 3.3+) |
| State Management | Riverpod 2.x (AsyncNotifier + StateNotifier) |
| Navigation | GoRouter 13.x |
| Video Playback | `video_player` + `chewie` |
| Local Storage | Hive 2.x (boxes for user data, liked posts, drafts) |
| Image/Video Picker | `image_picker` |
| HTTP/API | `dio` + `retrofit` code gen |
| Dependency Injection | Riverpod providers |
| Animations | Flutter built-in `AnimationController` + `Lottie` |
| Icons | `lucide_icons` Flutter package |
| Fonts | Google Fonts — `Inter` (body), `Poppins` (headings) |
| Testing | `flutter_test` + `mocktail` |

---

## 3. FOLDER STRUCTURE

```
lib/
├── main.dart
├── app.dart                        # MaterialApp + GoRouter setup
├── core/
│   ├── theme/
│   │   ├── app_theme.dart          # ThemeData, colors, text styles
│   │   ├── app_colors.dart         # Color constants
│   │   └── app_typography.dart     # TextStyle constants
│   ├── router/
│   │   └── app_router.dart         # GoRouter route definitions
│   ├── utils/
│   │   ├── formatters.dart         # number formatters (8.6k, 84m)
│   │   ├── debouncer.dart
│   │   └── extensions.dart         # BuildContext, String extensions
│   └── widgets/
│       ├── app_avatar.dart
│       ├── app_bottom_nav.dart
│       ├── app_icon_button.dart
│       └── count_badge.dart
├── features/
│   ├── feed/
│   │   ├── data/
│   │   │   ├── feed_repository.dart
│   │   │   └── models/video_post.dart
│   │   ├── presentation/
│   │   │   ├── feed_screen.dart
│   │   │   ├── video_player_widget.dart
│   │   │   ├── video_action_bar.dart    # like/comment/share sidebar
│   │   │   └── video_info_overlay.dart  # username, caption, song
│   │   └── providers/
│   │       └── feed_provider.dart
│   ├── discover/
│   │   ├── data/
│   │   │   └── search_repository.dart
│   │   ├── presentation/
│   │   │   ├── discover_screen.dart
│   │   │   ├── search_bar_widget.dart
│   │   │   └── trending_grid.dart
│   │   └── providers/
│   │       └── search_provider.dart
│   ├── create/
│   │   ├── presentation/
│   │   │   ├── create_screen.dart
│   │   │   ├── camera_preview_widget.dart
│   │   │   └── video_editor_screen.dart
│   │   └── providers/
│   │       └── create_provider.dart
│   ├── inbox/
│   │   ├── data/
│   │   │   └── notification_model.dart
│   │   ├── presentation/
│   │   │   ├── inbox_screen.dart
│   │   │   └── notification_tile.dart
│   │   └── providers/
│   │       └── inbox_provider.dart
│   └── profile/
│       ├── data/
│       │   └── user_model.dart
│       ├── presentation/
│       │   ├── profile_screen.dart
│       │   ├── profile_header.dart
│       │   ├── profile_stats_row.dart
│       │   ├── profile_tab_bar.dart
│       │   └── video_grid_item.dart
│       └── providers/
│           └── profile_provider.dart
assets/
├── fonts/
├── icons/
├── lottie/
│   ├── like_animation.json
│   └── loading.json
└── images/
    └── placeholder.png
```

---

## 4. THEME & DESIGN TOKENS

### `app_colors.dart`
```dart
class AppColors {
  // Backgrounds
  static const black       = Color(0xFF000000);
  static const surface     = Color(0xFF0A0A0A);
  static const card        = Color(0xFF161616);
  static const divider     = Color(0xFF2A2A2A);

  // Text
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8A8A8A);
  static const textTertiary  = Color(0xFF555555);

  // Accent
  static const pink          = Color(0xFFEE1D52);
  static const pinkSoft      = Color(0xFFFF2D55);
  static const cyan          = Color(0xFF69C9D0);  // TikTok teal (logo only)

  // Overlays
  static const videoOverlay  = Color(0x66000000); // 40% black
  static const bottomGradientStart = Color(0x00000000);
  static const bottomGradientEnd   = Color(0xCC000000);
}
```

### `app_typography.dart`
```dart
// All sizes in sp, all weights from Inter/Poppins
static const displayLarge  = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'Poppins');
static const headingMedium = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins');
static const bodyLarge     = TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontFamily: 'Inter');
static const bodyMedium    = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontFamily: 'Inter');
static const labelSmall    = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Inter');
static const countLabel    = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter');
```

### ThemeData rules
- `scaffoldBackgroundColor`: `AppColors.black`
- `appBarTheme`: transparent, no elevation, white icons
- `bottomNavigationBarTheme`: `AppColors.black` background, no elevation
- `textTheme`: all white by default
- `splashColor` / `highlightColor`: transparent (use custom ink)
- `pageTransitionsTheme`: `FadeUpwardsPageTransitionsBuilder` for all platforms

---

## 5. NAVIGATION (GoRouter)

```
/                   → FeedScreen (shell)
/discover           → DiscoverScreen
/create             → CreateScreen (modal full-screen)
/inbox              → InboxScreen
/profile            → ProfileScreen (own)
/profile/:userId    → ProfileScreen (other user)
/video/:videoId     → SingleVideoScreen
/comments/:videoId  → CommentsBottomSheet (as a route)
```

### Shell Route
Wrap all tabs in a `ShellRoute` with `AppBottomNav`. The create button (`+`) in the center pushes `/create` as a full-screen modal (no bottom nav visible).

---

## 6. BOTTOM NAVIGATION BAR

### Rules
- 5 items: Home, Discover, ➕ Create, Inbox, Profile
- Active icon: white, label visible
- Inactive icon: `AppColors.textSecondary`, no label
- Center Create button: white circle (`56px`), black `+` icon, slight shadow
- No border/elevation on the bar itself
- Height: `60px` + safe area padding

### `AppBottomNav` widget spec
```dart
BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: AppColors.black,
  selectedItemColor: AppColors.textPrimary,
  unselectedItemColor: AppColors.textSecondary,
  showSelectedLabels: true,
  showUnselectedLabels: false,
  elevation: 0,
  items: [home, discover, create(custom), inbox, profile],
)
```
The create item is a `BottomNavigationBarItem` with a custom `SizedBox` widget — override the icon slot with a `Container(decoration: BoxDecoration(shape: BoxShape.circle, color: white), child: Icon(Icons.add, color: black))`.

---

## 7. SCREEN SPECS

---

### 7.1 FEED SCREEN (`feed_screen.dart`)

**Layout:** Full-screen `PageView` (vertical, scroll physics: `PageScrollPhysics`), each page = one video post.

**Video Player Widget**
- Uses `video_player` controller, initialized lazily per page
- Preload next 1 video while current plays
- Auto-play on page enter, pause on page exit
- Double-tap anywhere → trigger like animation (Lottie heart burst)
- Single tap → toggle play/pause (show/hide play icon with `AnimatedOpacity`)

**Video Overlay (bottom-left)**
```
@username          ← bold white, tappable → ProfileScreen
Caption text...    ← white, max 2 lines, "Read more" expands
Read more          ← pink underline text
♫ Song name        ← scrolling marquee text, music note icon
```

**Action Sidebar (right side, vertically centered)**
```
[Avatar + follow+]   ← 48px circle, pink + badge
[Heart icon]         ← filled pink when liked, white outline when not
[38.2k]              ← count below
[Comment bubble]
[8.6k]
[Share arrow]
[Share]
```

Action sidebar items: each is a `Column(icon, SizedBox(4), Text(count))`. Tap heart → animate scale (0.8→1.2→1.0), toggle state, update count optimistically.

**Top Tab Bar**
- "Following" | "For You" — centered at top
- Active tab: white text + small pink dot indicator below
- Inactive: `textSecondary`
- Transparent background, overlaid on video

**Feed Provider**
```dart
@riverpod
class FeedNotifier extends _$FeedNotifier {
  Future<List<VideoPost>> build() async { ... }
  Future<void> toggleLike(String videoId) async { ... }
  Future<void> loadMore() async { ... }  // pagination
}
```

---

### 7.2 DISCOVER SCREEN (`discover_screen.dart`)

**Layout:** `CustomScrollView` with:
1. Sticky `SliverAppBar` containing search bar
2. Horizontal scrollable category chips (Trending, Music, Food, Travel, etc.)
3. `SliverGrid` — 2-column staggered grid of trending videos

**Search Bar**
- Background: `AppColors.card` (`#161616`)
- Border radius: `10px`
- Placeholder: "Search" in `textSecondary`
- Leading: search icon in `textSecondary`
- On tap → navigate to search results page (or expand inline)
- No border, no shadow

**Category Chips**
```dart
FilterChip(
  label: Text(category),
  selected: isSelected,
  backgroundColor: AppColors.card,
  selectedColor: AppColors.pink,
  labelStyle: TextStyle(color: isSelected ? white : textSecondary),
  side: BorderSide.none,
  shape: StadiumBorder(),
)
```

**Video Grid**
- 2 columns, `crossAxisSpacing: 8`, `mainAxisSpacing: 8`
- Each item: `ClipRRect(borderRadius: 8)` wrapping thumbnail + play icon overlay + view count chip

---

### 7.3 CREATE SCREEN (`create_screen.dart`)

**Full-screen modal** (transparent nav, black background)

**Layout (top → bottom):**
```
[X close]   [Sounds]   [Effects]   [Text]   [Stickers]    ← top toolbar
                                                           
         [ Camera Preview — full screen ]                 
                                                           
[Flip cam] [Speed] [Beauty] [Filters] [Timer]             ← left side strip
                                                           
[Gallery thumb]  [Record Button]  [Templates]             ← bottom controls
         [Hold for video, tap for photo]                  
```

**Record Button**
- Outer ring: white, 80px
- Inner circle: pink/red, 60px
- On hold: ring animates to show progress (circular `AnimatedBuilder`)
- On release: stop recording

**After Recording**
- Navigate to `VideoEditorScreen`
- Show: trim bar, add sound, add text, next button

---

### 7.4 INBOX SCREEN (`inbox_screen.dart`)

**Tabs:** "All Activity" | "Mentions"

**Notification types (each a `ListTile` variant):**
- New follower: avatar + "started following you" + Follow back button
- Like: avatar + "liked your video" + video thumbnail (right)
- Comment: avatar + "commented: [text]" + video thumbnail
- Mention: avatar + "mentioned you in a comment"

**Design rules:**
- Row height: `72px`
- Avatar: `44px` circle
- Text: primary white username bold, secondary grey action text
- Timestamp: right-aligned, `textTertiary`, small
- Video thumbnail (where applicable): `48x64px`, rounded 4px, right side
- Divider: 0.5px `AppColors.divider`, left-inset by `72px`

---

### 7.5 PROFILE SCREEN (`profile_screen.dart`)

**Header Section**
```
[Instagram icon]    [Avatar 80px]    [⋯ more]
                  @username
         [Following] [Followers] [Likes]      ← stats row
                    [Bio text]
              [Edit Profile / Follow]
```

**Stats Row**
- 3 columns, center-aligned
- Number: `headingMedium` white bold
- Label: `labelSmall` `textSecondary`
- Tap on Following/Followers → navigate to user list screen

**Tab Bar**
- 3 tabs: Grid (videos), Liked (heart), Private (lock)
- Icons only, no text labels
- Active tab: white icon + bottom border indicator (2px pink)
- Inactive: `textSecondary`

**Video Grid**
- 3 columns
- `crossAxisSpacing: 1.5`, `mainAxisSpacing: 1.5`
- Each item: thumbnail filling cell, play icon bottom-left, view count bottom-right
- View count format: `328.2k` (use `formatters.dart`)

**Number Formatter (must implement):**
```dart
String formatCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}m';
  if (n >= 1000)    return '${(n / 1000).toStringAsFixed(1)}k';
  return n.toString();
}
```

---

## 8. DATA MODELS

### `VideoPost`
```dart
class VideoPost {
  final String id;
  final String userId;
  final String username;
  final String avatarUrl;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;
  final String songName;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int viewCount;
  final bool isLiked;
  final bool isFollowing;
  final DateTime createdAt;
}
```

### `UserModel`
```dart
class UserModel {
  final String id;
  final String username;
  final String avatarUrl;
  final String bio;
  final int followingCount;
  final int followersCount;
  final int likeCount;
  final List<VideoPost> posts;
  final bool isFollowing;
}
```

### `NotificationItem`
```dart
enum NotificationType { follow, like, comment, mention }

class NotificationItem {
  final String id;
  final NotificationType type;
  final UserModel fromUser;
  final VideoPost? relatedVideo;
  final String? commentText;
  final DateTime timestamp;
  final bool isRead;
}
```

---

## 9. STATE MANAGEMENT RULES

- Use **Riverpod 2.x** exclusively — no setState except inside purely local animation controllers
- Every screen has its own `*Provider` file in `providers/`
- Use `AsyncValue` for all network data — always handle `.loading`, `.error`, `.data` states
- Loading state: show `Shimmer` skeleton (custom shimmer widget, not package)
- Error state: minimal inline error with retry button (no full-screen error)
- Optimistic updates: toggle like/follow locally first, revert on error

### Provider naming convention
```
feedProvider          → AsyncNotifierProvider<FeedNotifier, List<VideoPost>>
profileProvider       → family provider: profileProvider(userId)
searchQueryProvider   → StateProvider<String>
searchResultsProvider → AsyncNotifierProvider<SearchNotifier, List<VideoPost>>
activeTabProvider     → StateProvider<int> (bottom nav index)
```

---

## 10. ANIMATIONS & MICRO-INTERACTIONS

| Interaction | Animation |
|---|---|
| Double-tap like | Lottie heart burst at tap position, 800ms |
| Heart icon toggle | Scale: 1.0 → 0.8 → 1.2 → 1.0, 300ms |
| Follow button | Width animate from full text to "Following", color flip |
| Page transition (feed) | Native vertical PageView snap |
| Bottom nav switch | Icon scale 0.9 → 1.0, 150ms |
| Grid item tap | Scale 0.96 ripple effect |
| Comment sheet | Slide up from bottom, blur background |
| Video load | Shimmer placeholder until first frame rendered |

**Double-tap like implementation:**
```dart
// Use GestureDetector with onDoubleTapDown to capture position
// Stack a Lottie widget at the tap offset
// Auto-remove after animation completes
```

---

## 11. VIDEO PLAYER RULES

```dart
// In FeedScreen, use a PageController
// Initialize VideoPlayerController for currentIndex and currentIndex+1
// Dispose controllers for pages more than 2 away
// Always call controller.setLooping(true)
// Always call controller.setVolume(1.0)
// On PageView.onPageChanged → pause old, play new
// Show CircularProgressIndicator centered while buffering
// Use AspectRatio(aspectRatio: 9/16) inside a SizedBox.expand
// Use BoxFit.cover for video fill
```

---

## 12. COMMENTS BOTTOM SHEET

Route: `/comments/:videoId` rendered as `showModalBottomSheet`.

**Layout:**
```
[drag handle — 4px pill, grey, centered top]
Comments (count)                    [X]
─────────────────────────────────────────
[Avatar] [Username bold] [Comment text]
         [timestamp]  [♥ count]
  └── [Reply]
─────────────────────────────────────────
[Avatar] [Type a comment...]  [Send →]   ← pinned bottom
```

**Rules:**
- Sheet height: 75% of screen
- Background: `AppColors.surface` (`#0A0A0A`)
- Corner radius: `16px` top corners only
- Comment input: stuck to keyboard (use `resizeToAvoidBottomInset: true`)
- Comment list: `ListView.builder` with `reverse: false`
- Like on comment: inline heart toggle, no navigation

---

## 13. FOLLOW BUTTON WIDGET

Reusable `FollowButton` widget used in profile header, video overlay avatar, and search results.

```dart
// States: following=false → outlined white button "Follow"
// States: following=true  → filled grey button "Following"  
// On tap: optimistic toggle + call provider
// Size: height 32px, horizontal padding 16px, border-radius 4px
// Font: 14sp, semi-bold
```

---

## 14. PUBSPEC.YAML DEPENDENCIES

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Navigation
  go_router: ^13.2.0
  
  # Video
  video_player: ^2.8.3
  chewie: ^1.7.5
  
  # Storage
  hive_flutter: ^1.1.0
  
  # Network
  dio: ^5.4.3+1
  
  # UI
  google_fonts: ^6.2.1
  lottie: ^3.1.0
  cached_network_image: ^3.3.1
  
  # Picker
  image_picker: ^1.1.0
  
  # Utils
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  riverpod_generator: ^2.4.3
  build_runner: ^2.4.9
  mocktail: ^1.0.3
  flutter_lints: ^3.0.2
```

---

## 15. ANDROID / IOS PERMISSIONS

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access for recording videos</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access for recording audio</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Access to photo library for uploading videos</string>
```

---

## 16. MOCK DATA / DEMO MODE

Since there is no backend, implement a `MockFeedRepository` that:
- Returns 10–20 hardcoded `VideoPost` objects
- Uses publicly available sample video URLs (e.g., from `sample-videos.com` or `commondatastorage.googleapis.com`)
- Simulates network delay with `Future.delayed(Duration(milliseconds: 800))`
- Persists like/follow state in Hive

Toggle via a `const bool kUseMockData = true;` in `core/config.dart`.

---

## 17. PERFORMANCE RULES

1. **Video preloading:** Never initialize more than 3 video controllers at once
2. **Image caching:** Always use `CachedNetworkImage`, never `Image.network`
3. **Avoid rebuilds:** Use `ConsumerWidget` only where needed; prefer `select()` to narrow rebuilds
4. **Grid thumbnails:** Use `memCacheWidth` / `memCacheHeight` to downscale large images
5. **Dispose:** Every `VideoPlayerController`, `AnimationController`, `TextEditingController` must be disposed in `dispose()`
6. **const constructors:** Use `const` wherever possible for static widgets
7. **ListView:** Always use `ListView.builder`, never `ListView(children: [...])`  for long lists

---

## 18. CODE QUALITY RULES

- Enable `flutter_lints` — fix all warnings before considering complete
- Use `final` for all immutable variables
- Use `freezed` or plain immutable classes for all data models
- No `dynamic` types anywhere
- All async functions must handle errors with `try/catch`
- All provider errors must be surfaced to the UI (no silent failures)
- File naming: `snake_case.dart`
- Class naming: `PascalCase`
- Private members: `_camelCase`

---

## 19. RESPONSIVE / SAFE AREA RULES

- Always wrap screens in `SafeArea` where applicable (or use `MediaQuery.padding`)
- Feed screen: `SafeArea(bottom: false)` — video fills full screen, nav bar is overlaid
- Profile/Discover/Inbox: `SafeArea(top: true, bottom: true)`
- Use `MediaQuery.of(context).size` for any dynamic sizing
- Test on: small phone (360×640), standard (390×844), large (430×932)

---

## 20. BUILD & RUN CHECKLIST

Before marking the project complete, verify:

- [ ] All 5 screens render without overflow or layout errors
- [ ] Feed video auto-plays, pauses on swipe, resumes on swipe back
- [ ] Double-tap triggers like animation at correct position
- [ ] Heart icon toggles with animation, count updates
- [ ] Follow button toggles state correctly
- [ ] Profile stats show formatted numbers (e.g., 846k not 846000)
- [ ] Comments bottom sheet opens, keyboard pushes input up
- [ ] Bottom nav switches screens without re-initializing state
- [ ] Discover search bar is interactive (at minimum filters mock data)
- [ ] Profile grid shows 3-column layout with view counts
- [ ] No `print` statements left in production code
- [ ] No hardcoded colors outside `AppColors`
- [ ] No hardcoded strings outside constants file
- [ ] App runs on both Android (arm64) and iOS simulator without errors

---

## 21. VIBE / TONE NOTES FOR AI CODING ASSISTANTS

When generating code for this project:
- **Minimal is the rule** — if a widget can be removed without losing function, remove it
- **No unnecessary containers** — don't wrap things in Container when Padding or SizedBox will do
- **Consistent spacing** — use multiples of 4px (4, 8, 12, 16, 20, 24, 32)
- **Dark first** — never assume light mode; this app is always dark
- **No lorem ipsum** in mock data — use real-looking usernames, captions, song names
- **The + button is sacred** — always perfectly centered, always white circle, always accessible

---

*End of prompt. Build this exactly as specified. Any deviation from the color system, navigation structure, or state management approach should be flagged and discussed before proceeding.*
