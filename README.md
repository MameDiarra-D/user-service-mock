# User Service — Mock Server

Serveur mock généré à partir de `user-service.yaml` avec **Prism** (Stoplight), l'outil standard de l'écosystème OpenAPI pour créer des mocks fidèles à une spec (bien plus maintenu que l'ancien `swagger-codegen`, qui est déprécié depuis 2018 au profit d'`openapi-generator` / de mocks type Prism).

Ce mock :
- expose **tous les endpoints** du spec (`/users`, `/users/{userId}`, `/users/me`) avec les bons verbes HTTP
- répond avec les codes de statut définis (200, 201, 204, 400, 401, 403, 404, 409)
- renvoie les `example` déjà présents dans le YAML, et peut aussi générer des données dynamiques réalistes (mode `-d`)
- valide les requêtes entrantes par rapport aux schémas (erreur 422 si le body ne respecte pas `CreateUserRequest`, etc.)

## Lancer en local

```bash
npm install
npm start
```

Le serveur écoute sur `http://localhost:4010`.

Test rapide :
```bash
curl http://localhost:4010/users/me -H "Authorization: Bearer test"
curl -X POST http://localhost:4010/users -H "Content-Type: application/json" \
  -d '{"keycloakId":"kc-1","email":"awa@example.com","firstName":"Awa","lastName":"Diop"}'
```

## Déployer gratuitement (5 minutes) — Render.com

Render a un tier gratuit, redémarre automatiquement, et le fichier `render.yaml` fourni configure tout automatiquement.

1. Crée un repo GitHub et pousse ce dossier dedans :
   ```bash
   git init
   git add .
   git commit -m "Mock server user-service"
   git branch -M main
   git remote add origin https://github.com/<ton-user>/user-service-mock.git
   git push -u origin main
   ```
2. Va sur https://render.com → **New** → **Blueprint** → connecte ton repo GitHub.
3. Render détecte automatiquement `render.yaml` et propose la config (Node, `npm install`, `npm start`). Clique **Apply**.
4. Après ~2 minutes de build, Render te donne une URL du type :
   `https://user-service-mock.onrender.com`
5. Vérifie : `https://user-service-mock.onrender.com/users/me` (avec un header `Authorization: Bearer test`).

⚠️ Sur le plan gratuit, le service se met en veille après 15 min d'inactivité (premier appel un peu lent le temps qu'il redémarre — normal).

### Alternative : Railway.app
Même principe : push sur GitHub → https://railway.app → **New Project** → **Deploy from GitHub repo** → Railway détecte Node et déploie automatiquement. URL fournie sous `https://<projet>.up.railway.app`.

### Alternative : Docker (si tu as déjà un serveur / VPS)
```bash
docker build -t user-service-mock .
docker run -p 4010:4010 user-service-mock
```

## Mettre à jour le spec avec l'URL de déploiement

Une fois déployé, ajoute l'URL réelle dans `servers:` de `user-service.yaml` :

```yaml
servers:
  - description: Local development
    url: 'http://localhost:8080'
  - description: Production
    url: 'https://api.example.com/user-service'
  - description: Mock server (Render)
    url: 'https://user-service-mock.onrender.com'
```

Envoie-moi l'URL une fois déployée et je te régénère directement le fichier `user-service.yaml` mis à jour.
