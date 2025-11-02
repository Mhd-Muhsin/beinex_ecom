plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.beinex_ecom"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        // you were using Java 11 — keep it
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        // enable core library desugaring required by some AARs (e.g. flutter_local_notifications)
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.beinex_ecom"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Add dependencies at module level
dependencies {
    // keep any existing implementation(...) or other dependencies you already have here

    // core library desugaring library — required when isCoreLibraryDesugaringEnabled = true
    // recommended version: 1.1.5 (works with many AGP/Kotlin setups). If unresolved, try the `add(...)` form below.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")

    // If your Gradle/Kotlin DSL complains about `coreLibraryDesugaring` symbol, replace the above line with:
    // add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:1.1.5")
}
