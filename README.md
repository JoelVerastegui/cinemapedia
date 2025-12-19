# cinemapedia

A new Flutter project.

# dev
1. Rename the '.env.template' file to '.env'
2. Change the environment values
3. Update entities database structure
```
flutter pub run build_runner build
```

# Prod
To change app package name
```
dart run change_app_package_name:main com.new.package.name
```

To change app icon
```
dart run flutter_launcher_icons
```

To change splash background color
´´´
dart run flutter_native_splash:create
´´´

Android AAB
´´´
flutter build appbundle
´´´