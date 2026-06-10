# Application Management Portal (Frontend)

A modern, responsive Flutter-based frontend for the Application Management Portal. This application serves as the centralized dashboard for administrative users to access, categorize, and manage various system modules and portals.

## 📋 Technology Stack

- **Flutter**: 3.41.6 (Stable Channel)
- **Dart SDK**: 3.10.8+
- **Target Platforms**: Web, Mobile (iOS/Android)

## 🌟 Key Features

### 1. Cross-Platform & Responsive Design

- Built to run seamlessly on both **Web** and **Mobile** platforms.
- Features a clean, medical-themed UI (Cyan-based) with a responsive layout.
- Desktop layout utilizes a persistent sidebar, while the mobile layout adapts with a sleek bottom-sheet interface for category navigation.

### 2. Centralized Dashboard

- **Category Management**: Groups applications and systems into intuitive categories.
- **System Launching**: Provides system cards that allow users to launch linked applications. Supports cross-platform URL launching (opening in new browser tabs for Web).

### 3. Secure Authentication & Session Persistence

- Secure login mechanism integrating with backend SSO endpoints.
- Implements session persistence using `flutter_secure_storage` to securely keep user tokens.
- Automatic token validation and redirection upon app initialization via a dedicated `AuthWrapper`.

### 4. State Management

- Utilizes the **Provider** package (`AuthProvider`, `DashboardProvider`) for efficient, decoupled state management and reactive UI updates.

## 🚀 Getting Started

### Prerequisites

This project requires **Flutter 3.41.6** or higher with **Dart SDK 3.10.8+**.

#### For New Flutter Developers

If you haven't installed Flutter yet, follow these steps:

#### 1️⃣ Install Flutter SDK

Choose your operating system:

<details>
<summary><strong>Windows</strong></summary>

1. **Download Flutter SDK**:
   - Visit [Flutter Official Site](https://docs.flutter.dev/get-started/install/windows)
   - Download the latest stable release (zip file)

2. **Extract the zip file**:
   - Extract to a desired location (e.g., `C:\src\flutter`)
   - ⚠️ Avoid installing in directories that require elevated privileges (like `C:\Program Files`)

3. **Update PATH environment variable**:
   - Search for "Environment Variables" in Windows Search
   - Add the full path to `flutter\bin` (e.g., `C:\src\flutter\bin`)

4. **Install Git for Windows**:
   - Download from [git-scm.com](https://git-scm.com/download/win)
   - Flutter requires Git to manage dependencies

5. **Verify installation**:
   ```bash
   flutter doctor
   ```

6. **Install additional tools** (based on `flutter doctor` output):
   - **Visual Studio** (for Windows desktop development)
   - **Android Studio** (for Android development)
   - **Chrome** (for web development)

</details>

<details>
<summary><strong>macOS</strong></summary>

1. **Download Flutter SDK**:
   - Visit [Flutter Official Site](https://docs.flutter.dev/get-started/install/macos)
   - Download the latest stable release for your chip (Intel/Apple Silicon)

2. **Extract the file**:
   ```bash
   cd ~/development
   unzip ~/Downloads/flutter_macos_*.zip
   ```

3. **Update PATH**:
   Add this line to your `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
   Then reload:
   ```bash
   source ~/.zshrc  # or source ~/.bash_profile
   ```

4. **Install Xcode** (for iOS development):
   - Download from Mac App Store
   - Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
   - Accept license: `sudo xcodebuild -runFirstLaunch`

5. **Install CocoaPods**:
   ```bash
   sudo gem install cocoapods
   ```

6. **Verify installation**:
   ```bash
   flutter doctor
   ```

</details>

<details>
<summary><strong>Linux</strong></summary>

1. **Install required dependencies**:
   ```bash
   sudo apt-get update
   sudo apt-get install curl git unzip xz-utils zip libglu1-mesa
   ```

2. **Download Flutter SDK**:
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_*-stable.tar.xz
   tar xf flutter_linux_*-stable.tar.xz
   ```

3. **Update PATH**:
   Add to `~/.bashrc` or `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
   Then reload:
   ```bash
   source ~/.bashrc
   ```

4. **Install Chrome** (for web development):
   ```bash
   sudo apt-get install chromium-browser
   ```

5. **Verify installation**:
   ```bash
   flutter doctor
   ```

</details>

#### 2️⃣ Verify Flutter Installation

Run the following command to check your Flutter setup:

```bash
flutter doctor
```

This will show you what tools are installed and what's missing. Address any issues marked with ❌ or ⚠️.

#### 3️⃣ Configure Flutter for Web Development

Since this project runs on web, enable web support:

```bash
flutter config --enable-web
```

Verify web is available:

```bash
flutter devices
```

You should see Chrome listed as an available device.

#### 4️⃣ IDE Setup (Optional but Recommended)

Install one of these IDEs with Flutter plugins:

- **Visual Studio Code** + Flutter extension
- **Android Studio** + Flutter plugin
- **IntelliJ IDEA** + Flutter plugin

### Installation & Running the Project

Once Flutter is installed and configured:

1. **Clone the repository** (if you haven't):

   ```bash
   git clone <repository-url>
   cd frontend
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the application locally**:

   For the best development experience with the web version, run it on port **8083**:

   ```bash
   flutter run -d web --web-port 8083
   ```

   Alternative commands:
   ```bash
   # Run on Chrome (default web browser)
   flutter run -d chrome

   # Build for web production
   flutter build web

   # Run on connected mobile device
   flutter run
   ```

### Troubleshooting

<details>
<summary><strong>Common Issues</strong></summary>

**Issue: "flutter: command not found"**
- Solution: Make sure Flutter's bin directory is in your PATH and restart your terminal.

**Issue: "No devices available"**
- Solution: Run `flutter doctor` to see what's missing. For web, ensure Chrome is installed.

**Issue: Dependencies conflict**
- Solution: Try deleting `pubspec.lock` and running `flutter pub get` again.

**Issue: "Waiting for another flutter command to release the startup lock"**
- Solution: Delete the lock file:
  ```bash
  rm -rf flutter-sdk-path/bin/cache/lockfile
  ```

**Issue: Build fails on web**
- Solution: Clear Flutter cache and rebuild:
  ```bash
  flutter clean
  flutter pub get
  flutter run -d web --web-port 8083
  ```

</details>

### Quick Commands Reference

```bash
# Check Flutter version
flutter --version

# Update Flutter to latest
flutter upgrade

# List all available devices
flutter devices

# Clean build files
flutter clean

# Analyze code for issues
flutter analyze

# Format code
flutter format .

# Run tests
flutter test
```

## 🛠 Project Structure

- `lib/core/` - Core configurations, constants, and design system elements (e.g., `AppColors`).
- `lib/interface/` - UI components divided by platform (`web/`, `mobile/`, `shared/`) and specific feature screens.
- `lib/models/` - Data classes representing backend responses.
- `lib/providers/` - State management controllers handling business logic and API interactions.

## 📝 Important Notes for Developers

- **Design System Consistency**: Maintain the application's clean, glassmorphism-inspired medical UI aesthetics when adding new components. Use the variables defined in `AppColors`.
- **Environment Variables**: Never commit sensitive environment files (`.env`) or any AI agent workspaces (`./.agent/`) to the repository.
