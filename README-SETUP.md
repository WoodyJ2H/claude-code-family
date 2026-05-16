# Twin Setup — Procédure d'installation sur le 2ème PC

> Objectif : environnement identique à celui du PC principal pour continuer tout projet en cours.

---

## Prérequis à installer en premier

| Outil | Lien | Notes |
|---|---|---|
| Node.js (LTS) | https://nodejs.org | Requis pour Claude Code + n8n-mcp |
| Python 3.11+ | https://python.org | Requis pour les scripts workflows |
| Git | https://git-scm.com | Requis pour cloner le repo |
| VS Code | https://code.visualstudio.com | IDE principal |
| uv (Python package manager) | `pip install uv` | Requis pour Blender MCP |

---

## Étape 1 — Claude Code CLI

```powershell
npm install -g @anthropic-ai/claude-code
```

Puis auth :
```powershell
claude
```
→ Se connecter avec le compte Anthropic (même compte que PC principal).

---

## Étape 2 — Cloner le repo de travail

```powershell
git clone https://github.com/WoodyJ2H/claude-code-workspace.git "C:\CLAUDE CODE"
```

> Le repo contient tout le code, les workflows, les scripts.
> Il ne contient PAS les secrets (voir Étape 3).

---

## Étape 3 — Copier les secrets (transfert manuel)

Copier ces fichiers depuis le PC principal (clé USB ou Drive privé) :

| Fichier | Destination |
|---|---|
| `.env` | `C:\CLAUDE CODE\.env` |
| `credentials.json` | `C:\CLAUDE CODE\JOB SEEKING\credentials.json` |
| `token.json` | `C:\CLAUDE CODE\JOB SEEKING\token.json` |
| `linkedin-cookie.md` | `C:\CLAUDE CODE\Credentials\linkedin-cookie.md` |

**Ces fichiers ne sont jamais dans Git — transfert manuel obligatoire.**

---

## Étape 4 — Mémoires Claude

Copier les fichiers mémoire depuis le PC principal :

```powershell
# Source : C:\Users\jhhig\.claude\projects\c--CLAUDE-CODE\memory\
# Destination : C:\Users\<TON_USER>\.claude\projects\c--CLAUDE-CODE\memory\
```

Ou récupérer depuis Google Drive :
```
G:\Mon Drive\N8N HOSTINGER DATA GOOGLE DRIVE\Claude Memory\
```

Copier aussi le `CLAUDE.md` global :
```
C:\Users\jhhig\.claude\CLAUDE.md  →  C:\Users\<TON_USER>\.claude\CLAUDE.md
```

---

## Étape 5 — MCP Servers

Copier le fichier de config MCP :
```
C:\CLAUDE CODE\.mcp.json  →  C:\CLAUDE CODE\.mcp.json  (déjà dans le repo)
```

Installer les dépendances MCP locales :

```powershell
# n8n-mcp (MCP local Node.js)
cd "C:\CLAUDE CODE\n8n-tools\n8n-mcp"
npm install
npm run build
```

Les autres MCP (hostinger, n8n-native, datagouv) sont en HTTP ou `npx` — pas d'install locale nécessaire.

**Ajuster le chemin dans `.mcp.json` si le user Windows est différent :**
```json
"args": ["C:\\CLAUDE CODE\\n8n-tools\\n8n-mcp\\dist\\mcp\\index.js"]
```
→ Ce chemin est absolu mais ne dépend pas du user — OK si même lettre de disque.

---

## Étape 6 — VS Code

Dans VS Code sur le PC principal :
- `Ctrl+Shift+P` → "Settings Sync: Turn On"
- Se connecter avec le compte GitHub ou Microsoft

Sur le 2ème PC :
- Même manipulation → tout se synchronise automatiquement (extensions, thème, raccourcis)

---

## Étape 7 — Variables d'environnement Python

Certains scripts Python lisent le `.env` via `python-dotenv`. Vérifier que la lib est installée :

```powershell
pip install python-dotenv google-auth google-auth-oauthlib google-api-python-client
```

---

## Vérification finale

```powershell
# Claude Code OK ?
claude --version

# Node OK ?
node --version

# Python OK ?
python --version

# n8n MCP OK ? (depuis C:\CLAUDE CODE)
# Lancer claude et taper : /mcp
# → doit lister n8n-mcp, hostinger-mcp, n8n-native-mcp
```

---

## Ce qui reste sur le PC principal uniquement

- **Credentials n8n** (logins Google, LinkedIn OAuth, Apify...) — stockés dans l'UI n8n Hostinger, accessible depuis n'importe quel PC via le navigateur
- **Compte LinkedIn** — session navigateur, pas transférable
- **Blender** — à installer séparément si besoin

---

## Notes

- L'instance n8n tourne sur Hostinger (cloud) — accessible depuis les deux PC sans config
- Les workflows n8n sont dans le cloud — pas besoin de les transférer
- SSH Hostinger : la clé privée est dans `C:\Users\jhhig\.ssh\` — à copier si besoin d'accès SSH depuis le 2ème PC
