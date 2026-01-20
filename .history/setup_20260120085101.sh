#!/bin/bash

# JobS Repository Setup Script
# Dieses Script erstellt alle notwendigen Dateien für das JobS Projekt

set -e

echo "🚀 JobS Repository Setup wird gestartet..."

# Prüfe ob wir im JobS Repo sind
if [ ! -f "docker-compose.yml" ] && [ ! -d ".git" ]; then
    echo "❌ Bitte führe das Script aus dem JobS Repository Root aus"
    exit 1
fi

# Root-Level Dateien
echo "📝 Erstelle Root-Level Dateien..."

# .gitignore
cat > .gitignore << 'EOF'
__pycache__/
*.py[cod]
*.egg-info/
*.db
logs/
node_modules/
npm-debug.log*
.env
.vscode/
.idea/
*.swp
.DS_Store
dist/
build/
*.egg
venv/
ENV/
.pytest_cache/
.coverage
htmlcov/
EOF

# .env.example
cat > .env.example << 'EOF'
FLASK_ENV=production
SECRET_KEY=your-secret-key-change-in-production-12345
DATABASE_URL=sqlite:///database.db

ARBEITSAGENTUR_CLIENT_ID=jobboerse-jobsuche
INDEED_API_KEY=
STEPSTONE_API_KEY=
LINKEDIN_API_KEY=
XING_API_KEY=

LOG_LEVEL=INFO
SCHEDULER_TIMEZONE=Europe/Berlin
REACT_APP_API_BASE_URL=http://localhost:5000/api
EOF

# README.md
cat > README.md << 'EOF'
# JobS - Job Search Automation Platform

🔍 Automatisierte Jobsuche über alle großen Jobbörsen mit Docker Compose.

## 🚀 Quick Start

```bash
# Repository klonen
git clone https://github.com/Nilshh/JobS.git
cd JobS

# Umgebungsvariablen vorbereiten
cp .env.example .env

# Docker starten
docker compose up --build
```

**Zugriff:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000/api
- Health Check: http://localhost:5000/api/health

## ✨ Features

- ✅ **Bundesagentur für Arbeit** - Kostenlos, keine Authentifizierung erforderlich
- 🔐 **Indeed API** - Mit API Key
- 📊 **StepStone API** - Mit Partner API Key
- 💼 **LinkedIn & XING** - Optional
- 🕐 **Tägliche automatische Suche** - Konfigurierbare Zeitpläne
- 📱 **Web-Dashboard** - Modern und responsiv
- 🔗 **REST API** - Vollständig dokumentiert
- 💾 **SQLite Datenbank** - Duplikat-Erkennung
- 🐳 **Docker Compose** - Ein Befehl zum Starten

## 📊 Unterstützte Jobbörsen

| Quelle | API | Authentifizierung | Status |
|--------|-----|------------------|--------|
| Arbeitsagentur | ✅ | Kostenlos | Produktiv |
| Indeed | ✅ | API Key | Produktiv |
| StepStone | ✅ | API Key | Produktiv |
| LinkedIn | ⚠️ | Enterprise API | Optional |
| XING | ⚠️ | OAuth | Optional |

## 📋 Anforderungen

- Docker & Docker Compose
- Git
- ~500MB Festplatte

## 🔧 Konfiguration

### 1. Umgebungsvariablen

```bash
cp .env.example .env
# Bearbeite .env mit deinen API Keys
```

### 2. API Keys beschaffen

**Arbeitsagentur (kostenlos):**
- Öffentliche API, keine Registrierung erforderlich
- Client ID: `jobboerse-jobsuche`

**Indeed API:**
- https://opensource.indeedeng.io/
- Publisher ID erforderlich

**StepStone API:**
- https://partner.stepstone.de/
- Partnerschaft erforderlich

## 🏃 Starten

```bash
# Mit Docker Compose
docker compose up --build

# Im Hintergrund
docker compose up -d

# Logs ansehen
docker compose logs -f backend
docker compose logs -f frontend

# Stoppen
docker compose down
```

## 📚 API Endpoints

### Jobs durchsuchen
```bash
GET /api/jobs/search?q=Software&location=Berlin&limit=50
```

### Such-Konfigurationen
```bash
GET /api/settings/search-configs
POST /api/settings/search-configs
PUT /api/settings/search-configs/{id}
DELETE /api/settings/search-configs/{id}
```

### Scheduler
```bash
POST /api/scheduler/execute/{config_id}
GET /api/scheduler/status
POST /api/scheduler/pause
POST /api/scheduler/resume
```

### Statistiken
```bash
GET /api/jobs/stats
```

## 📝 Beispiel-Workflow

```bash
# 1. Such-Konfiguration erstellen
curl -X POST http://localhost:5000/api/settings/search-configs \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Senior Dev Hamburg",
    "job_title": "Senior Software Engineer",
    "location": "Hamburg",
    "radius": 50,
    "enabled_sources": ["arbeitsagentur", "indeed"],
    "schedule_type": "daily",
    "schedule_time": "07:00",
    "is_active": true
  }'

# 2. Sofort ausführen
curl -X POST http://localhost:5000/api/scheduler/execute/1

# 3. Jobs abrufen
curl "http://localhost:5000/api/jobs/search?q=Software&location=Hamburg"

# 4. Statistiken
curl http://localhost:5000/api/jobs/stats
```

