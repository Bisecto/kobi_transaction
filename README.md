# 💸 Kobi Transaction

**Kobi Transaction** is a Flutter application for managing and displaying transaction activities using the BLoC pattern. The app demonstrates clean architecture, reusable components, and a well-organized project structure suitable for scaling.

---

## 🚀 Features

- Display and filter transaction history
- Modular widget components
- Clean architecture with BLoC
- Reusable navigation and utilities
- Custom theming and assets

---

## 📦 Project Structure

```plaintext
lib/
├── bloc/
│   └── transaction_bloc/
│       ├── transaction_bloc.dart
│       ├── transaction_event.dart
│       └── transaction_state.dart
│
├── model/
│   └── transaction_model.dart
│
├── res/
│   ├── apis.dart
│   ├── app_colors.dart
│   ├── app_enums.dart
│   ├── app_icons.dart
│   └── app_strings.dart
│
├── utils/
│   ├── app_navigator.dart
│   ├── app_utils.dart
│   └── custom_route.dart
│
├── views/
│   ├── app_screens/
│   │   ├── app_widgets/
│   │   │   ├── filter_widget.dart
│   │   │   ├── not_found_widget.dart
│   │   │   └── transaction_container.dart
│   │   └── transaction_activity.dart
│   │
│   └── widget.dart/
│       ├── app_custom_text.dart
│       ├── app_spacer.dart
│       ├── form_button.dart
│       └── form_input.dart
│
└── main.dart


![Trabsaction Demo](assets/transactions.gif)
