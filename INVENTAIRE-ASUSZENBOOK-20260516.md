# Inventaire brut — ASUSZENBOOK (2026-05-16)

> Données collectées via PowerShell + `cmd dir` pendant la session install.
> Complète [RAPPORT-INSTALL-ASUSZENBOOK-20260516.md](RAPPORT-INSTALL-ASUSZENBOOK-20260516.md).

---

## 1. Identité système

```
HOSTNAME    : ASUSZENBOOK
USER        : jhhig
OS          : Microsoft Windows 11 Famille 10.0.26200
DISK C:     Used = 151.2 Go | Free = 359.6 Go
```

---

## 2. Versions outils

```
node      v24.15.0
npm       11.12.1
claude    2.1.143 (Claude Code)
python    3.14.5
pip       26.1.1   (C:\Python314\Lib\site-packages\pip)
git       2.54.0.windows.1
```

---

## 3. Drives mappés au moment de la session

```
Name : T
Root : T:\
DisplayRoot : \\ROGSTRIXJH\TwinSetup
```

---

## 4. Contenu de T:\ vu depuis ASUSZENBOOK

```
T:\
├── CLAUDE.md           40 199 o  (15/05/2026 22:28)
├── INSTALL.ps1          2 193 o  (16/05/2026 18:44)
├── README-SETUP.md      4 133 o  (16/05/2026 14:54)
├── memory\             80 fichiers .md (152 004 o total)
├── secrets\
│   ├── .env                  1 974 o
│   ├── credentials.json        411 o
│   ├── linkedin-cookie.md    1 255 o
│   └── token.json              741 o
└── ssh\
    ├── config             113 o
    ├── id_ed25519         399 o
    ├── id_ed25519.pub      96 o
    ├── id_rsa.ppk       1 611 o
    ├── id_rsa.pub.pub     477 o
    ├── id_rsa_n8n       3 243 o
    ├── id_rsa_n8n.pub     739 o
    ├── known_hosts      1 034 o
    └── known_hosts.old    188 o
```

---

## 5. Mémoires Claude (80 fichiers — détail)

**Fichiers de référence (28)** :
`CLAUDE.md` (33 498 o — copie locale du global), `MEMORY.md` (6 713 o — index), `CORE.md` (5 605 o), `user_elegant.md` (2 373 o), `user_profile.md` (2 127 o), et 23 autres référence/project/feedback de taille > 1 Ko.

**Fichiers à 0 octet (27 placeholders)** :
`feedback_doc_first.md`, `feedback_keyboard_lag.md`, `feedback_n8n_api_pagination.md`, `feedback_n8n_debugging.md`, `feedback_n8n_google_credentials.md`, `feedback_n8n_loops_and_notifications.md`, `feedback_n8n_publish_unpublish.md`, `feedback_orphan_nodes.md`, `feedback_phantombuster_csvname.md`, `feedback_ssl_windows_fix.md`, `feedback_telegram_vs_email.md`, `feedback_transfer_persistent_items.md`, `feedback_util_workflows_template.md`, `feedback_workflow_duplication_connections.md`, `project_config_recommendations.md`, `project_cv_reformatter.md`, `project_datagouv_workflow.md`, `project_djambi.md`, `project_figurine_papa.md`, `project_jbs2_dual_ai.md`, `project_linkedin_webhook_cron_solution.md`, `project_linkedin_workflow.md`, `project_ubs_workflow.md`, `reference_environment_tools.md`, `reference_google_apis_via_n8n.md`, `reference_n8n_hostinger_session.md`, `reference_n8n_workflows_inventory.md`, `reference_routine_chart_tab.md`, `reference_ssh_hostinger.md`, `reference_ui_progress_bar.md`.

→ Sur ROGSTRIXJH, vérifier si ces 27 placeholders sont vides aussi ou s'ils ont du contenu qui n'a pas été poussé vers T:.

---

## 6. Structure C:\CLAUDE CODE\ après install

### Sous-dossiers (50)

