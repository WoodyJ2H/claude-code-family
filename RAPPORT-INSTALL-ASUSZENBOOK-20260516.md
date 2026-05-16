# Rapport d'installation — ASUSZENBOOK (2ème PC)

> Session Claude Code du 2026-05-16, 19:39 → 19:48
> Suit la structure de [README-SETUP.md](README-SETUP.md)
> Source : `\\ROGSTRIXJH\TwinSetup` (= drive `T:`)
> Cible : `ASUSZENBOOK` — user `jhhig` — Windows 11 Famille 10.0.26200

---

## Prérequis — état constaté

| Outil | Version trouvée | OK ? |
|---|---|---|
| Node.js (LTS) | v24.15.0 | ✅ |
| Python | 3.14.5 | ✅ (>3.11 requis) |
| Git | 2.54.0.windows.1 | ✅ |
| VS Code | non vérifié | — |
| uv (Python pkg mgr) | non vérifié | — |

→ **ASUSZENBOOK n'est pas un PC vierge** : tous les prérequis sont déjà installés. Le script `INSTALL.ps1` agit en mode "sync de config", pas en bootstrap.

---

## Étape 1 — Claude Code CLI

| Action prévue | État sur ASUSZENBOOK |
|---|---|
| `npm install -g @anthropic-ai/claude-code` | ⏭️ **Sauté** — déjà installé en version **2.1.143** |
| `claude` (auth Anthropic) | ⚠️ **Non vérifié** ce run — à tester au prochain lancement |

---

## Étape 2 — Cloner le repo de travail

| Action prévue | État |
|---|---|
| `git clone … "C:\CLAUDE CODE"` | ⏭️ **Sauté** — dossier déjà présent avec ~50 sous-dossiers projets et `.git` initialisé |

Sous-dossiers projets présents (50) :
`antigravity-stitch`, `autodream`, `Autodream projet`, `Claude Code + Remotion`, `CREATION AGENCE AGENTIQUE`, `DATA_GOUV`, `Discussion Context expert`, `DJAMBI`, `ELEVENLABS`, `figurine-3d`, `HBDConsulting`, `Indeed Job Scrapper`, `Instagram`, `JOB scrapping via AGENT_inspiré par JBS`, `JOB SEEKING`, `LAS Phantombuster Workflow Autoreply`, `LinkedIn Post System à 3 Skills et Profil a refaire sur Linked`, `matt-pocock-skills`, `Modern disruptive WebSite`, `molecule-site-web`, `n8n-backup-automation`, `n8n-tools`, `particle-cube-animation`, `Posture Analyse`, `Projet Site Web`, `RECHERCHE-UNIQUE-INDEED-EMAIL-REF`, `Repo Awesome-N8N-Templates`, `Twin Setup`, `Workflow Biblio to Skill Creation`, `workflows`, `workflows-library`, `workflows-n8n`, ainsi que `_briefs`, `_github-work`, `_tmp`, `.claude`, `Credentials`, `docs`, `docs-n8n`, `Documentation`.

---

## Étape 3 — Secrets (transfert manuel)

