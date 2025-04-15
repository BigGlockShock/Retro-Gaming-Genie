# Retro-Gaming-Genie
## Was ist die Idee?

Retro-Gaming Genie ist eine interaktive Web-App, mit der Nutzer:innen die besten Retro-Spiele für verschiedene Plattformen und Genres entdecken können. Mithilfe der RAWG API werden Top-Titel angezeigt, und ein eingebundener Chatbot auf Basis von ChatGPT beantwortet Fragen zu den Spielen.
## Welchen Mehrwert bietet das?

- 🎮 **Inspiration für Retro-Fans** – neue (alte) Spiele entdecken für nostalgische Spielesessions.
- 🤖 **Interaktives Erlebnis** – GPT-Integration erlaubt persönliche Spielberatung auf Knopfdruck.
- 📚 **Informationsquelle** – bündelt relevante Infos zu Spielen übersichtlich in einem Interface.
- 🔍 **Filtermöglichkeiten** – Nutzer:innen finden Spiele gezielt nach Plattform, Genre und Beliebtheit.

## Anforderungen
### Funktionale Anforderungen
- Auswahl einer Plattform (z. B. SNES, Sega Genesis, PS1)
- Optionale Eingabe eines Genres (z. B. RPG, Action, Platformer)
- Angabe der gewünschten Anzahl Top-Titel (z. B. Top 10)
- Anzeige einer Rangliste mit Titel, Cover, Kurzbeschreibung und Jahr
- Auswahl eines Spiels öffnet Detailansicht mit ChatGPT-basiertem Chat
- Nutzer:innen können dem „Genie“ Fragen zum Spiel stellen

## Client und Server
### Client (Frontend)
- Erstellt mit **React + TypeScript**
- Bietet UI zur Plattform- und Genre-Auswahl
- Stellt Rangliste dar und bietet Chat-Interface
- Kommuniziert mit eigenem Backend und ChatGPT-API

### Server (Backend)
- Node.js/Express oder leichtgewichtiges Setup (z. B. Vite + Proxy)
- Stellt API-Endpunkte bereit für:
  - Kommunikation mit der **RAWG API** (Spieledaten)
  - Weiterleitung von Nutzeranfragen an **OpenAI API** (ChatGPT)

## Technologien

- **Frontend:**
  - React (mit TypeScript)
 
- **Backend:**
  - Node.js + Express oder eigenes API-Gateway
  - API-Integration mit:
    - **RAWG API** für Spieledaten
    - **OpenAI GPT API** für interaktive Spielberatung

- **Weitere Tools:**
  - Git & GitHub für Versionskontrolle
  - Postman zur API-Erprobung
  - Vite oder Create React App für Projektaufbau