## 🛠️ Entwicklung (lokal)

### Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
export FLASK_ENV=development
python app.py
```

### Frontend
```bash
cd frontend
npm install
npm start
```

## 📦 Deployment

### Docker Hub
```bash
docker build -t nilshh/jobs-backend:latest ./backend
docker push nilshh/jobs-backend:latest
```

### Kubernetes (optional)
Ein Helm Chart kann später hinzugefügt werden.

## 🔒 Sicherheit

- ✅ CORS konfiguriert für localhost
- ✅ SQLAlchemy ORM (SQL Injection Protection)
- ✅ Environment-basierte Secrets (.env)
- ✅ Health Checks
- ✅ Logging mit Rotation
- ✅ HTTPS-ready (nginx reverse proxy)

## 📈 Performance

- 🚀 Multi-threaded Job API Suche
- 💾 Duplikat-Erkennung
- ⏱️ APScheduler für effiziente Planung
- 📊 Pagination für API-Response
- 🔄 Job-Caching

## 🐛 Troubleshooting

### Container starten nicht
```bash
docker compose logs
# Prüfe .env Datei und API Keys
```

### Frontend lädt nicht (blank page)
```bash
docker compose logs frontend
# Prüfe REACT_APP_API_BASE_URL
```

### Jobs werden nicht gefunden
```bash
# Backend logs
docker compose logs backend

# Prüfe:
# - Internet-Verbindung
# - API Keys (falls erforderlich)
# - Such-Parameter (Jobtitel, Ort)
```

### Datenbank zurücksetzen
```bash
rm backend/database.db
docker compose restart backend
```

## 📊 Datenbank-Schema

### jobs
- id, job_id, source (arbeitsagentur, indeed, etc.)
- title, company, location, url
- description, salary, salary_min, salary_max
- employment_type, posted_date, created_at

### search_configs
- id, name, job_title, location, radius
- enabled_sources, schedule_type, schedule_time
- is_active, created_at, updated_at

### search_results
- id, search_config_id, executed_at
- total_jobs_found, new_jobs_count, status

## 🤝 Beiträge

Contributions sind willkommen! Bitte erstelle einen Pull Request.

## 📄 Lizenz

MIT License - Frei nutzbar für private und kommerzielle Projekte.

## 👨‍💻 Autor

Nils H. - IT Governance & Job Search Automation

---

**Version:** 1.0.0  
**Status:** Production Ready  
**Letzte Aktualisierung:** Januar 2026
EOF

# Backend Ordner struktur
echo "📁 Erstelle Backend Ordner..."
mkdir -p backend/{apis,routes,tasks,logs}

# Backend requirements.txt
cat > backend/requirements.txt << 'EOF'
Flask==2.3.3
Flask-SQLAlchemy==3.0.5
Flask-CORS==4.0.0
python-dotenv==1.0.0
requests==2.31.0
APScheduler==3.10.4
gunicorn==21.2.0
SQLAlchemy==2.0.21
Werkzeug==2.3.7
beautifulsoup4==4.12.2
lxml==4.9.3
psutil==5.9.5
EOF

# Backend Dockerfile
cat > backend/Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN mkdir -p logs

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5000/api/health || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "120", "--access-logfile", "-", "--error-logfile", "-", "app:create_app()"]
EOF

# Backend __init__ files
touch backend/__init__.py
touch backend/apis/__init__.py
touch backend/routes/__init__.py
touch backend/tasks/__init__.py

# Frontend Ordner struktur
echo "📁 Erstelle Frontend Ordner..."
mkdir -p frontend/{public,src/components,src/styles}

# Frontend package.json
cat > frontend/package.json << 'EOF'
{
  "name": "jobs-frontend",
  "version": "1.0.0",
  "description": "JobS - Job Search Automation Platform",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.15.0",
    "axios": "^1.6.0",
    "date-fns": "^2.30.0"
  },
  "devDependencies": {
    "react-scripts": "5.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "browserslist": {
    "production": [">0.2%", "not dead", "not op_mini all"],
    "development": ["last 1 chrome version", "last 1 firefox version", "last 1 safari version"]
  }
}
EOF

# Frontend Dockerfile
cat > frontend/Dockerfile << 'EOF'
FROM node:18-alpine as builder

WORKDIR /app

COPY package*.json .
RUN npm ci

COPY . .
ARG REACT_APP_API_BASE_URL=http://localhost:5000/api
ENV REACT_APP_API_BASE_URL=$REACT_APP_API_BASE_URL

RUN npm run build

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

# Frontend nginx.conf
cat > frontend/nginx.conf << 'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml text/javascript application/json application/javascript application/xml+rss application/rss+xml;

    server {
        listen 80;
        server_name _;

        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri $uri/ /index.html;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
}
EOF

echo "✅ Repository Setup erfolgreich abgeschlossen!"
echo ""
echo "📝 Nächste Schritte:"
echo "1. Backend Dateien erstellen (siehe Backend-Anleitung)"
echo "2. .env.example kopieren: cp .env.example .env"
echo "3. API Keys in .env eintragen (optional)"
echo "4. Docker starten: docker compose up --build"
echo "5. Frontend öffnen: http://localhost:3000"
echo ""
echo "📚 Weitere Infos: Siehe README.md"