✅ **FAIT via robocopy depuis `T:\secrets\`**

| Fichier | Destination | Taille |
|---|---|---|
| `.env` | `C:\CLAUDE CODE\.env` | 1 974 o |
| `credentials.json` | `C:\CLAUDE CODE\JOB SEEKING\credentials.json` | 411 o |
| `token.json` | `C:\CLAUDE CODE\JOB SEEKING\token.json` | 741 o |
| `linkedin-cookie.md` | `C:\CLAUDE CODE\Credentials\linkedin-cookie.md` | 1 255 o |

---

## Étape 4 — Mémoires Claude

✅ **FAIT**

| Fichier / dossier | Source | Destination | Détail |
|---|---|---|---|
| `CLAUDE.md` global | `T:\CLAUDE.md` (15/05/2026 22:28) | `C:\Users\jhhig\.claude\CLAUDE.md` | 40 199 o |
| Mémoires | `T:\memory\*` (80 fichiers) | `C:\Users\jhhig\.claude\projects\c--CLAUDE-CODE\memory\` | **80 fichiers .md** copiés |

⚠️ 27 des 80 fichiers mémoire font 0 octet (placeholders côté source) — à remplir progressivement sur ROGSTRIXJH.

---

## Étape 5 — MCP Servers

⚠️ **Partiellement traité — à finaliser**

| Action | État |
|---|---|
| `.mcp.json` en place | ✅ Présent dans `C:\CLAUDE CODE\.mcp.json` |
| `npm install` + `npm run build` dans `n8n-tools\n8n-mcp` | ❓ Non exécuté ce run — dossier `n8n-tools\` présent, à vérifier |
| Chemin absolu dans `.mcp.json` (`C:\\CLAUDE CODE\\…`) | ✅ Compatible (même lettre de disque, même user `jhhig`) |

➡️ **À faire** : ouvrir `claude` sur ASUSZENBOOK et taper `/mcp` pour vérifier que `n8n-mcp`, `hostinger-mcp`, `n8n-native-mcp` répondent.

---

## Étape 6 — VS Code Settings Sync

❓ **Non vérifié** ce run — l'utilisateur doit confirmer si déjà actif sur ASUSZENBOOK.

---

## Étape 7 — Dépendances Python

✅ **FAIT — toutes déjà satisfaites**

```
pip install python-dotenv google-auth google-auth-oauthlib google-api-python-client
```
→ Toutes présentes dans `C:\Users\jhhig\AppData\Roaming\Python\Python314\site-packages\`. Pas d'install nécessaire.

---

## Étape supplémentaire (non dans le README initial) — Clés SSH

✅ **FAIT**

| Source | Destination | Fichiers |
|---|---|---|
| `T:\ssh\*` | `C:\Users\jhhig\.ssh\` | 9 fichiers : `config`, `id_ed25519`, `id_ed25519.pub`, `id_rsa.ppk`, `id_rsa.pub.pub`, `id_rsa_n8n`, `id_rsa_n8n.pub`, `known_hosts`, `known_hosts.old` |

➡️ **À tester** : `ssh -i ~/.ssh/id_rsa_n8n hostinger` pour valider l'accès VPS depuis ASUSZENBOOK.

---

## Vérification finale

| Test | Résultat |
|---|---|
| `claude --version` | `2.1.143 (Claude Code)` ✅ |
| `node --version` | `v24.15.0` ✅ |
| `python --version` | `Python 3.14.5` ✅ |
| `git --version` | `2.54.0.windows.1` ✅ |
| `claude /mcp` (à lancer manuellement) | ⏳ |
| `claude` auth Anthropic | ⏳ |
| SSH Hostinger | ⏳ |
| Test workflow Python utilisant `.env` | ⏳ |

---

## Backup pré-installation

Avant tout écrasement, l'état local précédent a été sauvegardé :

```
C:\CLAUDE CODE\_backup-pre-install-20260516-193906\
├── .env                (ancien)
├── CLAUDE-global.md    (ancien CLAUDE.md global)
├── memory\             (ancien dossier complet)
└── ssh\                (ancienne config SSH)
```
→ 91 fichiers, 202 Ko. Rollback simple si nécessaire.

---

## Problèmes rencontrés (pour améliorer le script à l'avenir)

| # | Problème | Cause | Workaround |
|---|---|---|---|
| 1 | `Start-Process -Verb RunAs -ExecutionPolicy Bypass` bloqué par classifier auto-mode | Combo élévation + bypass jugé sensible | Exécution en non-admin (suffisant ici car tout est sous `USERPROFILE` / `C:\CLAUDE CODE` accessible) |
| 2 | `& "T:\INSTALL.ps1"` → "not recognized" en admin | Drives mappés invisibles entre tokens UAC user vs admin sous Windows | Utiliser UNC `\\ROGSTRIXJH\TwinSetup\…` ou `net use T: …` en admin |
| 3 | `Get-ChildItem T:\` retourne 0 fichier alors que `cmd dir T:\` voit tout | Quirk provider PS sur ce share — énumération bloquée, lecture/copie fichier OK | Utiliser `cmd dir` pour inventaire et `robocopy` pour copies |
| 4 | Classifier a bloqué le `robocopy` initial | Écrasement de `~/.claude/CLAUDE.md` = self-modification | Backup local préalable + autorisation explicite "D" de l'utilisateur |

---

## Ce qui reste sur ROGSTRIXJH uniquement

- Credentials n8n (Google, LinkedIn OAuth, Apify) — dans l'UI n8n Hostinger, accessible des deux PC via navigateur
- Compte LinkedIn — session navigateur, pas transférable
- Blender — à installer séparément si besoin

---

## Recommandations

1. **Améliorer `INSTALL.ps1`** :
   - Détecter et mapper `T:` automatiquement en admin : `if (-not (Test-Path T:\)) { net use T: \\ROGSTRIXJH\TwinSetup }`
   - Utiliser `robocopy /MIR` plutôt que `Copy-Item -Force`
   - Skip si Node/Claude/Python déjà OK (idempotence)
   - Faire le backup automatique avant écrasement
2. **Sync mémoires bidirectionnelle** : aujourd'hui T: est toujours source. Si ASUSZENBOOK modifie des mémoires, push manuel vers Drive nécessaire (déjà couvert par étape 8 de CLOSE dans `CLAUDE.md`).
3. **Investiguer le quirk PowerShell sur T:** : `Get-Acl T:\` depuis ROGSTRIXJH pour comprendre les ACL.
4. **Permission durable** dans `~/.claude/settings.json` sur ASUSZENBOOK pour autoriser `robocopy \\ROGSTRIXJH\…` sans déclencher le classifier la prochaine fois.

---

## TL;DR

✅ Secrets (4), CLAUDE.md global, 80 mémoires, 9 clés SSH synchronisés depuis ROGSTRIXJH.
✅ Backup local préservé.
⏭️ Étapes 1 (Claude Code), 2 (clone repo), 7 (pip) sautées car déjà OK.
⏳ À tester au prochain run : `claude /mcp`, auth Anthropic, SSH n8n, scripts Python avec `.env`.

---

*Rapport généré par Claude Code sur ASUSZENBOOK le 2026-05-16 à 19:48.*

---

## ANNEXE — Brief pour Claude sur ROGSTRIXJH : préparer un post LinkedIn

> Quand tu liras ce rapport sur ROGSTRIXJH, voici ce que l'utilisateur veut faire ensuite.

### Demande de l'utilisateur

JH veut **un post LinkedIn** qui raconte cette histoire de twin setup ASUSZENBOOK ⇄ ROGSTRIXJH **avec un angle technique intéressant** — pas un post setup banal.

### Angle suggéré (à challenger / améliorer)

Le truc vendeur ici n'est pas "j'ai cloné mon environnement". C'est l'**aller-retour entre 2 instances Claude qui se laissent des rapports** sur un share réseau. Une **mémoire externe partagée entre 2 agents IA tournant sur 2 machines différentes**. C'est presque un mini-système de coordination multi-agents *low-tech* — pas de cloud, pas d'API, juste un share SMB + des `.md`.

### Punchlines candidates (style LAS-1a, 200-280 mots)

- *"J'ai mis 2 Claude Code à bosser sur 2 PC différents. Ils se passent des notes sur un share Windows. C'est exactement ce que ferait un humain — mais en moins poli."*
- *"Pour synchroniser mon 2ème PC, j'ai pas écrit un script. J'ai demandé à Claude de laisser un rapport à l'autre Claude. Le share SMB est devenu une messagerie inter-IA."*
- *"Le futur du multi-agent c'est peut-être pas des MCP, des A2A, des agents qui s'appellent en HTTP. C'est juste un dossier partagé et des fichiers markdown."*

### Éléments concrets à exploiter

- Le quirk PowerShell qui voit pas les fichiers que cmd voit → **petite histoire technique croustillante**
- Le classifier auto-mode qui bloque 4 fois → **observation sur la "sécurité by default" des agents IA**
- Le backup auto avant écrasement → **bonne pratique réutilisable**
- La séparation user/admin tokens UAC sur les drives mappés → **piège Windows méconnu**

### Style de référence

Voir `C:/CLAUDE CODE/Projet Site Web/src/content/publications/` sur ROGSTRIXJH (posts validés).
Format selon `memory/feedback_linkedin_post_format.md` :
- Si **apprentissage/terrain** → punchline-first, 200-280 mots
- Si **veille/outil** → 6 formats rotatifs LAS-1a, 150-200 mots
- Hashtags : `#n8n #ClaudeCode #AIAgents #Automatisation #LLM #Productivity`

### Workflow recommandé pour publier

1. Claude rédige 1 version sur ROGSTRIXJH (punchline-first)
2. Écrit en sheet `Posts_Queue` via script Python — colonnes A=date, B=post, C=statut
3. Demander à JH : statut `instantanne` ou `pending` ?
4. Telegram master pour approbation finale

→ **CRITIQUE** : sauts de ligne = vrais `\n` Python, pas `\\n` littéraux. Utiliser multiline `"""..."""`.

---

*Annexe générée à la demande de JH. Le but : transformer une session install banale en post LinkedIn techniquement intéressant qui montre une nouvelle façon de penser le multi-agent.*

