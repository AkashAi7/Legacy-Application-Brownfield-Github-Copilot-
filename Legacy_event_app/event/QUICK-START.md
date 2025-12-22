# 🎪 Event App Workshop - Quick Reference

## 📁 Clean File Structure

```
Legacy_event_app/event/
├── SETUP.ps1                    # ⭐ ONE-CLICK SETUP - Start here!
├── README.md                    # Project overview & quick start
├── SETUP-GUIDE.md              # Detailed PowerShell steps (if needed)
├── pom.xml                     # Maven configuration
├── web/                        # JSP files (legacy code)
└── .vscode/                    # VS Code settings
```

```
Root/
└── EVENT-APP-EXERCISES.md      # ⭐ All 9 brownfield exercises
```

---

## 🚀 Getting Started (3 Steps)

### Step 1: One-Click Setup

**Option A: Right-click file**
- Right-click `SETUP.ps1` → "Run with PowerShell"

**Option B: Command line**
```powershell
cd Legacy_event_app\event
.\SETUP.ps1
```
⚠️ Note the `.\` prefix - required by PowerShell!

This automatically:
- Checks/installs Java & Maven
- Builds the project  
- Starts the server
- Opens browser

### Step 2: Test Application
Login with any account:
- `admin/admin` - Create events
- `emp1/emp1` - Nominate
- `approver/approver` - Approve

### Step 3: Start Exercises
```powershell
code .  # Open VS Code
```
Follow: `EVENT-APP-EXERCISES.md`

---

## 📚 Documentation Map

| File | Purpose | When to Use |
|------|---------|-------------|
| **SETUP.ps1** | Automated setup script | First thing to run |
| **README.md** | Project overview | Understanding the app |
| **SETUP-GUIDE.md** | Manual PowerShell steps | If SETUP.ps1 fails |
| **EVENT-APP-EXERCISES.md** | 9 modernization exercises | Learning & coding |

---

## 🎯 Workshop Flow

1. **Run SETUP.ps1** (5-10 min)
   - Automated environment setup
   
2. **Test Application** (5 min)
   - Verify all 3 user roles work
   
3. **Read README.md** (5 min)
   - Understand the legacy problems
   
4. **Open VS Code** (1 min)
   - `code .`
   
5. **Follow EVENT-APP-EXERCISES.md** (4-6 hours)
   - Exercise 1: Analyze (30-40 min)
   - Exercise 2: Extract Models (45-60 min)
   - Exercise 3: Database Utility (30-45 min)
   - Exercise 4: Servlets (60-90 min)
   - Exercise 5: Repository (45-60 min)
   - Exercise 6: Security (60-75 min)
   - Exercise 7: Validation (45-60 min)
   - Exercise 8: Tests (60-90 min)
   - Exercise 9: Spring Boot (optional, 2-3 hours)

---

## ✅ What Was Cleaned Up

### Removed/Consolidated:
- ❌ VSCODE-SETUP.md (merged into README)
- ❌ POWERSHELL-SETUP-STEPS.md (renamed to SETUP-GUIDE.md)
- ❌ Redundant setup instructions

### Simplified To:
- ✅ **SETUP.ps1** - One-click automation
- ✅ **README.md** - Clean project overview
- ✅ **SETUP-GUIDE.md** - Backup manual steps
- ✅ **EVENT-APP-EXERCISES.md** - Focused exercises

---

## 🔧 Quick Commands

### Setup
```powershell
.\SETUP.ps1                      # One-click setup
```

### Manual Commands (if needed)
```powershell
mvn clean package                # Build
mvn jetty:run                    # Start server
Start-Process "http://localhost:8080/event/setupDb.jsp"  # Init DB
code .                           # Open VS Code
```

### Troubleshooting
```powershell
netstat -ano | findstr :8080     # Check port usage
Get-Process java | Stop-Process  # Kill Java processes
mvn clean -U                     # Clean build
```

---

## 🎓 Learning Path

**Beginner → Intermediate → Advanced**

1. **Start**: Run SETUP.ps1, test app
2. **Learn**: Read README, understand problems
3. **Practice**: Exercises 1-3 (basics)
4. **Apply**: Exercises 4-6 (MVC refactoring)
5. **Master**: Exercises 7-8 (validation & testing)
6. **Advance**: Exercise 9 (Spring Boot migration)

---

**Everything is now clean, organized, and ready to use! 🎉**

**Start with: `.\SETUP.ps1`**
