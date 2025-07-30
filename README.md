# Classpic

## Descripció
Classpic és una aplicació pensada per gestionar fotografies d'alumnes i professors. Està orientada a gestors de centres educatius, permetent organitzar les fotografies de manera senzilla en carpetes per cursos i usuaris.

## Funcionalitats Principals
- Creació i gestió d'usuaris (alumnes i professors) i dels cursos corresponents.
- Presa de fotografies directament des de l'aplicació.
- Emmagatzematge i organització de fotografies per carpetes.
- Registre d'informació addicional dels usuaris (nom, cognoms, NIA, DNI, etc.).

## Tecnologies Utilitzades
- **Frontend:** Flutter (versió 3.27.4)
- **Base de dades local:** Floor + Floor Generator
- **Gestió d'estat:** Riverpod + Riverpod Generator
- **Càmera i imatge:** Camera, Image Picker, Image Cropper, Flutter Image Compress
- **Animacions:** Lottie, Animated Splash Screen
- **Altres utilitats:** Shared Preferences, Path Provider, Permission Handler

## Estat del Projecte
El projecte es troba actualment en fase **MVP**.

## Requisits previs
- Flutter SDK >= **3.6.2**
- Dart SDK (inclòs amb Flutter)
- Dispositiu amb càmera o emulador amb suport de càmera

## Instal·lació i Execució Local
```bash
# Clonar el repositori
git clone https://github.com/SofiaGracia/classpic.git

# Accedir al projecte
cd classpic

# Instal·lar dependències
flutter pub get

# Executar aplicació
flutter run
```

## Roadmap
- Suport multiidioma

## Captures de pantalla
![image info](./screenshots/01menu_no_import.jpeg)
![image info](./screenshots/02menu_import.jpeg)
![image info](./screenshots/03configuration.jpeg)
![image info](./screenshots/04courses.jpeg)
![image info](./screenshots/05user.jpeg)