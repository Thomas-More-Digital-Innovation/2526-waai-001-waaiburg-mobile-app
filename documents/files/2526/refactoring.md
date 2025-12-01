# Waaiburg app

## Analyse

### Achtergrond

De app is in 22-23 door studenten van DI gemaakt met het Flutter framework.
De app is voor de VZW De Waaiburg gemaakt.

### Flutter

Flutter is een krachtig framework gemaakt door Google. Het gebruikt de dart programmeer taal, een dynamisch typed taal vergelijkbaar met C# en Java. Het is ontworpen om cross-platform compatibele apps te maken. Het is dus geschikt voor het maken van apps voor iOS en Android maar ook voor webapps en desktop-apps (Windows, Linux, macOS).
Dart heeft een JIT & AOT compiler en is dus snel en efficiënt. Het biedt geen native performance, maar sneller dan React Native in meeste opzichten.

## Performance analyse

### Caching

Er wordt absoluut geen gebruik gemaakt van caching. Elke pagina die je (opnieuw) opent stuurt een request naar een API, zelfs zo goed als statische content. Foto's worden ook niet gecached. Dit zorgt voor een trage ervaring en onnodig dataverbruik. De api zou heel makkelijk te belasten zijn met meerdere concurrent gebruikers.

### API

De volledige info content wordt gequeried met 1 [endpoint](https://dewaaiburgapp.eu/api/infoContent), elke keer dat er specifieke content wordt opgehaald wordt alle content aan de API gevraagd en gefilterd in de app. Er is geen manier om een individuele "infoContent" op te vragen.
Nieuws & info pagina's worden allebei in de zelfde endpoint opgeslagen. Er is geen manier om specifieke nieuws of info content te vragen.
De totale grote die opgevraagd word voor elke pagina is 176.67kB (momenteel). Dit bestaat uit alle statische info & een test nieuws artikel. Mochten er 10 nieuws artikels, zou de grote al snel groeien. Dit wordt dus voor elke pagina opgevraagd, dus mocht je elke pagina willen lezen zit je aan de 30 - 50 API calls, wat niet ideaal is voor mensen met een mobiel netwerk.

## Refactoring suggesties

[ ] Cache statische content en foto's
[ ] Update API om id parameter toe te voegen aan infoContent endpoint
[ ] InfoContent endpoint endpoint zonder id parameter standaard niet de content mee te geven, aangezien content de meeste data bevat. Deze zou dan opgevraagd worden met de parameter.
