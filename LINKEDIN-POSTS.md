# LinkedIn Posts — Twin Setup Series

## Post 1: Générique — "I Cloned My Development Environment Across 2 PCs"

**Length:** 780 chars | **Type:** apprentissage/terrain | **Angle:** absurdité du problème

---

J'ai un problème **tous les développeurs** rencontrent : deux PC, deux stacks incomplets.

Mon laptop de bureau ? Workflows n8n, credentials Google, SSH keys pour 3 VPS différents. Mon laptop portable ? Neuf.

Copier-coller avec clé USB, ça dure une heure. Dropbox/OneDrive, c'est une surface d'attaque pour les secrets. GitHub public, hors de question.

**Donc j'ai écrit un script PowerShell qui clone l'environnement complet en 5 minutes.**

Le vrai : ça pas besoin d'être cloud fancy. Un simple **partage SMB Windows** (port 445, LAN seulement) + `robocopy` = source of truth transféré sans friction.

```
PC 1 (secrets + mémoires + clés SSH)
    ↓ (SMB share T:\)
    ↓ (INSTALL.ps1)
PC 2 (environnement identical)
```

Pourquoi SMB ? Pas de dépendance cloud. Zéro latence. Ça tourne offline. Les secrets restent sur le réseau local.

**Résultat :** Node.js + Python + Claude Code + 80 fichiers mémoire + credentials + SSH = synchronized en une exécution, récréable à volonté.

Je l'ai opensourcé : **github.com/WoodyJ2H/claude-code-family** — à vous de l'adapter pour vos propres secrets.

Les infra as code, c'est pas juste pour les DevOps.

#n8n #ClaudeCode #AIAgents #Automatisation #LLM #Productivity

---

## Post 2: Parents & Enfants — "Coding with Your Kids? Clone Your Environment to Their PC"

**Length:** 750 chars | **Type:** apprentissage/terrain | **Angle:** pédagogie + pair-programming

---

L'année dernière j'ai décidé de **coder avec mon fils**, plutôt que seul dans mon coin.

Problème : il a son propre laptop. Je veux qu'il voie **exactement ce que j'ai** — mes workflows, ma structure de dossiers, mes scripts. Mais pas manuellement. Pas d'heure de configuration avant le coding.

**Besoin :** un script qui dit "clique sur ça et ton laptop ressemble au mien".

J'ai bâti **un outil qui synchronize l'environnement de dev entier** d'une machine à l'autre sur le LAN. En 5 minutes. Zéro copy-paste.

C'est pas juste pour les enfants — c'est pour deux développeurs avec deux laptops qui veulent **une single source of truth**.

```
You on your PC: Write a workflow in n8n
  ↓ (shared folder)
Kid on their PC: Sees it, asks questions
  ↓ (live pair coding)
```

Les secrets (API keys, credentials) ?Restent sur le réseau, jamais dans le cloud.

Node.js, Python, SSH keys, Claude Code config — **tout transféré en une commande PowerShell**.

Repo public : **github.com/WoodyJ2H/claude-code-family**

Framework here isn't important. The idea is: **stop setting up environments manually**. Automate once, teach with code, not with config.

#ClaudeCode #ParentingInTech #CodeTogether #Automation #LLM #PairProgramming

---

## Post 3: Multi-Dev — "SMB Share as Dev Infrastructure"

**Length:** 820 chars | **Type:** observation terrain | **Angle:** infrastructure is simpler than you think

---

On parle toujours d'**infrastructure as code**. Docker, Kubernetes, Terraform. C'est normal en production.

Mais en dev ? Deux laptops, un partage réseau Windows, et un script PowerShell a suffi pour que je **clone mon stack complet** sans cloud, sans friction, sans dépendance sur un DevOps engineer.

Voilà ce que j'ai construit :

```
PC 1 (Primary)              PC 2 (Secondary)
├── .env              ←→    ├── .env
├── credentials       ←→    ├── credentials
├── SSH keys          ←→    ├── SSH keys
├── .claude/ (80 mem) ←→    ├── .claude/ (80 mem)
└── config            ←→    └── config
```

**Tout ça via :**
- SMB share (Windows default, pas d'install)
- `robocopy` (built-in, plus robuste que copy-paste)
- PowerShell script (5 minutes, idempotent)

**Le vrai avantage :** source of truth stay local. Secrets never touch the cloud. Infrastructure scales from "I" (one dev) to "we" (two devs) without rearchitecting.

C'est tellement simple qu'on l'oublie. On cherche toujours des outils complexes.

Parfois la réponse c'est : **un dossier partagé et un script qu'on peut lire en 50 lignes**.

Opensource : **github.com/WoodyJ2H/claude-code-family**

Forks pour autres use-cases : `claude-code-clone` (English, dev-focused), `claude-jumeau` (Français, parent-friendly).

Infrastructure doesn't have to be complex.

#n8n #ClaudeCode #DevOps #SoftwareArchitecture #LLM #Automation

---

## Hashtag suggestions for search (SEO-friendly)

**Parents searching:**
- `#CodingWithKids`
- `#FamilyTech`
- `#ParentDeveloper`
- `#TeachingCode`
- `#KidsAndCode`

**Developers searching:**
- `#DevEnvironment`
- `#CloudAlternative`
- `#LocalFirst`
- `#DevOps`
- `#Automation`

**Dual audience:**
- `#ClaudeCode`
- `#n8n`
- `#AIAgents`
- `#Productivity`
- `#LLM`

---

## How to post

1. Copy Post 1, 2, or 3 above
2. Add one hashtag set from the suggestions
3. Add repo link: `github.com/WoodyJ2H/claude-code-family` (and appropriate fork: `claude-code-clone`, `claude-jumeau`)
4. Paste into Posts_Queue sheet with status `pending_manuel`
5. User validates all three before publishing

---
