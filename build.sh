#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web support
flutter config --enable-web

# Verify Flutter installation
flutter doctor

# Get dependencies
flutter pub get

# Build the Flutter web project
flutter build web
