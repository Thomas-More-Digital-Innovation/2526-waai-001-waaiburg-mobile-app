# Avatar Systeem - Prototype Implementatie

## 📋 Overzicht

Dit is een werkend prototype van een aanpasbaar avatar systeem voor de Waaiburg mobile app. Gebruikers kunnen hun eigen "mannetje" aanpassen met verschillende kledingstijlen, kleuren en accessoires.

## ✨ Functies

### Aanpasbare Elementen:
- **Lichaam** - 4 huidskleuren
- **T-shirt** - 2 stijlen (kort/lang) + 8 kleuren
- **Broek** - 2 stijlen (lang/kort) + 6 kleuren  
- **Haar** - 3 stijlen (kort/lang/kaal) + 6 kleuren
- **Extra** - Accessoires (bril, hoed, of geen)

## 🗂️ Bestandsstructuur

```
lib/
├── model/
│   └── avatar_configuration.dart          # Data model voor avatar opslag
├── screens/
│   └── avatar/
│       ├── avatar_customization_screen.dart  # Scherm om avatar aan te passen
│       └── widgets/
│           └── avatar_widget.dart         # Herbruikbare avatar display widget
├── screens/
│   └── tree/
│       └── tree_home.dart                 # Geïntegreerd met avatar widget
└── config/
    └── routes.dart                        # Route configuratie
```

## 🎮 Gebruik

### Voor Gebruikers:

1. **Login** in de app
2. Ga naar **"MIJN AVATAR"** vanaf het home scherm
3. Kies een categorie (Lichaam, T-shirt, Broek, Haar, Extra)
4. Selecteer gewenste stijl en kleur
5. Klik op **"Opslaan"**
6. Je avatar verschijnt nu in de **Levensboom** scherm (rechtsonder)
7. Klik op de avatar in de boom om opnieuw aan te passen

### Navigatie:

- **Home → Mijn Avatar** - Direct naar customization scherm
- **Levensboom → Avatar (klik)** - Aanpassen vanuit boom scherm
- **Customization → Opslaan** - Slaat configuratie lokaal op

## 💾 Data Opslag

Avatar configuratie wordt lokaal opgeslagen in `SharedPreferences` met de key `'avatar_config'`.

**Voorbeeld JSON:**
```json
{
  "bodyType": 0,
  "shirtId": 1,
  "pantsId": 0,
  "hairId": 2,
  "accessoryId": 0,
  "skinColor": "#FFD7B5",
  "shirtColor": "#E74C3C",
  "pantsColor": "#2C3E50",
  "hairColor": "#5D4037"
}
```

## 🎨 Implementatie Details

### Avatar Widget

De `AvatarWidget` gebruikt een `Stack` architectuur om verschillende lagen te combineren:

1. **Body layer** (basis lichaam)
2. **Pants layer** (broek)
3. **Shirt layer** (t-shirt)
4. **Hair layer** (haar)
5. **Accessory layer** (bril/hoed - optioneel)

### Custom Painter

Momenteel gebruikt het systeem `CustomPaint` en `Canvas` API om de avatar te tekenen met eenvoudige vormen. Dit is ideaal voor prototyping.

**Voordelen huidige aanpak:**
- ✅ Volledig aanpasbaar met kleuren
- ✅ Geen externe assets nodig
- ✅ Lichtgewicht en snel
- ✅ Werkt on-the-fly

## 🚀 Toekomstige Uitbreidingen

### Fase 2 - Productie versie:

1. **PNG Assets** - Vervang CustomPainter met echte afbeeldingen
   ```
   assets/avatar/
   ├── body/body_1.png, body_2.png
   ├── shirts/shirt_1.png, shirt_2.png
   ├── pants/pants_1.png, pants_2.png
   └── hair/hair_1.png, hair_2.png
   ```

2. **Meer Opties**
   - Meer haarstijlen (staart, krullen, dreadlocks)
   - Gezichtskenmerken (sproeten, piercings)
   - Meer accessoires (sjaals, oorbellen, kettingen)
   - Schoenen
   - Achtergronden

3. **API Integratie**
   - Opslaan in database via backend
   - Synchroniseren tussen devices
   - Delen met anderen

4. **Animaties**
   - Lottie animaties voor bewegende avatars
   - Expressies (lachen, huilen, verrast)
   - Gebaren (zwaaien, duim omhoog)

5. **Social Features**
   - Avatar gallerij van andere gebruikers
   - Unlock systeem (verdien nieuwe items)
   - Achievements/badges

## 🔧 Voor Ontwikkelaars

### Nieuwe kleur toevoegen:

```dart
// In avatar_customization_screen.dart
final List<Color> _shirtColors = [
  // ... bestaande kleuren
  const Color(0xFFYOURCOLOR), // Voeg toe
];
```

### Nieuwe stijl toevoegen:

```dart
// In avatar_widget.dart - AvatarPartPainter class
void _drawShirt(Canvas canvas, Size size, Offset center, Paint paint, int style) {
  if (style == 0) {
    // Bestaande T-shirt
  } else if (style == 1) {
    // Bestaande lange mouwen
  } else if (style == 2) {
    // NIEUWE stijl hier implementeren
  }
}
```

### Nieuwe categorie toevoegen:

1. Voeg veld toe aan `AvatarConfiguration` model
2. Update `copyWith`, `toJson`, `fromJson` methods
3. Voeg categorie toe aan `_categories` lijst
4. Implementeer rendering in `AvatarPartPainter`
5. Voeg UI toe in `_buildOptionsGrid()`

## 📱 Testing

Test de volgende scenario's:

- [ ] Avatar aanmaken zonder login (moet hidden zijn)
- [ ] Avatar aanmaken met login
- [ ] Verschillende combinaties van stijl en kleur
- [ ] Opslaan en herladen (herstart app)
- [ ] Navigatie tussen schermen
- [ ] Avatar zichtbaar in levensboom
- [ ] Klikken op avatar opent customization
- [ ] Alle accessoires werken
- [ ] Geen accessoire selecteren werkt

## 🐛 Known Issues (Prototype)

- Avatar heeft geen gezichtsdetails wanneer accessoire geselecteerd is (overlap)
- Sommige kleur combinaties kunnen minder goed zichtbaar zijn
- Geen undo/reset functionaliteit
- Geen preview tijdens selectie in grid

## 📝 Licentie

Onderdeel van Waaiburg Mobile App - Thomas More Digital Innovation

---

**Gemaakt op:** December 10, 2025  
**Prototype Versie:** 1.0  
**Status:** Werkend prototype, klaar voor testing
