# Avatar Assets

Dit zijn de avatar afbeeldingen voor het customization systeem.

## 📂 Directory Structuur

```
avatar/
├── bodies/        # Basis lichaam (1 variant)
├── shirts/        # T-shirts en bovenkledij (5+ varianten)
├── pants/         # Broeken en onderkledij (4+ varianten)
├── hair/          # Haarstijlen (5+ varianten)
└── accessories/   # Brillen, hoeden, etc (6+ varianten)
```

## 🎨 Asset Specificaties

### Afmetingen
- **Resolutie:** 512×512px (voor retina displays)
- **Formaat:** PNG-24 met alpha transparantie
- **Achtergrond:** Volledig transparant

### Kleuren
- Maak assets in **grijs/wit** voor maximale flexibiliteit
- De app past kleuren toe via ColorFilter
- Zo kun je 1 design in meerdere kleuren aanbieden

### Naamgeving
```
{category}_{id}.png

Voorbeelden:
- shirt_0.png, shirt_1.png, shirt_2.png
- pants_0.png, pants_1.png
- hair_0.png, hair_1.png
- accessory_0.png, accessory_1.png
```

### Laag Volgorde (Z-Index)
De app stapelt lagen in deze volgorde (van achter naar voor):
1. Body (lichaam)
2. Pants (broek)
3. Shirt (bovenkledij)
4. Hair (haar)
5. Accessories (accessoires)

## 📝 Asset Checklist

### Bodies (1 variant nodig)
- [ ] body_0.png - Basis lichaam met hoofd, armen, benen

### Shirts (5 varianten aanbevolen)
- [ ] shirt_0.png - T-shirt kort
- [ ] shirt_1.png - T-shirt lange mouwen
- [ ] shirt_2.png - Hoodie
- [ ] shirt_3.png - Polo
- [ ] shirt_4.png - Trui/sweater

### Pants (4 varianten aanbevolen)
- [ ] pants_0.png - Lange broek/jeans
- [ ] pants_1.png - Korte broek/shorts
- [ ] pants_2.png - Legging
- [ ] pants_3.png - Joggingbroek

### Hair (5 varianten aanbevolen)
- [ ] hair_0.png - Kort haar
- [ ] hair_1.png - Lang haar
- [ ] hair_2.png - Krullen
- [ ] hair_3.png - Paardenstaart
- [ ] hair_4.png - Kaal (transparant, alleen hoofdvorm)

### Accessories (6+ varianten aanbevolen)
- [ ] accessory_0.png - Bril style 1
- [ ] accessory_1.png - Bril style 2
- [ ] accessory_2.png - Hoed/pet
- [ ] accessory_3.png - Cap
- [ ] accessory_4.png - Oorbellen
- [ ] accessory_5.png - Ketting

## 🎯 Tijdelijke Placeholder

Totdat een designer de echte assets maakt, gebruikt de app:
- **CustomPaint drawings** als fallback
- Simple gekleurde vormen
- Functioneel maar niet mooi

## 🚀 Implementatie

Zodra de PNG's klaar zijn:
1. Plaats ze in de juiste directories
2. Volg de naamgevingsconventie
3. Update `pubspec.yaml` indien nodig
4. Test in de app

## 📞 Contact

Voor vragen over de asset specificaties of design guidelines:
- Neem contact op met het development team
- Zie `AVATAR_IMPLEMENTATION.md` voor technische details
