# MAD Flutter Work

A collection of practical assignments and projects completed as part of my university Mobile Application Development (MAD) coursework using Flutter and Dart.

This repository documents my weekly coursework, implementation tasks, and learning progress in mobile application development.

## Table of Contents

- [Project Overview](#project-overview)
- [Technologies Used](#technologies-used)
- [Week 7 — Login Form Validation](#week-7--login-form-validation)
- [Week 8 — Landing Page Animations](#week-8--landing-page-animations)
- [Project Structure](#project-structure)
- [How to Run the Project](#how-to-run-the-project)
- [Learning Outcomes](#learning-outcomes)
- [Repository](#repository)

## Project Overview

This repository contains my Mobile Application Development coursework. It demonstrates practical experience in Flutter UI development, form validation, animations, and navigation between application screens.

The current Flutter application includes:

- An animated landing page
- A login page with input validation
- A registration page with validation and password strength feedback
- A personal profile page

The weekly sections below describe the university tasks, their implementation, the files involved, and the concepts learned.

## Technologies Used

- **Flutter** — Framework for cross-platform application development.
- **Dart** — Programming language used to build the application.
- **Material Design** — UI components and design conventions.
- **Android Studio** — Development environment used to develop the project.
- **Git** — Version control system.
- **GitHub** — Platform used to host and manage the source code.

---

## Week 7 — Login Form Validation

### Overview

During Week 7 of my Mobile Application Development coursework, I worked on a login form validation task. The objective was to understand how to collect user input, validate form fields, provide feedback, and navigate between screens in a Flutter application.

### What Was Done?

A login interface was developed with email and password fields. Validation rules were implemented to check the entered information before allowing the login flow to continue.

The interface also provides navigation to the registration page and includes a placeholder forgot-password action.

### 1. Email Validation

**What:** Implemented validation for the email field.

**How:** The current validation checks that the field is not empty, contains an `@` symbol, and ends with `.com`.

**Why:** To practice validating user input and displaying appropriate feedback when the entered value does not meet the expected requirements.

### 2. Password Validation

**What:** Implemented password validation.

**How:** The current validation checks for a minimum length of eight characters, uppercase and lowercase letters, a digit, and a special character.

**Why:** To understand how multiple validation rules can be used to check password strength and improve input quality.

### 3. Form Feedback

**What:** Added validation feedback and a success message to the login flow.

**How:** The application checks the entered values and displays feedback through the interface.

**Why:** To make the form easier to use and help users understand whether their input meets the implemented requirements.

### 4. Navigation Between Screens

**What:** Connected the login page to the registration and profile pages.

**How:** Flutter navigation is used to move between screens when the relevant actions are performed.

**Why:** To learn how multiple screens can work together as part of a mobile application.

### Where Is the Code?

- `lib/login.dart` — Login interface and validation logic.
- `lib/register.dart` — Registration interface and validation logic.
- `lib/profile.dart` — Personal profile interface.
- `lib/main.dart` — Application entry point.

### Why Was This Task Done?

The purpose of this assignment was to develop practical skills in form handling, input validation, user feedback, and screen navigation. These are fundamental concepts used in many mobile applications.

### Week 7 Learning Outcomes

- Practiced designing forms in Flutter.
- Implemented email and password validation.
- Learned to provide feedback for user input.
- Practiced navigation between application screens.
- Improved understanding of Flutter widgets and Dart logic.

**Note:** The current login and registration flows use local validation and navigation. They do not provide real account authentication through a backend service.

---

## Week 8 — Landing Page Animations

### Overview

During Week 8 of my Mobile Application Development coursework, I worked on a Flutter landing page demonstrating five animation techniques. The task focused on understanding animation behavior, transitions, timing, and control in Flutter.

### What Was Done?

The landing page was developed to demonstrate different animation concepts and explore how animated widgets can improve the appearance and interaction of a user interface.

The five techniques discussed for this task are described below.

### 1. AnimatedContainer

**What:** Used `AnimatedContainer` to demonstrate animated changes in container properties.

**How:** Changes to properties such as size, color, padding, or decoration can transition smoothly over a specified duration.

**Why:** To understand implicit animations and how Flutter can animate property changes without manually managing an animation controller.

### 2. AnimatedCrossFade

**What:** Explored transitions between two widgets using `AnimatedCrossFade`.

**How:** The widget transitions between two children when the selected state changes.

**Why:** To learn how to create smooth transitions between different UI elements.

### 3. AnimatedOpacity

**What:** Explored opacity-based animation using `AnimatedOpacity`.

**How:** A widget's opacity can gradually change between visible and transparent states.

**Why:** To understand fade-in and fade-out effects and how they can be used to control the visibility of interface elements.

### 4. AnimationController

**What:** Explored explicit animation control using `AnimationController`.

**How:** An animation controller can manage animation progress and support actions such as starting, stopping, and repeating an animation.

**Why:** To understand how explicit animations provide more control over animation behavior and timing.

### 5. Tween and CurvedAnimation

**What:** Explored `Tween` and `CurvedAnimation` to define animation values and timing behavior.

**How:** A `Tween` defines the range of values an animation moves between, while `CurvedAnimation` applies a curve to influence how the animation progresses over time.

**Why:** To understand how animation values and curves can be customized to create different visual effects.

### Where Is the Code?

- `lib/Landing.dart` — Landing page UI and animation implementation.
- `lib/main.dart` — Application entry point that opens the landing page.

### Why Was This Task Done?

The purpose of this assignment was to gain practical experience with Flutter animation concepts and understand how animations can make an interface more engaging and visually appealing.

It also helped build a foundation for implementing transitions, animated widgets, and controlled animations in future Flutter projects.

### Week 8 Learning Outcomes

- Explored Flutter's implicit and explicit animation approaches.
- Practiced using animated widgets.
- Learned about transitions between widgets.
- Explored animation controllers and value interpolation.
- Understood how curves influence animation timing.
- Improved practical UI development skills using Flutter and Dart.

---

## Project Structure

```text
week7/
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── assets/
│   └── images/
│       ├── cover.png
│       └── habib3.png
├── lib/
│   ├── main.dart
│   ├── Landing.dart
│   ├── login.dart
│   ├── register.dart
│   └── profile.dart
├── test/
│   └── widget_test.dart
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
├── .gitignore
└── README.md
```

### Main Files and Their Purpose

| File or Folder | Purpose |
|---|---|
| `lib/main.dart` | Initializes the Flutter application. |
| `lib/Landing.dart` | Contains the landing page UI and animation-related code. |
| `lib/login.dart` | Contains the login form and validation logic. |
| `lib/register.dart` | Contains the registration form and validation logic. |
| `lib/profile.dart` | Displays the personal profile interface. |
| `assets/images/` | Stores images used by the application. |
| `pubspec.yaml` | Defines project configuration, dependencies, and assets. |
| `pubspec.lock` | Records resolved package versions. |
| `test/` | Contains automated test files. |

## How to Run the Project

### Prerequisites

Before running the project, make sure you have:

- Flutter SDK installed and configured.
- Dart available through the Flutter SDK.
- Android Studio or another compatible Flutter development environment.
- An Android emulator or a supported device.

### Installation Steps

**1. Clone the repository**

```bash
git clone https://github.com/Muhammad-Habib783/mad_flutter_work.git
```

**2. Open the project directory**

```bash
cd mad_flutter_work
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Check the Flutter environment**

```bash
flutter doctor
```

**5. Run the application**

```bash
flutter run
```

You can also open the project in Android Studio, select an available emulator or connected device, and run the application using the Run button.

## Learning Outcomes

Through this coursework, I have developed practical experience with:

- Flutter application structure and configuration.
- UI development using Flutter widgets.
- Animation techniques and transitions.
- Form validation and input handling.
- Navigation between application screens.
- Organizing Dart files and image assets.
- Managing source code with Git and GitHub.

## Repository

**GitHub:** [mad_flutter_work](https://github.com/Muhammad-Habib783/mad_flutter_work)

This repository serves as a record of my Mobile Application Development coursework and will be updated as I complete additional weekly assignments.

---

*Developed as part of my university Mobile Application Development coursework using Flutter and Dart.*