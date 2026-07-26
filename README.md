# 📱 Easy Chat App & Social Marketplace

![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Supported-FFCA28?logo=firebase)
![Architecture](https://img.shields.io/badge/Architecture-Feature--First%20Clean%20Architecture-purple)
![License](https://img.shields.io/badge/License-MIT-green)

A comprehensive application combining a **Social Media Platform**, **Real-Time Chat App**, and an **E-Commerce Marketplace** with electronic payment support via Paymob and real-time push notifications using Firebase Cloud Messaging.

---

## 📽️ App Demo (Live Preview)

<div align="center">
  <video src="https://github.com/user-attachments/assets/20e530fe-4689-458b-ba60-dc215c28ebab" controls="controls" muted="muted" style="max-height:640px; width:auto;">
    Your browser does not support the video tag.
  </video>
  <br/>
  <i>Click play to watch the full application walkthrough.</i>
</div>

---

## 🏗️ Clean Architecture Overview

This project strictly follows a **Feature-First Clean Architecture** pattern. This approach ensures that the application is highly scalable, maintainable, and deeply modular. The codebase is mainly divided into two primary layers: `core` and `features`.

### 📂 Folder Structure

```text
lib/
├── core/                   # Contains app-wide shared resources
│   ├── cubit/              # Global state managers (e.g., ThemeCubit)
│   ├── service/            # Global services (e.g., CacheHelper)
│   └── utils/              # App themes, colors, and screen size utilities
├── features/               # Contains modular, self-contained features
│   ├── auth/               # Authentication feature
│   ├── chats/              # Real-time messaging feature
│   ├── Home/               # Main feed, stories, reels, and marketplace
│   ├── Intro/              # Onboarding screens
│   ├── Profile/            # User profile management
│   └── Search/             # Global user search
🧩 Feature LayersEach individual feature (e.g., auth, chats, Home) encapsulates its own logic, UI, and data components:  models/: Contains Plain Old Dart Objects (PODOs) and data serialization logic (e.g., converting Firestore JSON to Dart objects).  cubit/: Contains the BLoC/Cubit classes and states. This layer handles the business logic, interacts with services, and emits states to the UI.  views/: Contains the main screen layouts (Scaffold)[cite: 3]. They listen to Cubit state changes to rebuild the UI.widgets/: Contains reusable, decoupled UI components specific to that feature (e.g., post_container, chat_bubble) to keep the views clean[cite: 3].📦 Dependencies & Libraries ExplainedThe application utilizes highly reliable and community-tested packages to handle state, networking, and backend integration.  1. State Management & Local Storageflutter_bloc & bloc: Predictable state management libraries used to separate presentation from business logic using the Cubit pattern.  shared_preferences: Provides persistent storage for simple data, used here primarily via CacheHelper to save the user session and dark/light theme preferences locally.  2. Backend as a Service (Firebase)firebase_core: The foundational plugin required to connect the Flutter app to the Firebase project.  firebase_auth: Handles secure user authentication (Email/Password & Google Sign-In).  cloud_firestore: A NoSQL cloud database used to store and sync user data, posts, comments, and real-time chat messages.  firebase_messaging: Enables receiving and handling push notifications (FCM) both in the foreground and background.  3. Networking & API Integrationhttp: A basic, composable HTTP client used for making multipart requests (e.g., uploading images to ImgBB and Cloudinary).  dio: A powerful HTTP client for Dart used for complex API calls (Marketplace and Paymob integrations) due to its interceptors and easy configuration.  pretty_dio_logger: A Dio interceptor that neatly logs network requests and responses in the console, significantly aiding in debugging.  4. UI, Media & Web Integrationimage_picker: Allows users to pick images and videos directly from their device gallery or camera (used for profile pictures, posts, and reels).  video_player: Enables the playback of uploaded video files and reels inside the app.  webview_flutter: Provides a reliable embedded browser view, primarily used to securely render the Paymob payment gateway iframe.  cupertino_icons: Provides access to Apple's standard iOS-style icons.  5. Utilities & Securitygoogle_sign_in: Provides the secure OAuth flow required to authenticate users via their Google accounts.  flutter_dotenv: Secures the application by loading sensitive API keys and credentials from a .env file at runtime, preventing hardcoded secrets in the source code.  flutter_local_notifications: Displays customizable local push notifications when a message or alert is received while the app is actively running in the foreground.  url_launcher: Allows the app to launch external URLs in the device's native browser or applications.  meta: Provides annotations (like @required or @immutable) to enforce stricter coding rules and improve code readability.  flutter_stripe: Initially included for global payment processing capabilities, alongside Paymob.  ⚠️ Security & Configuration SetupImportant: Sensitive API keys and Firebase configurations are explicitly excluded from this repository for security purposes.1. Environment Variables (.env)You must create a .env file in the root directory with the following variables before running the app:مقتطف الرمزGOOGLE_WEB_CLIENT_ID=your_google_web_client_id
IMGBB_API_KEY=your_imgbb_api_key
PAYMOB_API_KEY=your_paymob_api_key
PAYMOB_INTEGRATION_ID=your_paymob_integration_id
PAYMOB_IFRAME_ID=your_paymob_iframe_id
RAPIDAPI_KEY=your_rapidapi_key
RAPIDAPI_HOST=aliexpress-business-api.p.rapidapi.com
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_UPLOAD_PRESET=your_cloudinary_upload_preset
2. Firebase InitializationThe firebase_options.dart and native config files (google-services.json, GoogleService-Info.plist) are tracked in .gitignore.Run the following command to link your own Firebase project:Bashflutterfire configure
🚀 How to RunClone the repository:Bashgit clone [https://github.com/teto06920623/chatapp.git](https://github.com/teto06920623/chatapp.git)
cd chatapp
Install dependencies:Bashflutter pub get
Setup environment: Ensure your .env file and Firebase configurations are properly set.Run the application:Bashflutter run
Developed with ❤️ by Taha Mohamad
