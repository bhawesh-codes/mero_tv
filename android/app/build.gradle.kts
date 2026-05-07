// Source - https://stackoverflow.com/a/79753042
// Posted by Omri Developer
// Retrieved 2026-05-07, License - CC BY-SA 4.0

import java.util.Properties
import java.io.FileInputStream
import com.android.build.gradle.internal.api.ApkVariantOutputImpl
import java.text.SimpleDateFormat
import java.util.Date

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.bhawesh.mero_tv"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.bhawesh.mero_tv"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
        debug {
            manifestPlaceholders["crashlyticsCollectionEnabled"] = "true"
        }
    }

    // ✅ THIS IS THE WORKING SOLUTION - Cast to ApkVariantOutputImpl
    applicationVariants.all {
        outputs.all {
            if (this is ApkVariantOutputImpl) {
                val appName = "mero_tv"
                val date = SimpleDateFormat("yyyy_MM_dd").format(Date())
                outputFileName = "${appName}_${date}.apk"
                println("✅ APK will be named: ${outputFileName}")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.material:material:1.12.0")
}