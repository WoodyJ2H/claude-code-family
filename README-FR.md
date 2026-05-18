# Claude Code Jumeau — Synchronisation Multi-PC

[![GitHub stars](https://img.shields.io/github/stars/WoodyJ2H/claude-jumeau?style=social)](https://github.com/WoodyJ2H/claude-jumeau/stargazers)

> Si ça vous fait gagner du temps, une ⭐ étoile aide les autres à le trouver.

Clonez votre **environnement de développement complet** sur plusieurs machines grâce à Claude Code, des partages SMB Windows, et des scripts PowerShell automatisés.

**Parfait pour:**
- Les parents et enfants qui codent ensemble sur des machines différentes
- Les développeurs avec plusieurs laptops (bureau + maison)
- Les assistants d'enseignement qui gèrent les environnements d'étudiants
- Les configurations pair-programming avec sync instantanée

---

## Ce que ça fait

```
PC 1 (Principal)               Partage Réseau SMB (T:\)           PC 2 (Secondaire)
├── .env                       ├── secrets/                       ├── .env
├── credentials                ├── memory/ (80 fichiers)          ├── credentials
├── Clés SSH         ←→        ├── ssh/                  ←→       ├── Clés SSH
├── .claude/                   ├── CLAUDE.md                      ├── .claude/
└── Node.js + Python           └── INSTALL.ps1                    └── Node.js + Python
```

Lancez **un script PowerShell** sur PC 2. Tout se synchronise automatiquement :
- Secrets (`.env`, clés API, identifiants)
- Configuration Claude Code et mémoires (80 fichiers markdown)
- Clés SSH pour accès VPS
- Dépendances Node.js + Python
- Configuration serveurs MCP n8n

**Résultat** : Environnement de développement identique, sans copier-coller manuel.

---

## Démarrage rapide

### Prérequis

**Sur les deux PC :**
- Windows 10/11
- Node.js (LTS) — [télécharger](https://nodejs.org)
- Python 3.11+ — [télécharger](https://python.org)
- Git — [télécharger](https://git-scm.com)

**Réseau :**
- Les deux PC sur le même réseau local (LAN)
- Un PC avec dossier partagé (PC Principal)
- Identifiants d'accès réseau (si mots de passe activés)

### Étape 1 : Partager le dossier de configuration (PC Principal)

Sur votre **PC principal** (ROGSTRIXJH dans l'exemple) :

1. Créez un dossier : `T:\TwinSetup\` (ou `C:\TwinSetup\`)
2. Copiez ce repo dedans
3. Clic droit → **Propriétés** → **Partager** → Autoriser l'accès réseau
4. Notez le chemin réseau : `\\PCNAME\TwinSetup`

### Étape 2 : Mapper le lecteur réseau (PC Secondaire)

Sur votre **deuxième PC** (ASUSZENBOOK dans l'exemple) :

1. **Explorateur de fichiers** → **Ce PC** → **Mapper un lecteur réseau**
2. Choisissez une lettre de lecteur (ex: `T:`)
3. Collez le chemin réseau : `\\ROGSTRIXJH\TwinSetup`
4. ✅ **Se reconnecter à l'ouverture de session** (recommandé)

### Étape 3 : Lancer le script d'installation (PC Secondaire)

Ouvrez **PowerShell en tant qu'administrateur** et lancez :

```powershell
# Option A : Lancer depuis le lecteur mappé
cd T:\TwinSetup
.\INSTALL.ps1

# Option B : Lancer depuis GitHub (si le mapping échoue)
powershell -ExecutionPolicy Bypass -Command "& { (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/WoodyJ2H/claude-code-jumeau/main/INSTALL.ps1').Content | Invoke-Expression }"
```

**Le script va :**
- ✅ Vérifier que Node.js, Python, Git sont installés
- ✅ Installer Claude Code CLI globalement
- ✅ Créer le dossier `C:\CLAUDE CODE`
- ✅ Copier les secrets depuis le partage réseau
- ✅ Copier la config Claude Code et les fichiers mémoire
- ✅ Copier les clés SSH pour l'accès VPS
- ✅ Installer les dépendances Python

---

## Ce qui se synchronise

| Élément | Source (PC 1) | Destination (PC 2) | Utilité |
|--------|---------------|------------------|---------|
| `.env` | `T:\secrets\` | `C:\CLAUDE CODE\` | Clés API, tokens, URLs de bases de données |
| `credentials.json` | `T:\secrets\` | `C:\CLAUDE CODE\JOB SEEKING\` | Tokens Google OAuth |
| `token.json` | `T:\secrets\` | `C:\CLAUDE CODE\JOB SEEKING\` | Tokens de rafraîchissement Google API |
| `linkedin-cookie.md` | `T:\secrets\` | `C:\CLAUDE CODE\Credentials\` | Données de session LinkedIn |
| `CLAUDE.md` | `T:\` | `~\.claude\` | Instructions globales Claude Code |
| Fichiers mémoire (80 .md) | `T:\memory\` | `~\.claude\projects\c--CLAUDE-CODE\memory\` | Contexte projets et apprentissages |
| Clés SSH (9 fichiers) | `T:\ssh\` | `~\.ssh\` | Accès SSH à VPS / GitHub |
| Config MCP | `T:\.mcp.json` | `C:\CLAUDE CODE\` | Serveurs n8n-mcp, Hostinger, etc. |

---

## Dépannage

### "Le chemin réseau est introuvable"
- **PC Principal** : Vérifiez que le dossier est partagé. Clic droit → Propriétés → Onglet Partager → Bouton "Partager"
- **PC Secondaire** : Essayez le chemin UNC directement : `\\ROGSTRIXJH\TwinSetup` (remplacez `ROGSTRIXJH` par le nom de votre PC principal)
- Vérifiez le pare-feu Windows/Norton : Autoriser SMB (port 445)

### Le script PowerShell se ferme immédiatement
- Ouvrez PowerShell **en tant qu'administrateur**
- Naviguez d'abord vers `T:\TwinSetup` : `cd T:\TwinSetup`
- Lancez : `.\INSTALL.ps1`
- (Pas : double-clic sur le fichier .ps1)

### "Les identifiants ne sont pas valides"
- PC Principal : Définissez un mot de passe réseau (compte Microsoft ou mot de passe local)
- PC Secondaire : Entrez vos identifiants quand demandé (format domaine\utilisateur, ex: `ROGSTRIXJH\jhhig`)
- Si toujours bloqué : Désactivez temporairement la protection par mot de passe sur le partage

### Le lecteur mappé disparaît
- Rouvrez **l'Explorateur de fichiers** → **Ce PC** → **Mapper un lecteur réseau**
- Cochez "Se reconnecter à l'ouverture de session"
- Si le réseau est "Public" : Changez à "Privé" dans Paramètres Windows

### "Node.js introuvable"
- Téléchargez depuis [nodejs.org](https://nodejs.org) (version LTS)
- Installez, puis redémarrez PowerShell
- Vérifiez : `node --version` (doit afficher v18+ ou v20+)

---

## Avancé : Synchronisation inverse (PC 2 → PC 1)

Après avoir modifié du code sur PC 2, resynchronisez vers PC 1 :

```powershell
# Sur PC 2
robocopy "C:\CLAUDE CODE\workflows-n8n" "T:\workflows-n8n" /MIR /R:3
robocopy "C:\Users\$env:USERNAME\.claude\projects" "T:\memory" /MIR
```

Ou utilisez **Settings Sync** intégré à VS Code (Ctrl+Shift+P → "Settings Sync: Turn On").

---

## Notes architecturales

### Pourquoi SMB (plutôt que Dropbox/OneDrive) ?
- ✅ Pas de dépendance au cloud → plus rapide, plus privé
- ✅ Fonctionne hors ligne après la synchronisation initiale
- ✅ Les secrets restent sur le réseau local
- ✅ Gratuit, fonctionne sur n'importe quel LAN Windows

### Pourquoi un script PowerShell (plutôt que Docker) ?
- ✅ Fonctionne sur Windows sans VM Linux
- ✅ Pas de droits admin requis (après configuration initiale du partage)
- ✅ Idempotent — sûr de lancer plusieurs fois
- ✅ Facile à personnaliser pour votre propre configuration

### Et les conflits ?
- **T: est la source de vérité** — synchronisez toujours VERS PC 2 DEPUIS PC 1
- Si vous modifiez `.env` sur PC 2, copiez-le manuellement vers T:\ avant de resynchroniser
- Les workflows (n8n) vivent dans le cloud (Hostinger) — pas synchronisés localement

---

## Étendre la configuration

### Ajouter d'autres dossiers
Modifiez `INSTALL.ps1` et ajoutez des opérations de copie :

```powershell
Copy-Item "T:\votre-dossier\*" "C:\CLAUDE CODE\votre-dossier\" -Force -Recurse
```

### Synchroniser depuis PC 2 vers PC 1
Créez un `SYNC-BACK.ps1` sur le PC secondaire :

```powershell
robocopy "C:\CLAUDE CODE\projects" "T:\projects" /MIR
robocopy "$env:USERPROFILE\.claude\projects" "T:\memory" /MIR
```

### Automatiser les synchronisations périodiques
Utilisez l'**Planificateur de tâches** pour lancer `SYNC-BACK.ps1` chaque nuit :
- Créez une tâche
- Déclencheur : "À une heure planifiée" → Quotidien à 2 AM
- Action : `powershell.exe -File C:\chemin\vers\SYNC-BACK.ps1`

---

## Pour les parents et enfants

**Scénario :** Vous voulez que vos enfants codent avec vous, mais sur leur propre PC.

1. **Configurez le PC Principal** (le vôtre) avec tous vos workflows, secrets et clés SSH
2. **Donnez le PC Secondaire aux enfants** avec tout pré-configuré
3. **Enseignez à partir du même codebase** — vous modifiez sur votre machine, ils le voient instantanément
4. **Débogages collaboratifs** — les deux travaillant dans la même structure de dossiers

Exemple de workflow :
```
Papa (PC 1) : Écrit un workflow n8n
  ↓ (partage SMB)
  ↓ (INSTALL.ps1)
Enfant (PC 2) : Voit le workflow, pose des questions
  ↓ (codage pair en direct)
Enfant (PC 2) : Modifie le workflow
  ↓ (copie manuelle vers T:\)
Papa (PC 1) : Revoit les modifications
```

---

## Pour le pair-programming

**Scénario :** Vous et un collègue avez chacun un laptop et voulez travailler sur le même codebase.

1. **Le développeur principal** partage son dossier de configuration
2. **Le collègue** mappe le lecteur réseau et lance le script
3. **Les deux ont un environnement identique** en 5 minutes
4. **Collaborez** en utilisant l'extension Live Share de VS Code (optionnel)

---

## Signaler des problèmes

Trouvé un bug ou voulez ajouter une fonctionnalité ?

1. Forkez ce repo
2. Créez une branche : `git checkout -b fix/votre-probleme`
3. Committez vos modifications
4. Poussez et ouvrez une Pull Request

Problèmes courants à signaler :
- Problèmes d'exécution PowerShell sur votre version de Windows
- Pare-feu/antivirus bloquant le script
- Dépendances manquantes ou versions d'outils incompatibles
- Le partage réseau n'apparaît pas dans l'Explorateur de fichiers

---

## Licence

Licence MIT — utilisez, modifiez et partagez librement.

---

## Crédits

Construit pour résoudre le problème "Je veux que mon deuxième PC soit identique à mon premier" sans stockage cloud, copie manuelle ou outillage complexe.

Inspiré par les pratiques DevOps (Infrastructure as Code) appliquées aux configurations de développement personnelles.

---

**Prêt à synchroniser ? Mappez ce lecteur réseau et lancez INSTALL.ps1.** 🚀
