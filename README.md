# Job Aggregator - Docker Compose WebApp

Eine moderne **WebApp zur automatischen Jobsuche über mehrere Jobbörsen** mit täglichen automatisierten Abläufen, konfigurierbarem Zeitplan und benutzerfreundlicher Oberfläche.

## 🎯 Features

✅ **Automatische tägliche Jobsuche** - Konfiguriere Uhrzeit, Titel, Ort und Radius
✅ **Multi-Source Job Aggregation** - Arbeitnow API, erweiterbar auf Indeed, LinkedIn, StepStone
✅ **Persistente Datenspeicherung** - PostgreSQL Datenbank für Job-Historie
✅ **Intelligente Duplikatvermeidung** - Gleiche Jobs werden nicht doppelt gespeichert
✅ **Responsive Web UI** - React Frontend mit modernem Design
✅ **REST API** - Vollständige FastAPI Backend mit Swagger Dokumentation
✅ **Docker Compose** - One-Command Deployment mit allen Services
✅ **Hintergrund-Scheduler** - APScheduler für zuverlässige zeitgesteuerte Ausführung
✅ **Benutzerfreundliche Konfiguration** - Einfach Suchparameter anpassen

## 🏗️ Architektur

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Compose                           │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐    │
│  │   Frontend   │   │   Backend    │   │  PostgreSQL  │    │
│  │   (React)    │   │ (FastAPI)    │   │   (DB)       │    │
│  │   :3000      │   │  :8000       │   │   :5432      │    │
│  └──────────────┘   └──────────────┘   └──────────────┘    │
│         │                   │                   │            │
│         └───────────────────┴───────────────────┘            │
├─────────────────────────────────────────────────────────────┤
│  APScheduler (Automatic Daily Job Searches)                 │
├─────────────────────────────────────────────────────────────┤
│  Job APIs (Arbeitnow, Indeed, LinkedIn, etc.)               │
└─────────────────────────────────────────────────────────────┘