```
_backup-pre-install-20260516-193906   ← créé par cette session
_briefs
_github-work
_tmp
.claude
.git
antigravity-stitch
autodream
Autodream projet
Claude Code + Remotion
CREATION AGENCE AGENTIQUE
Credentials
DATA_GOUV
Discussion Context expert
DJAMBI
docs
docs-n8n
Documentation
ELEVENLABS
figurine-3d
HBDConsulting
Indeed Job Scrapper
Instagram
JOB scrapping via AGENT_inspiré par JBS
JOB SEEKING
LAS Phantombuster Workflow Autoreply
LinkedIn Post System à 3 Skills et Profil a refaire sur Linked
matt-pocock-skills
Modern disruptive WebSite
molecule-site-web
n8n-backup-automation
n8n-tools
particle-cube-animation
Posture Analyse
Projet Site Web
RECHERCHE-UNIQUE-INDEED-EMAIL-REF
Repo Awesome-N8N-Templates
Twin Setup
Workflow Biblio to Skill Creation
workflows
workflows-library
workflows-n8n
```

### Fichiers config racine

```
.env
.gitignore
.mcp.json
.n8n-instances.json
.n8n-webhooks.json
```

### Scripts ad-hoc racine

~200 fichiers `.py`, `.js`, `.json`, `.txt`, `.png`, `.ps1` (patches workflows n8n, debugging, screenshots).
→ **Recommandation** : ranger dans `_scripts-ad-hoc/` pour clarté.

---

## 7. Config Claude utilisateur (`~/.claude/`)

```
~/.claude/
├── .last-cleanup
├── backups/
├── cache/
├── CLAUDE.md            ← 40 199 o (synchronisé 16/05)
├── downloads/
├── file-history/
├── history.jsonl
├── ide/
├── plugins/
├── policy-limits.json
├── projects/
│   ├── c--CLAUDE-CODE/
│   │   └── memory/      ← 80 fichiers .md (synchronisés 16/05)
│   └── C--Windows-System32/
├── sessions/
└── settings.json
```

---

## 8. Clés SSH (`~/.ssh/`)

```
config
id_ed25519
id_ed25519.pub
id_rsa.ppk
id_rsa.pub.pub
id_rsa_n8n
id_rsa_n8n.pub
known_hosts
known_hosts.old
```

→ Toutes synchronisées depuis `T:\ssh\` le 16/05.

---

## 9. Backup pré-installation

```
Path  : C:\CLAUDE CODE\_backup-pre-install-20260516-193906\
Files : 91
Size  : 202 077 o
Contenu : .env (ancien), CLAUDE-global.md (ancien), memory\ (complet ancien), ssh\ (complet ancien)
```

---

## 10. Frictions techniques rencontrées

### 4 blocages auto-mode classifier
1. `Start-Process -Verb RunAs -ExecutionPolicy Bypass T:\INSTALL.ps1` → bloqué (élévation + bypass + drive externe)
2. `Get-ExecutionPolicy -List` → bloqué par contagion contextuelle
3. `Start-Process -Verb RunAs … INSTALL.ps1` (sans bypass) → bloqué (relance)
4. `robocopy` initial vers `~/.claude/CLAUDE.md` + memory + .ssh → bloqué (self-modification + bulk-replace + SSH import)

→ Débloqué par : (a) backup local préalable, (b) autorisation explicite utilisateur ("D" = T: est source de vérité).

### 1 quirk Windows
- `Get-ChildItem T:\` retourne 0 fichier alors que `cmd dir T:\` voit tout
- Hypothèse : ACL `READ_DIRECTORY` vs `READ_DATA` distinctes
- Workaround : `cmd dir` pour inventaire + `robocopy` pour copies

### 1 piège UAC
- Drives mappés invisibles entre session user et session admin (tokens distincts)
- Solution : `net use T: \\ROGSTRIXJH\TwinSetup` à refaire en admin, ou utiliser le chemin UNC directement

---

*Inventaire généré par Claude Code sur ASUSZENBOOK le 2026-05-16 à 19:48.*
