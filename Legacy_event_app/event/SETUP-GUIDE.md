# PowerShell Setup Guide - Event Nomination System

**Detailed manual setup steps if SETUP.ps1 doesn't work for you.**

---

## Prerequisites

- Windows 10/11
- PowerShell 5.1+
- Internet connection (for downloads)

---

## Step-by-Step Setup

### Step 1: Navigate to Project

```powershell
# Adjust path for your system
cd "C:\Users\akashdwivedi\OneDrive - Microsoft\Desktop\IntrestingIdeas\WorkshopRepro\Legacy-Application-Brownfield-Github-Copilot-\Legacy_event_app\event"

# Verify location
Get-ChildItem | Select-Object Name

# You should see: pom.xml, web/, src/, README.md
```

---

## Step 2: Check Java

```powershell
java -version
```

**✅ Expected Output:**
```
openjdk version "11.0.x" or higher
```

**❌ If Not Found:**
1. Download Java: https://adoptium.net/temurin/releases/
2. Choose: **Windows x64**, **JDK 11 LTS** or higher
3. Run installer → **Check "Add to PATH"**
4. **Close and reopen PowerShell**
5. Try `java -version` again

---

## Step 3: Check Maven

```powershell
mvn -version
```

**✅ Expected Output:**
```
Apache Maven 3.x.x
Maven home: C:\Program Files\Apache\maven
Java version: 11.x.x
```

**❌ If Not Found:**

### Option A: Install via Chocolatey (Recommended)
```powershell
# Install Chocolatey first (if not installed)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Maven
choco install maven -y

# Close and reopen PowerShell
```

### Option B: Manual Install
1. Download: https://maven.apache.org/download.cgi
2. Extract to: `C:\Program Files\Apache\maven`
3. Add to PATH:
   ```powershell
   # Run PowerShell as Administrator
   [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Apache\maven\bin", [System.EnvironmentVariableTarget]::Machine)
   ```
4. **Close and reopen PowerShell**
5. Try `mvn -version` again

---

## Step 4: Clean Build

```powershell
mvn clean
```

**✅ Expected Output:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: 2-5 seconds
```

---

## Step 5: Compile & Package

```powershell
mvn package
```

**✅ Expected Output:**
```
[INFO] Building war: ...\target\event.war
[INFO] BUILD SUCCESS
[INFO] Total time: 10-30 seconds
```

**Note:** First run downloads dependencies (~50-100MB) - may take 2-5 minutes.

---

## Step 6: Start Server

```powershell
mvn jetty:run
```

**✅ Expected Output:**
```
[INFO] Started Jetty Server
[INFO] Started ServerConnector@xxxxx{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
```

**⚠️ IMPORTANT: Keep this window open! Server is running here.**

---

## Step 7: Test Server (New Window)

Open a **NEW PowerShell window** and run:

```powershell
# Test if server responds
Invoke-WebRequest -Uri "http://localhost:8080/event/" -UseBasicParsing | Select-Object StatusCode

# Should show: StatusCode: 200
```

---

## Step 8: Initialize Database

```powershell
# Open setup page in browser
Start-Process "http://localhost:8080/event/setupDb.jsp"
```

**✅ You should see in browser:**
```
Database setup successful!
Tables created: users, events, nominations
Sample data inserted.
```

---

## Step 9: Test Login

```powershell
# Open login page
Start-Process "http://localhost:8080/event/login.jsp"
```

**In the browser, test these logins:**

| Username | Password | Role | Test Action |
|----------|----------|------|-------------|
| `admin` | `admin` | ADMIN | Should see "Create Event" link |
| `emp1` | `emp1` | CREATOR | Should see "Nominate" link |
| `approver` | `approver` | APPROVER | Should see "Approve Nominations" link |

---

## Step 10: Quick Functionality Test

### Test 1: Create Event (Admin)
1. Login as `admin/admin`
2. Click **"Create Event"**
3. Fill in:
   - Event Name: "Test Event"
   - Category: "Recreational"
   - Dates: Any future dates
   - Max People: 50
   - Cost Per Head: 1000
4. Submit → Should see "Event created successfully"

### Test 2: Nominate (Employee)
1. Logout → Login as `emp1/emp1`
2. Click **"Nominate"**
3. Select the "Test Event"
4. Fill in:
   - Nominee Name: "John Doe"
   - Relation: "self"
5. Submit → Should see "Nomination submitted"

### Test 3: Approve (Approver)
1. Logout → Login as `approver/approver`
2. Click **"Approve Nominations"**
3. Should see the nomination from emp1
4. Click **"Approve"** or **"Reject"**
5. Status should update

---

## ✅ Setup Complete!

If all steps passed:
- ✅ Java and Maven installed
- ✅ Project builds successfully
- ✅ Server runs on port 8080
- ✅ Database created with sample data
- ✅ All user roles work
- ✅ Basic CRUD operations function

**Keep the server running in PowerShell window #1**

---

## 🚀 Next: Open VS Code

In a **NEW PowerShell window**:

```powershell
# Navigate to project
cd "C:\Users\akashdwivedi\OneDrive - Microsoft\Desktop\IntrestingIdeas\WorkshopRepro\Legacy-Application-Brownfield-Github-Copilot-\Legacy_event_app\event"

# Open in VS Code
code .
```

Then follow the exercises in: **EVENT-APP-EXERCISES.md**

---

## 🔧 Troubleshooting

### Port 8080 Already in Use

```powershell
# Find process using port 8080
netstat -ano | findstr :8080

# Kill the process (replace <PID> with actual process ID)
taskkill /PID <PID> /F

# Or restart server on different port by editing pom.xml
```

### Build Fails

```powershell
# Clean Maven cache
mvn clean -U

# Delete local repository (nuclear option)
Remove-Item -Recurse -Force "$env:USERPROFILE\.m2\repository"
mvn clean install
```

### Database Not Created

```powershell
# Manually create database folder
New-Item -ItemType Directory -Path ".\build\web\WEB-INF" -Force

# Run setup again
Start-Process "http://localhost:8080/event/setupDb.jsp"
```

### Server Won't Stop

```powershell
# Force kill all Java processes (use carefully!)
Get-Process java | Stop-Process -Force
```

---

## 📞 Need Help?

- Check main [README.md](../../README.md)
- See detailed guide: [VSCODE-SETUP.md](VSCODE-SETUP.md)
- Review exercises: [EVENT-APP-EXERCISES.md](../../EVENT-APP-EXERCISES.md)
