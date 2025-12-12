# 🎨 Avatar Assets Design Specificaties

## Voor Designers

Deze gids helpt je bij het maken van avatar assets voor de Waaiburg mobile app.

## 📐 Technische Specificaties

### Afmetingen & Formaat
- **Resolutie:** 512×512 pixels (voor retina displays)
- **Formaat:** PNG-24
- **Alpha channel:** Ja (transparante achtergrond vereist)
- **Kleurruimte:** sRGB
- **Bestandsgrootte:** Probeer onder 50KB per asset te blijven (geoptimaliseerd)

### Canvas Layout
```
┌─────────────────────┐
│                     │ 512px
│                     │
│      Avatar         │
│      Centered       │
│                     │
│                     │
└─────────────────────┘
      512px
```

## 🎨 Kleur & Stijl

### Basis Kleur
Maak alle assets in **grijs/wit** zodat de app dynamisch kleuren kan toepassen.

**Aanbevolen grijstinten:**
- Licht grijs: `#CCCCCC` (voor highlights)
- Middel grijs: `#999999` (basis kleur)
- Donker grijs: `#666666` (voor schaduwen)

### Stijl Guidelines
- **Eenvoudig en duidelijk** - Geen overmatige details
- **Vlakke stijl** (flat design) of lichte 3D effecten
- **Vriendelijk en toegankelijk** - Voor jongeren én volwassenen
- **Herkenbare vormen** - Direct zichtbaar wat het is
- **Consistente lijndikte** - Tussen alle assets

## 📂 Benodigde Assets

### 1. Bodies (1 bestand)
**Bestand:** `body_0.png`

**Bevat:**
- Hoofd (rond/ovaal)
- Romp (torso)
- Armen (beide zijden)
- Benen (beide)
- Basis gezicht (ogen, neus, mond - simpel)

**Let op:**
- Maak dit in een neutrale huidkleur (licht grijs)
- App past huidskleuren toe via filter
- Geen kleding! (komt in aparte lagen)

### 2. Shirts (5 bestanden)

| Bestand | Beschrijving | Details |
|---------|-------------|---------|
| `shirt_0.png` | T-shirt kort | Basis ronde hals, korte mouwen |
| `shirt_1.png` | T-shirt lang | Lange mouwen |
| `shirt_2.png` | Hoodie | Met capuchon |
| `shirt_3.png` | Polo | Kraag met knoopjes |
| `shirt_4.png` | Trui/Sweater | Warme trui met manchetten |

**Let op:**
- Bedekt alleen romp + armen
- Laat ruimte voor hals/hoofd
- Zichtbaar over pants layer

### 3. Pants (4 bestanden)

| Bestand | Beschrijving | Details |
|---------|-------------|---------|
| `pants_0.png` | Lange broek | Jeans stijl, tot enkels |
| `pants_1.png` | Korte broek | Shorts, tot knieën |
| `pants_2.png` | Legging | Strakke sportbroek |
| `pants_3.png` | Joggingbroek | Casual sportbroek met manchetten |

**Let op:**
- Bedekt alleen benen (geen romp)
- Begint bij middel/heup
- Onder shirt layer

### 4. Hair (5 bestanden)

| Bestand | Beschrijving | Details |
|---------|-------------|---------|
| `hair_0.png` | Kort haar | Basis kort kapsel |
| `hair_1.png` | Lang haar | Tot schouders |
| `hair_2.png` | Krullen | Krullend haar (kort/middel) |
| `hair_3.png` | Paardenstaart | Gebonden naar achteren |
| `hair_4.png` | Kaal | Volledig transparant (optioneel licht hoofdvorm) |

**Let op:**
- Bedekt alleen bovenkant hoofd
- Laat gezicht vrij
- Kan over shoulders vallen (lang haar)
- App past haarkleuren toe via filter

### 5. Accessories (6 bestanden)

