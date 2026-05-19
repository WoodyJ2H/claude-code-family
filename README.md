# Claude Code Family — Multi-PC Synchronized Development

[![GitHub stars](https://img.shields.io/github/stars/WoodyJ2H/claude-code-family?style=social)](https://github.com/WoodyJ2H/claude-code-family/stargazers)

> If this saves you time, a ⭐ star helps others find it.

## 🆕 v3 — Drive-first architecture (2026-05-19)

**Problem solved:** when the SMB server PC was off, the client PC would crash on startup (9 cascading errors in our case: T:\ unreachable → hook blocked → context lost).

**Solution:** Google Drive is now the source of truth for `SHARED-BRIEF.md`. The SMB share (T:\) is a best-effort LAN cache. No more blocking dependency.

**New files:**

- `write-shared-brief.ps1` — writes the session brief to Drive (priority) + T:\ (best-effort)
- `read-shared-brief.ps1` — reads the brief at SessionStart, auto-detects if catch-up is needed
- `mount-T.ps1` — simplified, silent on failure

**4 validated scenarios:**

1. Main PC alone — OK (T:\ = local disk)
2. Client PC alone, main PC off — OK (Drive cloud)
3. Main then client (LAN) — OK (Drive + T:\ cache)
4. Client then main (time-delayed) — OK (Drive catches up both ways)

See [Release notes](https://github.com/WoodyJ2H/claude-code-family/releases) for full details.

---

Clone your **entire development environment** across machines using Claude Code, SMB shares, and automated PowerShell scripts.

**Perfect for:**
- Parents & kids coding together on separate machines
- Developers with multiple laptops (office + home)
- Teaching assistants managing student environments
- Pair programming setups with instant sync

---

## What This Does

```
PC 1 (Main)                    Network SMB Share (T:\)                PC 2 (Secondary)
├── .env                       ├── secrets/                          ├── .env
├── credentials                ├── memory/ (80 files)                ├── credentials
├── SSH keys          ←→       ├── ssh/                      ←→      ├── SSH keys
├── .claude/                   ├── CLAUDE.md                         ├── .claude/
└── Node.js + Python           └── INSTALL.ps1                       └── Node.js + Python
```

Run **one PowerShell script** on PC 2. Everything syncs automatically:
- Secrets (`.env`, API keys, credentials)
- Claude Code configuration & memory (80 markdown files)
- SSH keys for VPS access
- Node.js + Python dependencies
- n8n MCP servers configuration

**Result**: Identical development environment, no manual copy-paste.

---

## Quick Start

### Prerequisites

**On both PCs:**
- Windows 10/11
- Node.js (LTS) — [download](https://nodejs.org)
- Python 3.11+ — [download](https://python.org)
- Git — [download](https://git-scm.com)

**Network:**
- Both PCs on same local network (LAN)
- One PC with shared folder (Primary PC)
- Network access credentials (if using passwords)

### Step 1: Share the Setup Folder (Primary PC)

On your **main PC** (MAIN-PC in the example):

1. Create a folder: `C:\TwinSetup\` (or wherever you prefer)
2. Copy this repo into it
3. Right-click → **Properties** → **Share** → Advanced Sharing → check **Share this folder**, name it `TwinSetup`
4. Note the network path: `\\PCNAME\TwinSetup`

**Recommended: create a dedicated local account for SMB access** (avoids issues with Microsoft accounts on Windows 11):

```powershell
# Run as Administrator on the Main PC
net user smb-user YourPassword123! /add
net localgroup "Users" smb-user /add
```

Then grant this user access to the shared folder in the Share permissions (Add → smb-user → Read or Full Control).

**If hostname resolution fails** (common on Windows 11 with Microsoft accounts): disable SMB signing requirement:

```powershell
# Run as Administrator on the Main PC
Set-SmbServerConfiguration -RequireSecuritySignature $false -Force
```

### Step 2: Configure twin-config.ps1 (Both PCs)

Copy `twin-config.ps1.example` to `twin-config.ps1` and customize:

```powershell
$TwinServerHost = "MAIN-PC"       # Your main PC's computer name
$TwinServerIP   = "192.168.1.100" # Fallback IP (set a static IP for reliability)
$TwinShareName  = "TwinSetup"     # Name of the shared folder
$TwinDrive      = "T:"            # Drive letter to use on client PCs
$TwinDriveDir   = "G:\My Drive\Claude Memory"  # Google Drive sync folder
```

> **Tip:** Set a static IP on your main PC (Windows Settings → Network → your connection → IP assignment → Manual) to avoid fallback failures.

### Step 3: Map Network Drive (Secondary PC)

On your **second PC** (CLIENT-PC in the example):

```powershell
# Run once to save credentials and map the drive persistently
cmdkey /add:MAIN-PC /user:smb-user /pass:YourPassword123!
net use T: \\MAIN-PC\TwinSetup /user:smb-user YourPassword123! /persistent:yes
```

Or use the automated script (after copying `twin-config.ps1`):

```powershell
# Creates a scheduled task that mounts T:\ automatically at every logon
# Run as Administrator
.\setup-automount.ps1
```

### Step 4: Run Installation Script (Secondary PC)

Open **PowerShell as Administrator** and run:

```powershell
# Option A: Run from mapped drive
cd T:\TwinSetup
.\INSTALL.ps1

# Option B: Run from GitHub (if drive mapping fails)
powershell -ExecutionPolicy Bypass -Command "& { (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/WoodyJ2H/claude-code-family/main/INSTALL.ps1').Content | Invoke-Expression }"
```

**The script will:**
- ✅ Verify Node.js, Python, Git are installed
- ✅ Install Claude Code CLI globally
- ✅ Create `C:\CLAUDE CODE` folder
- ✅ Copy secrets from network share
- ✅ Copy Claude Code config & memory files
- ✅ Copy SSH keys for VPS access
- ✅ Install Python dependencies

---

## What Gets Synced

| Item | Source (PC 1) | Destination (PC 2) | Purpose |
|------|---------------|------------------|---------|
| `.env` | `T:\secrets\` | `C:\CLAUDE CODE\` | API keys, tokens, database URLs |
| `credentials.json` | `T:\secrets\` | `C:\CLAUDE CODE\JOB SEEKING\` | Google OAuth tokens |
| `token.json` | `T:\secrets\` | `C:\CLAUDE CODE\JOB SEEKING\` | Google API refresh tokens |
| `linkedin-cookie.md` | `T:\secrets\` | `C:\CLAUDE CODE\Credentials\` | LinkedIn session data |
| `CLAUDE.md` | `T:\` | `~\.claude\` | Global Claude Code instructions |
| Memory files (80 .md) | `T:\memory\` | `~\.claude\projects\c--CLAUDE-CODE\memory\` | Project context & learnings |
| SSH keys (9 files) | `T:\ssh\` | `~\.ssh\` | SSH access to VPS / GitHub |
| MCP config | `T:\.mcp.json` | `C:\CLAUDE CODE\` | n8n-mcp, Hostinger, etc. |

---

## Troubleshooting

### "Network path not found"
- **Primary PC:** Verify the folder is shared. Right-click → Properties → Share tab → "Share..." button
- **Secondary PC:** Try UNC path directly: `\\MAIN-PC\TwinSetup` (replace `MAIN-PC` with your main PC's name)
- Check Windows Firewall/Norton: Allow SMB (port 445)

### PowerShell script closes immediately
- Open PowerShell **as Administrator**
- Navigate to `T:\TwinSetup` first: `cd T:\TwinSetup`
- Run: `.\INSTALL.ps1`
- (Not: double-click the .ps1 file)

### "Credentials not valid" or "Access denied"
- Use a **dedicated local account** (`smb-user`) instead of your Microsoft account — Microsoft accounts on Windows 11 often fail with SMB auth
- Save credentials with `cmdkey /add:MAIN-PC /user:smb-user /pass:YourPassword123!` on the client PC before mapping
- If still blocked: on the main PC, disable SMB signing: `Set-SmbServerConfiguration -RequireSecuritySignature $false -Force` (as Administrator)

### Drive mapping disappears
- Reopen **File Explorer** → **This PC** → **Map Network Drive**
- Check "Reconnect at sign-in"
- If network is "Public": Switch to "Private" in Windows Settings

### "Node.js not found"
- Download from [nodejs.org](https://nodejs.org) (LTS version)
- Install, then restart PowerShell
- Verify: `node --version` (should show v18+ or v20+)

---

## Advanced: Sync in Reverse (PC 2 → PC 1)

After editing code on PC 2, sync changes back to PC 1:

```powershell
# On PC 2
robocopy "C:\CLAUDE CODE\workflows-n8n" "T:\workflows-n8n" /MIR /R:3
robocopy "C:\Users\$env:USERNAME\.claude\projects" "T:\memory" /MIR
```

Or use **Settings Sync** built into VS Code (Ctrl+Shift+P → "Settings Sync: Turn On").

---

## Architecture Notes

### Source of Truth — Drive-first architecture (v3)

- **Google Drive** is the source of truth for `SHARED-BRIEF.md` (the session handoff file)
- **T:\ (SMB share)** is a best-effort LAN cache — never blocking
- If the main PC is off, the client PC reads Drive instead. No errors.

```
Session ends (main PC)   →  write-shared-brief.ps1  →  Drive (always) + T:\ (if online)
Session starts (client)  →  read-shared-brief.ps1   →  Drive (priority) → T:\ (fallback)
```

### Why SMB (not Dropbox/OneDrive)?
- ✅ Secrets stay on local network, never hit the cloud
- ✅ Works for large files without storage quotas
- ✅ Zero cost, works on any Windows LAN

### Why PowerShell Script (not Docker)?
- ✅ Works on Windows without Linux VM
- ✅ Idempotent — safe to run multiple times
- ✅ Easy to customize for your own setup

### What About Conflicts?
- Edit secrets on PC 2 → manually copy back to `T:\secrets\` before syncing again
- `SHARED-BRIEF.md` is always written by the machine that just finished work — no conflicts
- Workflows (n8n) live in the cloud — not synced locally

---

## Extending the Setup

### Add More Folders
Edit `INSTALL.ps1` and add copy operations:

```powershell
Copy-Item "T:\your-folder\*" "C:\CLAUDE CODE\your-folder\" -Force -Recurse
```

### Sync from PC 2 Back to PC 1
Create a `SYNC-BACK.ps1` on the secondary PC:

```powershell
robocopy "C:\CLAUDE CODE\projects" "T:\projects" /MIR
robocopy "$env:USERPROFILE\.claude\projects" "T:\memory" /MIR
```

### Automate Periodic Syncs
Use **Task Scheduler** to run `SYNC-BACK.ps1` nightly:
- Create a task
- Trigger: "On a schedule" → Daily at 2 AM
- Action: `powershell.exe -File C:\path\to\SYNC-BACK.ps1`

---

## For Parents & Kids

**Scenario:** You want your kids to code alongside you, but with their own PC.

1. **Set up Primary PC** (yours) with all your workflows, secrets, and SSH keys
2. **Give Secondary PC to kid(s)** with everything pre-configured
3. **Teach from same codebase** — you edit on your machine, they see it instantly
4. **Collaborative debugging** — both working in the same project folder structure

Example workflow:
```
Dad (PC 1): Writes n8n workflow
  ↓ (SMB share)
  ↓ (INSTALL.ps1)
Kid (PC 2): Sees workflow, asks questions
  ↓ (Live pair coding)
Kid (PC 2): Modifies the workflow
  ↓ (Manual copy back to T:\)
Dad (PC 1): Reviews changes
```

---

## For Pair Programming

**Scenario:** You and a colleague each have a laptop, and you want to work on the same codebase.

1. **Main developer** shares their setup folder
2. **Colleague** maps the network drive and runs the script
3. **Both have identical** environments in 5 minutes
4. **Collaborate** using VS Code's Live Share extension (optional)

---

## Reporting Issues

Found a bug or want to add a feature?

1. Fork this repo
2. Create a branch: `git checkout -b fix/your-issue`
3. Commit your changes
4. Push and open a Pull Request

Common issues to report:
- PowerShell execution problems on your Windows version
- Firewall/antivirus blocking the script
- Missing dependencies or incompatible tool versions
- Network share not appearing in File Explorer

---

## License

MIT License — use, modify, and share freely.

---

## Credits

Built to solve the "I want my second PC to be identical to my first" problem without cloud storage, manual copying, or complex tooling.

Inspired by DevOps practices (Infrastructure as Code) applied to personal development setups.

---

**Ready to sync? Map that network drive and run INSTALL.ps1.** 🚀
