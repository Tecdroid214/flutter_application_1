# 🐻Animated Bear Login

### Welcome to the Animated Bear Login project

__Name:__ David Moisés Gamboa Cel 

__Teacher:__ Rodrigo Fidel Gaxiola Sosa

__subject:__ Graficación



## ¿Qué es Rive? 🐻

**Rive** es una herramienta de diseño y animación en tiempo real.

Piensa en Rive no como un video o un GIF, sino como un "mini-programa" de animación. Tú creas tu personaje y sus movimientos en el editor de Rive, y la aplicación (como tu app de Flutter) lo ejecuta en vivo.

* **Es Interactivo:** Puedes controlarlo con código (como haces en tu app).
* **Es Vectorial:** No pierde calidad si lo haces grande o pequeño.
* **Es Ligero:** Los archivos (`.riv`) son muy pequeños, ideales para apps móviles y web.
* **Multiplataforma:** Funciona en Flutter, Web (JavaScript), React, C++, etc.

---

## ¿Qué es una State Machine (Máquina de Estados)? 🧠

La **State Machine (Máquina de Estados)** es el **cerebro** que controla *cómo* y *cuándo* se reproduce una animación en Rive.

Es un diagrama de flujo visual que tú creas en el editor de Rive para definir la lógica. En lugar de solo "reproducir de principio a fin", le das reglas:

* **Estados:** Son las animaciones (ej. "Oso\_idle", "Oso\_tapando\_ojos", "Oso\_feliz").
* **Entradas (Inputs):** Son los "interruptores" que tu código de Flutter puede activar. En tu código, `isChecking`, `isHandsUp`, y `trigSuccess` son Entradas.
* **Transiciones:** Son las flechas que conectan los estados. Tú defines: "Si la entrada `isHandsUp` se vuelve `true`, pasa del estado 'Oso\_idle' al estado 'Oso\_tapando\_ojos'".

En resumen, la Máquina de Estados es el puente que conecta tu código de Flutter con las animaciones de Rive, permitiendo la interactividad.



---

## Tecnologías Relacionadas

* **Editor Rive:** Es la aplicación (web o de escritorio) donde diseñas y animas. Es la competencia de herramientas como Lottie (que usa Adobe After Effects).
* **Flutter (Dart):** Es el *framework* de tu app. Usas el paquete `package:rive/rive.dart` para poder mostrar y controlar los archivos `.riv`.
* **Runtimes (Tiempos de ejecución):** Son las librerías de código (como la de Flutter, la de JavaScript, la de C++) que saben cómo leer un archivo `.riv` y dibujarlo en la pantalla.



## ⭐Features

- 👀 __Eye-tracking:__ The bear follows your email inputs with its eyes.
- 🔒 __Privacy mode:__ The bear covers its eyes when typing the password.
- 😁 __Happy bear:__ Appears when login credentials are correct __(David@gmail.com / @Zombiesd214)__.
- 😢 __Sad bear:__ Apperars when login credentials are incorrect.
- Smooth animations powered by __Rive__.

## 🛠️Requirements

- Flutter 3.35.2
- Dart 3.9.0
- Rive Package

```yaml
dependencies:
  flutter:
    sdk: flutter
  rive: ^0.13.20
```

Rive animation file: assets/animated_login_character.riv with state machine Login Machine

## 🚀Installation

1- Clone the repository:
```
https://github.com/Tecdroid214/flutter_application_1/edit/main/README.md
```

2- Navigate to the project folder:
```
C:\Users\david\OneDrive\Desktop\Aprendiendo_Flutter\Flutter_Windows\flutter_application_1
```

3- Install dependencies:
````
name: flutter_application_1
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using flutter pub publish. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.6.1

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running flutter pub upgrade --major-versions. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run flutter pub outdated.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  rive: ^0.13.20

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the analysis_options.yaml file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^5.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/animated_login_character.riv
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
````

4- Run the project

<img width="769" height="923" alt="image" src="https://github.com/user-attachments/assets/622d0c4e-7ab8-49d7-8b70-722cd51554f5" />


## 🎮 Usage

Enter your email 

The bear will follow your typing with its eyes

Enter your password

The bear automatically covers its eyes

Press Login

✅ correct credentials __(David@gmail.com / @Zombiesd214)__ -> Bear becomes happy

❌ Wrong credentials -> Bear becomes sad


## 📂 Project Structure

````
lib/
  main.dart                         # Entry point
  login_screen.dart                 # Login screen with Rive animatic
assets/
  animated_login_character.riv      # Bear animation file
pubspec.yaml                        # Dependencies and Flutter config
````

## 🎨DEMO:
<img width="770" height="903" alt="image" src="https://github.com/user-attachments/assets/d5590e0d-191f-4173-94fc-12f79296a27b" />
(https://youtube.com/shorts/R29p-7g3KzA?feature=share)



## ⚙️Creador de la animación

Rive animation used in this project: https://rive.app/marketplace/3645-7621-remix-of-login-machine/