| Bestand | Beschrijving | Details |
|---------|-------------|---------|
| `accessory_0.png` | Bril stijl 1 | Ronde brillenglazen |
| `accessory_1.png` | Bril stijl 2 | Rechthoekige/vierkante bril |
| `accessory_2.png` | Hoed | Klassieke hoed met rand |
| `accessory_3.png` | Cap/Pet | Baseball cap |
| `accessory_4.png` | Oorbellen | Kleine cirkel oorbellen |
| `accessory_5.png` | Ketting | Simpele ketting met hanger |

**Let op:**
- Geen grijsfilter! Gebruik echte kleuren
- Bril: zwart montuur, lichtgrijze glazen
- Hoeden: vaste kleuren die er goed uitzien
- Sieraden: goud/zilver kleuren

## 🔄 Layer Volgorde (Z-Index)

Van achter naar voor (zoals de app ze stapelt):

```
┌─────────────────────┐
│  5. Accessories     │ ← Bovenste laag (bril, hoed)
│  4. Hair            │ ← Haar
│  3. Shirt           │ ← T-shirt/hoodie
│  2. Pants           │ ← Broek
│  1. Body            │ ← Basis lichaam
└─────────────────────┘
     (Achtergrond = transparant)
```

## 💡 Design Tips

### Proportions
```
Hoofd:    20% van hoogte (bovenste gedeelte)
Romp:     35% van hoogte (midden)
Benen:    45% van hoogte (onderste gedeelte)
```

### Overlap Zones
- **Shirt moet pants overlappen** bij middel/heup
- **Haar kan gezicht deels bedekken** (pony)
- **Accessoires over alles heen** (bril, hoed)

### Gezichtsdetails
Houd het simpel:
- Ogen: Simpele cirkels of ovalen
- Neus: Kleine stip of V-vorm
- Mond: Simpele lijn of glimlach
- Wenkbrauwen: Kleine boogjes

## 🛠️ Workflow

### Stap 1: Schets
Maak een schets van het volledige karakter met alle lagen

### Stap 2: Lagen Scheiden
Splits in aparte lagen:
- Body laag
- Pants laag  
- Shirt laag
- Hair laag
- Accessory laag

### Stap 3: Exporteren
Per laag:
1. Maak 512×512 canvas
2. Centreer de laag
3. Export als PNG-24 met transparantie
4. Optimaliseer bestandsgrootte

### Stap 4: Testen
1. Plaats PNG in juiste map
2. Test in app met verschillende kleuren
3. Check overlap met andere lagen

## 📋 Checklist per Asset

- [ ] 512×512 pixels
- [ ] PNG-24 formaat
- [ ] Transparante achtergrond
- [ ] Grijs/wit (behalve accessories)
- [ ] Geen harde randen (gebruik anti-aliasing)
- [ ] Gecentreerd op canvas
- [ ] Getest met kleurfilters
- [ ] Bestandsgrootte < 50KB
- [ ] Juiste naamgeving (bijv. `shirt_0.png`)

## 🎯 Prioriteit

**Fase 1 - Minimaal (MVP):**
- ✅ body_0.png
- ✅ shirt_0.png (T-shirt)
- ✅ pants_0.png (Lange broek)
- ✅ hair_0.png (Kort haar)
- ✅ accessory_0.png (Bril)

**Fase 2 - Volledig:**
- Alle 5 shirts
- Alle 4 broeken
- Alle 5 haarstijlen
- Alle 6 accessoires

## 🖼️ Voorbeelden

### Goed ✅
- Duidelijke vormen
- Mooie rondingen
- Subtiele schaduwen
- Consistente stijl

### Slecht ❌
- Te veel kleine details
- Onleesbaar klein
- Harde pixelranden
- Inconsistente stijl

## 💾 Levering

Lever alle assets aan via:
- GitHub repository: `/code/mobileapp/assets/avatar/`
- Of stuur naar development team

**Mapstructuur:**
```
assets/avatar/
├── bodies/body_0.png
├── shirts/shirt_0.png → shirt_4.png
├── pants/pants_0.png → pants_3.png
├── hair/hair_0.png → hair_4.png
└── accessories/accessory_0.png → accessory_5.png
```

## 📞 Vragen?

Contact development team voor:
- Technische ondersteuning
- Design feedback
- Testen van assets in de app
- Aanvullende specificaties

---

**Succes met designen! 🎨**
