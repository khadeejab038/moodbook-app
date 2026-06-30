# MoodBook 

**MoodBook** is a modern, intuitive, and feature-rich mood-tracking mobile application built with Flutter. It is designed to help users build self-awareness and track their mental wellness over time through quick daily check-ins, timezone-aware native notifications, interactive stats analytics, and robust offline support.

Developed by **Khadeeja Basit** and **Misha Jehangir**.

---

## 🌟 Features

### 1. Daily Mood Logging & Reflection
* **Dynamic Mood Selector:** A clean, screen-responsive mood row (Excellent, Good, Neutral, Bad, Terrible) that fits perfectly on all mobile displays.
* **Detailed Tags:** Log specific associated emotions (e.g., Happy, Stressed, Calm) and situational triggers/reasons (e.g., Work, Sleep, Family).
* **Personal Journaling:** Jot down private notes for each entry.
* **History Log:** View past entries, expand notes, edit logs, and delete items with immediate visual feedback.

### 2. Timezone-Aware Reminders
* **Custom Reminders:** Schedule multiple daily check-in alarms directly from the settings panel.
* **Android 14+ Compatible:** Built with custom background boot receivers (`RECEIVE_BOOT_COMPLETED`) and a try/catch exact-to-inexact scheduling fallback (`inexactAllowWhileIdle`) to prevent crashes or missed alarms.
* **Direct Deep-Linking:** Tapping a notification automatically launches the app and navigates you straight to the mood logging screen.

### 3. Interactive Analytics & Insights
* **Mood Calendar Heatmap:** A visual month-by-month grid indicating your daily mood status.
* **Mood Distribution Chart:** A clean pie chart illustrating percentages of each mood selected during custom periods (Today, Week, Month, Year).
* **Emotion Triggers Correlation:** An insights grid displaying which situations correlate most with specific emotions.

### 4. Resilient Offline Operations
* **Offline Logging:** Mood logs and edits are saved locally when network connection drops, and are automatically synced with Firestore in the background when connectivity returns.
* **Fail-Safe Analytics:** Safe builder handlers that display recover warnings instead of spinning endlessly when offline.

### 5. Security & Data Privacy
* **Secure Re-authentication:** Google Sign-in and email authentication wrappers that prompt for security checks before editing profiles or deleting accounts.
* **Bulk Document Deletions:** Uses Firestore `WriteBatch` operations capped at `500` limits for high-performance data purging when clearing logs or deleting accounts.
* **Data Portability:** Export your entire mood logging history into a standard CSV file directly to your device's downloads folder.
* **System Theme Synchronization:** Automatically launches in light/dark mode based on the user's system preferences.

---

## 🛠️ Technical Architecture

* **Framework:** Flutter (Dart)
* **Backend:** Firebase (Authentication & Cloud Firestore)
* **State Management:** Provider (Dynamic user-context tracking)
* **Local Notifications:** `flutter_local_notifications` (Android boot receivers + exact alarm fallbacks)
* **Timezones:** `timezone` & `flutter_timezone` (IANA database mapping)
* **Charts:** `fl_chart`

---

## 🚀 Setup & Installation

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.22.0 or higher recommended).
2. Install [Android Studio](https://developer.android.com/studio) or Xcode (for iOS builds).
3. Set up a [Firebase Project](https://console.firebase.google.com/).

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/moodbook-app.git
   cd moodbook-app
   ```

2. **Configure Firebase:**
   * Create an Android app in your Firebase Console under your project settings.
   * Download the `google-services.json` file and place it in the `android/app/` directory.

3. **Get dependencies:**
   ```bash
   flutter pub get
   ```

4. **Verify static analysis:**
   ```bash
   flutter analyze
   ```

5. **Run the application:**
   * Connect an Android device (via USB debugging) or start an emulator.
   * Run the app:
     ```bash
     flutter run
     ```

---

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
