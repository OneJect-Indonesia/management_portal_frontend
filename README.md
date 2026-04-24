# Application Management Portal (Frontend)

A modern, responsive Flutter-based frontend for the Application Management Portal. This application serves as the centralized dashboard for administrative users to access, categorize, and manage various system modules and portals.

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

Ensure you have the following installed on your machine:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Ensure you are on the appropriate stable channel).
- Dart SDK (comes bundled with Flutter).

### Installation & Running the Project

1. **Install dependencies**:

   ```bash
   flutter pub get
   ```

2. **Run the application locally**:
   For the best development experience with the web version, run it on port **8083**.
   ```bash
   flutter run -d web --web-port 8083
   ```

## 🛠 Project Structure

- `lib/core/` - Core configurations, constants, and design system elements (e.g., `AppColors`).
- `lib/interface/` - UI components divided by platform (`web/`, `mobile/`, `shared/`) and specific feature screens.
- `lib/models/` - Data classes representing backend responses.
- `lib/providers/` - State management controllers handling business logic and API interactions.

## 📝 Important Notes for Developers

- **Design System Consistency**: Maintain the application's clean, glassmorphism-inspired medical UI aesthetics when adding new components. Use the variables defined in `AppColors`.
- **Environment Variables**: Never commit sensitive environment files (`.env`) or any AI agent workspaces (`./.agent/`) to the repository.
