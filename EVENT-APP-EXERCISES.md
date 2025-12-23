# 🎪 Event Nomination System - Brownfield Modernization Exercises

**Transform a pure JSP legacy application into clean, maintainable code using GitHub Copilot**

---

## 📋 Quick Start

### 1. Setup (5-10 minutes)
```powershell
cd Legacy_event_app\event
.\SETUP.ps1  # One-click setup
```

**Manual setup**: See [Legacy_event_app/event/SETUP-GUIDE.md](Legacy_event_app/event/SETUP-GUIDE.md)

### 2. Open VS Code
```powershell
code .
```

### 3. Start Exercises
Follow the 9 exercises below to modernize the application.

---

## 🎯 What You'll Build

Transform this **pure JSP chaos** → into **clean MVC architecture**

**Before (Current):**
- Everything in JSP files
- No separation of concerns
- Security vulnerabilities
- Impossible to test

**After (Goal):**
- Clean Model classes
- Repository pattern
- Servlet controllers
- Secure authentication
- Comprehensive tests

---

## 📚 Exercises Overview

| # | Exercise | Time | What You'll Learn |
|---|----------|------|-------------------|
| 1 | [Analyze Architecture](#-exercise-1-analyze-pure-jsp-architecture) | 30-40 min | Use Copilot to identify problems |
| 2 | [Extract Models](#-exercise-2-extract-model-classes) | 45-60 min | Create POJOs from JSP code |
| 3 | [Database Utility](#-exercise-3-create-database-utility) | 30-45 min | Extract connection management |
| 4 | [Create Servlets](#-exercise-4-extract-business-logic-to-servlets) | 60-90 min | Implement MVC pattern |
| 5 | [Repository Pattern](#-exercise-5-implement-repository-pattern) | 45-60 min | Separate data access |
| 6 | [Fix Security](#-exercise-6-fix-security-vulnerabilities) | 60-75 min | Hash passwords, add validation |
| 7 | [Validation Framework](#-exercise-7-add-validation-framework) | 45-60 min | Server-side validation |
| 8 | [Unit Tests](#-exercise-8-generate-unit-tests) | 60-90 min | Test legacy code |
| 9 | [Spring Boot (Optional)](#-exercise-9-spring-boot-migration-optional) | 2-3 hours | Modern framework migration |

**Total Time**: 4-6 hours (core exercises) + 2-3 hours (optional Spring Boot)

---

**Goal**: Use GitHub Copilot to understand the unique problems of pure JSP applications.

**Time**: 30-40 minutes

### 1.1 Analyze login.jsp

**Steps:**

1. Open [`web/login.jsp`](Legacy_event_app/event/web/login.jsp)

2. Select all code (Ctrl+A / Cmd+A)

3. Open **Copilot Chat** (Ctrl+Shift+I / Cmd+Shift+I)

4. Use this prompt:

```
Analyze this JSP page with embedded Java code and identify:
1. MVC violations (mixing presentation, business logic, data access)
2. Security vulnerabilities (SQL injection, password handling)
3. Resource management issues
4. Separation of concerns problems
5. Code that should be in Java classes vs JSP

Explain why each issue is problematic and provide severity ratings.
```

**Expected Findings:**

<details>
<summary>Click to reveal critical issues</summary>

- **Critical**: SQL injection via string concatenation (actually uses PreparedStatement but could be improved)
- **Critical**: Plain text password storage
- **High**: Database connection logic in JSP
- **High**: Session management in JSP
- **High**: Business logic (authentication) in presentation layer
- **Medium**: No error handling or logging
- **Medium**: Resource leaks potential
- **Low**: No input validation

</details>

### 1.2 Analyze nominate.jsp

**Steps:**

1. Open [`web/nominate.jsp`](Legacy_event_app/event/web/nominate.jsp)

2. Ask Copilot:

```
This JSP contains all layers of the application. Identify:
1. Data access code that should be in a repository
2. Business logic that should be in a service layer
3. Presentation code that belongs in JSP
4. Security concerns with the nomination process
5. Recommended refactoring strategy

Create a separation of concerns diagram.
```

### 1.3 Create Technical Debt Assessment

**Steps:**

1. Create file: `TECHNICAL-DEBT-EVENT-APP.md`

2. Ask Copilot:

```
Based on analysis of login.jsp, nominate.jsp, eventCreate.jsp, and approveList.jsp, create a comprehensive technical debt document:

1. Executive Summary
2. Architecture Assessment
   - Current: Pure JSP with scriptlets
   - Problems: No separation of concerns
   - Target: MVC with servlets and Java classes

3. Critical Issues (P0)
   - Security vulnerabilities
   - Resource management
   - Error handling

4. High Priority (P1)
   - Extract business logic
   - Create model classes
   - Implement repository pattern

5. Medium Priority (P2)
   - Add validation
   - Improve error handling
   - Add logging

6. Modernization Roadmap
   - Phase 1: Extract Java classes
   - Phase 2: Create servlets
   - Phase 3: Security hardening
   - Phase 4: Testing
   - Phase 5: Spring Boot migration

Include estimated effort for each phase.
```

**✅ Success Criteria:**
- Technical debt document created with 15+ issues identified
- Clear prioritization (P0, P1, P2)
- Modernization roadmap with phases
- Understanding of MVC separation needed

---

## 🏗️ Exercise 2: Extract Model Classes

**Goal**: Create POJOs for User, Event, and Nomination entities from JSP code.

**Time**: 45-60 minutes

### 2.1 Create User Model

**Steps:**

1. Create new file: `src/com/company/event/model/User.java`

2. Ask Copilot:

```
Based on the users table in setupDb.jsp:
- username (PRIMARY KEY)
- password
- role (ADMIN, CREATOR, APPROVER)

Create a User model class with:
1. Private fields
2. Constructor (all fields)
3. Default constructor
4. Getters and setters
5. toString(), equals(), hashCode()
6. Role enum (ADMIN, CREATOR, APPROVER)
7. JavaDoc comments

Follow Java Bean conventions.
```

**Expected Result:**

```java
package com.company.event.model;

public class User {
    private String username;
    private String password;
    private Role role;
    
    public enum Role {
        ADMIN, CREATOR, APPROVER
    }
    
    // Constructors, getters, setters...
}
```

### 2.2 Create Event Model

**Steps:**

1. Create file: `src/com/company/event/model/Event.java`

2. Ask Copilot:

```
Based on the events table schema:
- id (INTEGER PRIMARY KEY)
- name (TEXT)
- category (TEXT)
- from_date (TEXT)
- to_date (TEXT)
- max_people (INTEGER)
- per_head (REAL)
- total_amount (REAL)
- status (TEXT)

Create an Event model class with:
1. All fields with appropriate Java types
2. Category enum (Recreational, Training, Outbound, Family_Picnic)
3. Status enum (OPEN, CLOSED)
4. Constructors
5. Validation-friendly design
6. JavaDoc
7. Business method: calculateTotalAmount()
```

### 2.3 Create Nomination Model

**Steps:**

1. Create file: `src/com/company/event/model/Nomination.java`

2. Ask Copilot:

```
Based on nominations table:
- id
- event_id (foreign key)
- employee (username)
- nominee_name
- relation
- status (PENDING, APPROVED, REJECTED)
- approver
- remarks
- action_time

Create a Nomination model with:
1. All fields
2. Status enum
3. Relation enum (SELF, SPOUSE, CHILD, PARENT)
4. LocalDateTime for action_time
5. Reference to Event object (composition)
6. JavaDoc
```

### 2.4 Compile and Verify

**Steps:**

1. In VS Code terminal: 
   ```powershell
   mvn clean compile
   ```

2. Fix any compilation errors with Copilot's help

3. Ask Copilot:

```
Review my User, Event, and Nomination model classes and suggest:
1. Missing validations
2. Additional utility methods
3. Potential optimizations
4. JPA annotations for future Spring Boot migration
```

**✅ Success Criteria:**
- Three model classes created with all fields
- Enums for role, status, category, relation
- Project compiles without errors
- Models follow Java Bean conventions

---

## 🔧 Exercise 3: Create Database Utility

**Goal**: Replace scattered database connection code with a centralized utility.

**Time**: 30-40 minutes

### 3.1 Create Connection Manager

**Steps:**

1. Create file: `src/com/company/event/util/DatabaseManager.java`

2. Ask Copilot:

```
Create a DatabaseManager utility class for SQLite that:
1. Uses Singleton pattern
2. Gets database path from ServletContext
3. Provides getConnection() method
4. Implements connection pooling using HikariCP
5. Includes initialization method
6. Handles SQLite-specific configuration
7. Provides shutdown method
8. Includes proper error handling and logging

Add dependency to build.xml for HikariCP.
```

### 3.2 Create SQL Query Constants

**Steps:**

1. Create file: `src/com/company/event/util/SQLQueries.java`

2. Ask Copilot:

```
Extract all SQL queries from login.jsp, nominate.jsp, eventCreate.jsp, and approveList.jsp into constants.

Create a class with:
1. Public static final String for each query
2. Use ? placeholders for parameters
3. Organize by entity (USER_*, EVENT_*, NOMINATION_*)
4. Add comments explaining each query
5. Include both SELECT and DML statements
```

**Expected Structure:**

```java
public class SQLQueries {
    // User queries
    public static final String USER_LOGIN = 
        "SELECT role FROM users WHERE username=? AND password=?";
    
    // Event queries
    public static final String EVENT_CREATE = 
        "INSERT INTO events(...) VALUES(?,?,?,?,?,?,?,?)";
    
    // Nomination queries
    // ...
}
```

### 3.3 Create Result Set Mapper

**Steps:**

1. Create file: `src/com/company/event/util/ResultSetMapper.java`

2. Ask Copilot:

```
Create a utility class with static methods to map ResultSet to model objects:
1. mapToUser(ResultSet rs)
2. mapToEvent(ResultSet rs)
3. mapToNomination(ResultSet rs)
4. mapToList methods for collections

Handle SQLException and null values gracefully.
Include JavaDoc with usage examples.
```

**✅ Success Criteria:**
- DatabaseManager with connection pooling
- SQLQueries class with all queries as constants
- ResultSetMapper for clean data access
- No SQL queries hardcoded in JSP files (yet)

---

## 🎯 Exercise 4: Extract Business Logic to Servlets

**Goal**: Move authentication and business operations from JSP to servlets.

**Time**: 60-75 minutes

### 4.1 Create Authentication Servlet

**Steps:**

1. Create file: `src/com/company/event/servlet/LoginServlet.java`

2. Ask Copilot:

```
Create a LoginServlet that replaces the logic in login.jsp:
1. Handles POST requests for authentication
2. Uses DatabaseManager for connections
3. Uses SQLQueries constants
4. Sets session attributes for authenticated user
5. Redirects based on user role
6. Forwards to login.jsp with error message on failure
7. Proper resource management (try-with-resources)
8. Logging with java.util.logging

Map to /login URL pattern.
```

3. Update `web/web.xml`:

Ask Copilot:
```
Add servlet mapping for LoginServlet to /login
```

4. Simplify `login.jsp`:

Ask Copilot:
```
Refactor login.jsp to:
1. Remove all Java scriptlets (<%  %>)
2. Change form action to "login" servlet
3. Keep only presentation HTML
4. Use JSTL/EL for displaying error messages: ${errorMessage}
5. Add JSTL taglib directives
```

### 4.2 Create Event Management Servlet

**Steps:**

1. Create file: `src/com/company/event/servlet/EventServlet.java`

2. Ask Copilot:

```
Create EventServlet that handles:
1. GET: Fetch and display events (forward to eventList.jsp)
2. POST: Create new event (extract logic from eventCreate.jsp)
3. Validation: Check all required fields
4. Authorization: Only ADMIN can create events
5. Use Event model class
6. Calculate total_amount in Java (not JSP)
7. Return success/error messages

Map to /event URL pattern.
```

### 4.3 Create Nomination Servlet

**Steps:**

1. Create file: `src/com/company/event/servlet/NominationServlet.java`

2. Ask Copilot:

```
Create NominationServlet that handles:
1. GET: Display nomination form with available events
2. POST: Process row-by-row nomination submission
3. Create Nomination object from request parameters
4. Validate: nominee name, relation, event_id
5. Authorization: Only CREATOR role can nominate
6. Store employee from session
7. Set status to PENDING
8. Forward to success/error view

Map to /nomination URL pattern.
```

### 4.4 Create Approval Servlet

**Steps:**

1. Create file: `src/com/company/event/servlet/ApprovalServlet.java`

2. Ask Copilot:

```
Create ApprovalServlet that:
1. GET: List all pending nominations
2. POST: Approve or reject nominations
3. Parameters: nomination_id, action (APPROVE/REJECT), remarks
4. Authorization: Only APPROVER role
5. Update nomination with approver name, remarks, timestamp
6. Use LocalDateTime for action_time
7. Redirect to approval list with status message

Map to /approval URL pattern.
```

**✅ Success Criteria:**
- Four servlets created (Login, Event, Nomination, Approval)
- All servlets mapped in web.xml
- Business logic removed from JSP files
- JSP files simplified to presentation only
- Role-based authorization in servlets

---

## 🗄️ Exercise 5: Implement Repository Pattern

**Goal**: Separate data access logic into repository classes.

**Time**: 60-75 minutes

### 5.1 Create User Repository

**Steps:**

1. Create interface: `src/com/company/event/repository/UserRepository.java`

2. Ask Copilot:

```
Create UserRepository interface with methods:
- Optional<User> findByUsername(String username)
- Optional<User> authenticate(String username, String password)
- List<User> findAll()
- User save(User user)
- boolean updatePassword(String username, String newPassword)
- void delete(String username)

Use Optional for single results that might not exist.
```

3. Create implementation: `src/com/company/event/repository/UserRepositoryImpl.java`

4. Ask Copilot:

```
Implement UserRepository using:
1. DatabaseManager for connections
2. SQLQueries constants
3. ResultSetMapper for object creation
4. PreparedStatement for all queries
5. Try-with-resources for resource management
6. Proper exception handling
7. Logging

Include private helper method executeQuery() to reduce duplication.
```

### 5.2 Create Event Repository

**Steps:**

1. Create interface: `src/com/company/event/repository/EventRepository.java`

2. Ask Copilot:

```
Create EventRepository interface with:
- Optional<Event> findById(Long id)
- List<Event> findAll()
- List<Event> findByStatus(Event.Status status)
- List<Event> findByCategory(Event.Category category)
- Event save(Event event)
- Event update(Event event)
- void delete(Long id)
- int countNominationsByEvent(Long eventId)
```

3. Implement: `src/com/company/event/repository/EventRepositoryImpl.java`

### 5.3 Create Nomination Repository

**Steps:**

1. Create interface: `src/com/company/event/repository/NominationRepository.java`

2. Ask Copilot:

```
Create NominationRepository interface with:
- Optional<Nomination> findById(Long id)
- List<Nomination> findByEmployee(String username)
- List<Nomination> findByEventId(Long eventId)
- List<Nomination> findByStatus(Nomination.Status status)
- List<Nomination> findPendingNominations()
- Nomination save(Nomination nomination)
- Nomination approve(Long id, String approver, String remarks)
- Nomination reject(Long id, String approver, String remarks)
- void delete(Long id)
```

3. Implement: `src/com/company/event/repository/NominationRepositoryImpl.java`

### 5.4 Update Servlets to Use Repositories

**Steps:**

1. Open `LoginServlet.java`

2. Ask Copilot:

```
Refactor LoginServlet to use UserRepository:
1. Add UserRepository field
2. Initialize in init() method or use dependency injection pattern
3. Replace direct JDBC calls with repository methods
4. Remove database connection code
5. Use repository.authenticate(username, password)
```

3. Repeat for Event, Nomination, and Approval servlets

**✅ Success Criteria:**
- Three repository interfaces created
- Three repository implementations
- All CRUD operations implemented
- Servlets refactored to use repositories
- No direct JDBC code in servlets

---

## 🔒 Exercise 6: Fix Security Vulnerabilities

**Goal**: Address critical security issues in the application.

**Time**: 45-60 minutes

### 6.1 Implement Password Hashing

**Steps:**

1. Create file: `src/com/company/event/security/PasswordUtil.java`

2. Ask Copilot:

```
Create a PasswordUtil class with:
1. static String hashPassword(String plaintext) using BCrypt
2. static boolean verifyPassword(String plaintext, String hashed)
3. Use BCrypt (add jbcrypt dependency to build.xml)
4. Include proper salt generation
5. JavaDoc explaining security approach
```

3. Update `UserRepository.authenticate()`:

Ask Copilot:
```
Modify authenticate method to:
1. Fetch user by username only
2. Use PasswordUtil.verifyPassword to check password
3. Return Optional.empty() if verification fails
```

4. Create migration script: `web/migratePasswords.jsp`

Ask Copilot:
```
Create a one-time admin utility page that:
1. Reads all users from database
2. Hashes their plain text passwords using PasswordUtil
3. Updates database with hashed passwords
4. Displays migration results
5. Should only run once (add flag check)
```

### 6.2 Add CSRF Protection

**Steps:**

1. Create file: `src/com/company/event/security/CSRFFilter.java`

2. Ask Copilot:

```
Create a servlet filter that implements CSRF token protection:
1. Generate token for GET requests, store in session
2. Validate token for POST/PUT/DELETE requests
3. Reject requests with missing/invalid tokens
4. Exclude login page from validation
5. Add token to request attribute for JSP access

Map filter to /* in web.xml.
```

3. Update all JSP forms:

Ask Copilot:
```
Add hidden CSRF token field to all forms in:
- eventCreate.jsp
- nominate.jsp
- approveList.jsp

Use: <input type="hidden" name="csrf_token" value="${csrfToken}">
```

### 6.3 Add Input Validation

**Steps:**

1. Create file: `src/com/company/event/validation/ValidationUtil.java`

2. Ask Copilot:

```
Create validation utility with methods:
1. validateUsername(String) - alphanumeric, 3-20 chars
2. validateEventName(String) - not empty, max 100 chars
3. validateNomineeName(String) - letters and spaces only
4. validateRelation(String) - must be valid Relation enum
5. validateDate(String) - valid date format, not in past
6. validateAmount(double) - positive number
7. sanitizeInput(String) - remove potential XSS characters

Return ValidationResult object with isValid and error messages.
```

3. Update servlets to validate input:

Ask Copilot:
```
Add validation to EventServlet.doPost():
1. Validate all input fields using ValidationUtil
2. If validation fails, return to form with error messages
3. Use request.setAttribute("errors", errorMap)
4. Only proceed if all validations pass
```

### 6.4 Add Authorization Filter

**Steps:**

1. Create file: `src/com/company/event/security/AuthorizationFilter.java`

2. Ask Copilot:

```
Create a filter that enforces role-based access:
1. Check if user is logged in (session.getAttribute("user"))
2. Check if user has required role for the resource:
   - /event* requires ADMIN
   - /nomination* requires CREATOR
   - /approval* requires APPROVER
3. Redirect to login if not authenticated
4. Show 403 error if not authorized
5. Allow login and static resources without authentication

Map in web.xml with URL patterns.
```

**✅ Success Criteria:**
- Password hashing implemented with BCrypt
- CSRF protection filter in place
- Input validation utility created
- Authorization filter enforcing role-based access
- All forms include CSRF tokens
- No plain text passwords in database

---


### 6.5 Protect Against SQL Injection

**Steps:**

1. Analyze existing queries for SQL injection vulnerabilities

Ask Copilot:
```
Review all JSP files (login.jsp, nominate.jsp, eventCreate.jsp, approveList.jsp) and identify:
1. Any SQL queries using string concatenation
2. Direct use of user input in SQL queries
3. Missing PreparedStatement usage
4. Potential SQL injection attack vectors

For each vulnerability, explain:
- How an attacker could exploit it
- Example attack payload
- Severity rating (Critical/High/Medium)
```

2. Create SQL Injection test cases

Create file: `test/com/company/event/security/SQLInjectionTest.java`

Ask Copilot:
```
Create test cases that attempt SQL injection attacks:
1. Login bypass: username = "admin' OR '1'='1"
2. Data extraction: username = "admin'; SELECT * FROM users--"
3. Table deletion: eventName = "Test'; DROP TABLE events--"
4. Union injection: relation = "SELF' UNION SELECT password FROM users--"
5. Boo4ean-based blind: username = "admin' AND '1'='1"

Each test should:
- Attempt the injection
- Verify it's blocked by PreparedStatements
- Confirm no data corruption occurred
- Log the attempt for security monitoring
```

3. Refactor vulnerable code to use PreparedStatements

Ask Copilot:
```
Review all repository implementations and ensure:
1. Every SQL query uses PreparedStatement (not Statement)
2. All user input is parameterized with ? placeholders
3. No string concatenation in SQL queries
4. Example conversion:

Before (vulnerable):
String sql = "SELECT * FROM users WHERE username='" + username + "'";
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery(sql);

After (safe):
String sql = "SELECT * FROM users WHERE username=?";
PreparedStatement ps = conn.prepareStatement(sql);
ps.setString(1, username);
ResultSet rs = ps.executeQuery();

Apply this to all queries in:
- UserRepositoryImpl
- EventRepositoryImpl
- NominationRepositoryImpl
```

4. Create SQL Injection prevention utility

Create file: `src/com/company/event/security/SQLInjectionGuard.java`

Ask Copilot:
```
Create a utility class that detects potential SQL injection attempts:
1. detectSQLInjection(String input) - returns boolean
2. Check for SQL keywords: SELECT, INSERT, UPDATE, DELETE, DROP, UNION, OR
3. Check for SQL operators: --, /*, */, ', ", ;
4. Check for SQL functions: CONCAT, SUBSTRING, EXEC, CAST
5. logSuspiciousInput(String input, String source) - logs attempts
6. sanitizeForLogging(String input) - safe logging without exposing data

Use this as an additional security layer in servlets before processing input.
Include JavaDoc explaining this is defense-in-depth, PreparedStatements are primary defense.
```





## ✅ Exercise 7: Add Validation Framework

**Goal**: Implement comprehensive validation with meaningful error messages.

**Time**: 30-40 minutes

### 7.1 Create Validation Framework

**Steps:**

1. Create file: `src/com/company/event/validation/ValidationResult.java`

2. Ask Copilot:

```
Create a ValidationResult class that:
1. Stores boolean isValid
2. Stores Map<String, String> errors (field → error message)
3. Provides addError(String field, String message)
4. Provides hasErrors()
5. Provides getErrors()
6. Provides getError(String field)
7. Provides fluent API for chaining
```

### 7.2 Create Entity Validators

**Steps:**

1. Create file: `src/com/company/event/validation/EventValidator.java`

2. Ask Copilot:

```
Create EventValidator that validates Event objects:
1. validate(Event event) returns ValidationResult
2. Check name not empty, max 100 chars
3. Check category is valid enum value
4. Check dates: fromDate < toDate, not in past
5. Check maxPeople > 0
6. Check perHead > 0
7. Verify calculated totalAmount = maxPeople * perHead
```

3. Create `NominationValidator.java` and `UserValidator.java` similarly

### 7.3 Update Servlets with Validation

**Steps:**

1. Open `EventServlet.java`

2. Ask Copilot:

```
Update EventServlet.doPost() to:
1. Create Event object from request parameters
2. Use EventValidator.validate(event)
3. If validation fails:
   - Set errors in request: request.setAttribute("errors", result.getErrors())
   - Set form data back: request.setAttribute("event", event)
   - Forward back to eventCreate.jsp
4. Only save to database if validation passes
```

### 7.4 Display Validation Errors in JSP

**Steps:**

1. Open `eventCreate.jsp`

2. Ask Copilot:

```
Update eventCreate.jsp to display validation errors:
1. Add JSTL import: <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
2. Above each input field, check for errors:
   <c:if test="${not empty errors.name}">
     <div class="alert alert-danger">${errors.name}</div>
   </c:if>
3. Populate form fields with previous values: value="${event.name}"
4. Add general error display at top of form
5. Add success message display
```

**✅ Success Criteria:**
- Validation framework with ValidationResult
- Validators for all entities
- Servlets validate before saving
- JSP displays field-specific errors
- Form data retained on validation failure

---

## 🧪 Exercise 8: Generate Unit Tests

**Goal**: Create comprehensive tests for repositories, validators, and servlets.

**Time**: 60-75 minutes

### 8.1 Setup Testing Framework

**Steps:**

1. Update `build.xml` to add test dependencies

2. Ask Copilot:

```
Add JUnit 5 and Mockito dependencies to build.xml:
- junit-jupiter-api: 5.9.3
- junit-jupiter-engine: 5.9.3
- mockito-core: 5.3.1
- sqlite-jdbc (for test database)

Add test source folder and test target in build.xml.
```

3. Create test folder: `test/com/company/event/`

### 8.2 Test Repository Layer

**Steps:**

1. Create file: `test/com/company/event/repository/UserRepositoryTest.java`

2. Ask Copilot:

```
Generate comprehensive tests for UserRepository:
1. Use in-memory SQLite database (:memory:)
2. Setup @BeforeEach to create fresh database and tables
3. Test methods:
   - testFindByUsername_Success
   - testFindByUsername_NotFound
   - testAuthenticate_Success
   - testAuthenticate_WrongPassword
   - testAuthenticate_UserNotExist
   - testSave_NewUser
   - testFindAll
   - testUpdatePassword
   - testDelete

Use AssertJ for fluent assertions.
Mock DatabaseManager if needed.
```

3. Create similar tests for:
   - `EventRepositoryTest.java`
   - `NominationRepositoryTest.java`

### 8.3 Test Validation Layer

**Steps:**

1. Create file: `test/com/company/event/validation/EventValidatorTest.java`

2. Ask Copilot:

```
Generate parameterized tests for EventValidator:
1. Test valid event - no errors
2. Test empty name - error on name field
3. Test name too long - error on name field
4. Test invalid dates - fromDate after toDate
5. Test dates in past
6. Test negative maxPeople
7. Test negative perHead
8. Test invalid category

Use @ParameterizedTest with @MethodSource for multiple scenarios.
```

### 8.4 Test Servlet Layer

**Steps:**

1. Create file: `test/com/company/event/servlet/LoginServletTest.java`

2. Ask Copilot:

```
Generate servlet tests using Mockito:
1. Mock HttpServletRequest, HttpServletResponse, HttpSession
2. Mock UserRepository
3. Test successful login - verify redirect
4. Test failed login - verify error message
5. Test role-based redirects (ADMIN, CREATOR, APPROVER)
6. Test session attribute setting
7. Verify repository method calls

Use @Mock, @InjectMocks annotations.
```

### 8.5 Test Security Utilities

**Steps:**

1. Create file: `test/com/company/event/security/PasswordUtilTest.java`

2. Ask Copilot:

```
Test password hashing utility:
1. Test hashPassword generates different hashes for same input (salt)
2. Test verifyPassword with correct password returns true
3. Test verifyPassword with wrong password returns false
4. Test null/empty password handling
5. Performance test: hashing should take < 500ms
```

### 8.6 Run Tests

**Steps:**

```powershell
# Run all tests
ant test

# Generate coverage report (add JaCoCo to build.xml first)
ant test-coverage
```

**✅ Success Criteria:**
- Unit tests for all repositories (15+ tests)
- Validation tests (10+ tests)
- Servlet tests with mocking (12+ tests)
- Security utility tests (5+ tests)
- All tests passing
- Minimum 70% code coverage

---

## 🚀 Exercise 9: Spring Boot Migration (Optional)

**Goal**: Migrate to Spring Boot with Spring MVC, JPA, and Thymeleaf.

**Time**: 3-4 hours

### 9.1 Create Spring Boot Project Structure

**Steps:**

1. Ask Copilot:

```
Create a migration plan to convert this Ant-based JSP application to Spring Boot:

1. List required Spring Boot dependencies:
   - spring-boot-starter-web
   - spring-boot-starter-data-jpa
   - spring-boot-starter-security
   - spring-boot-starter-thymeleaf
   - sqlite-jdbc
   - hibernate-community-dialects (for SQLite JPA support)

2. Identify servlet to controller mappings
3. Plan JPA entity conversion
4. Outline Spring Security configuration
5. Thymeleaf template migration from JSP

Provide step-by-step migration order.
```

### 9.2 Convert Models to JPA Entities

**Steps:**

1. Open `User.java`

2. Ask Copilot:

```
Convert User POJO to JPA entity:
1. Add @Entity annotation
2. Add @Table(name = "users")
3. Add @Id to username field
4. Add @Enumerated(EnumType.STRING) to role field
5. Add @Column annotations with constraints
6. Keep existing constructors and methods
```

3. Repeat for `Event.java` and `Nomination.java`

4. For `Nomination.java`, add relationship:

```
Add @ManyToOne relationship to Event:
@ManyToOne
@JoinColumn(name = "event_id")
private Event event;
```

### 9.3 Create Spring Data Repositories

**Steps:**

1. Create file: `src/main/java/com/company/event/repository/UserRepository.java`

2. Ask Copilot:

```
Convert UserRepository interface to Spring Data JPA:
1. Extend JpaRepository<User, String>
2. Add custom query methods:
   - Optional<User> findByUsernameAndPassword(String username, String password)
   - Optional<User> findByUsername(String username)
3. Add @Repository annotation
4. Remove implementation class (Spring Data handles it)
```

3. Repeat for `EventRepository` and `NominationRepository`

### 9.4 Create Spring MVC Controllers

**Steps:**

1. Create file: `src/main/java/com/company/event/controller/AuthController.java`

2. Ask Copilot:

```
Create Spring MVC controller for authentication:
1. @Controller annotation
2. @Autowired UserRepository
3. @GetMapping("/login") - show login form
4. @PostMapping("/login") - process login
5. Use Model to pass data to view
6. Return view names (Thymeleaf templates)
7. Handle authentication with Spring Security
```

2. Create controllers for:
   - `EventController` - event management
   - `NominationController` - nominations
   - `ApprovalController` - approvals

### 9.5 Configure Spring Security

**Steps:**

1. Create file: `src/main/java/com/company/event/config/SecurityConfig.java`

2. Ask Copilot:

```
Create Spring Security configuration:
1. Extend WebSecurityConfigurerAdapter
2. Configure HttpSecurity:
   - /login, /css/**, /js/** - permit all
   - /event/** - hasRole("ADMIN")
   - /nomination/** - hasRole("CREATOR")
   - /approval/** - hasRole("APPROVER")
   - All other requests require authentication
3. Configure form login
4. Configure logout
5. Enable CSRF protection
6. Configure password encoder (BCrypt)
```

### 9.6 Convert JSP to Thymeleaf

**Steps:**

1. Create file: `src/main/resources/templates/login.html`

2. Ask Copilot:

```
Convert login.jsp to Thymeleaf template:
1. Use Thymeleaf namespace: xmlns:th="http://www.thymeleaf.org"
2. Replace scriptlets with Thymeleaf expressions:
   - ${errorMessage} for error display
   - th:action="@{/login}" for form action
   - th:field for form inputs
3. Use layout dialect for header inclusion
4. Keep Bootstrap styling
5. Add CSRF token (automatic with Spring Security)
```

3. Convert all JSP files to Thymeleaf:
   - `eventCreate.html`
   - `nominate.html`
   - `approveList.html`
   - `myNominations.html`

### 9.7 Create Application Configuration

**Steps:**

1. Create file: `src/main/resources/application.properties`

2. Ask Copilot:

```
Create Spring Boot application.properties:
1. Server configuration (port 8080)
2. Database configuration:
   - spring.datasource.url=jdbc:sqlite:nomination.db
   - spring.jpa.database-platform=org.hibernate.community.dialect.SQLiteDialect
   - spring.jpa.hibernate.ddl-auto=update
3. Thymeleaf configuration
4. Logging configuration
5. Security configuration
```

### 9.8 Create Main Application Class

**Steps:**

1. Create file: `src/main/java/com/company/event/EventApplication.java`

2. Ask Copilot:

```
Create Spring Boot main application class:
1. @SpringBootApplication annotation
2. public static void main method
3. SpringApplication.run()
4. Optional: CommandLineRunner to insert default users
```

### 9.9 Test Spring Boot Application

**Steps:**

```powershell
# Build
mvn clean package

# Run
mvn spring-boot:run

# Access application
http://localhost:8080/login
```

### 9.10 Create Spring Boot Tests

**Steps:**

1. Create file: `src/test/java/com/company/event/controller/EventControllerTest.java`

2. Ask Copilot:

```
Create integration test for EventController:
1. Use @SpringBootTest
2. Use @AutoConfigureMockMvc
3. Use MockMvc to test endpoints
4. Test:
   - GET /events - returns event list
   - POST /events - creates event (with ADMIN role)
   - POST /events - rejected without ADMIN role
   - GET /events/{id} - returns single event
5. Use @WithMockUser for authentication
```

**✅ Success Criteria:**
- Spring Boot application runs successfully
- All JPA entities created with relationships
- Spring Data repositories functional
- Spring MVC controllers handle all operations
- Thymeleaf templates render correctly
- Spring Security enforces role-based access
- Integration tests passing
- No servlet dependencies remaining

---

## 🎯 Summary & Comparison

### What You've Accomplished

After completing these exercises, you've transformed:

#### **Before (Pure JSP)**
```
├── login.jsp (200 lines)
│   └── Authentication logic
│   └── Database connection
│   └── Session management
│   └── HTML presentation
│   └── SQL queries
```

#### **After (MVC Architecture)**
```
├── Model Layer
│   ├── User.java
│   ├── Event.java
│   └── Nomination.java
├── Repository Layer
│   ├── UserRepository.java
│   ├── EventRepository.java
│   └── NominationRepository.java
├── Service Layer (optional)
├── Controller Layer
│   ├── LoginServlet.java
│   ├── EventServlet.java
│   ├── NominationServlet.java
│   └── ApprovalServlet.java
├── View Layer
│   ├── login.jsp (simplified)
│   ├── eventCreate.jsp
│   └── nominate.jsp
├── Security
│   ├── PasswordUtil.java
│   ├── CSRFFilter.java
│   └── AuthorizationFilter.java
└── Tests (40+ unit tests)
```

### Key Transformations

| Aspect | Before | After |
|--------|--------|-------|
| **Architecture** | Pure JSP scriptlets | MVC with servlets |
| **Data Access** | SQL in JSP | Repository pattern |
| **Security** | Plain text passwords | BCrypt hashed |
| **Validation** | None | Comprehensive framework |
| **Testing** | 0 tests | 40+ tests |
| **Separation** | Everything in JSP | Proper layering |
| **Error Handling** | printStackTrace | Proper logging |
| **Code Quality** | ~200 lines per JSP | ~50 lines each class |

---

## 📚 Additional Resources

### Best Practices

- **Extract incrementally** - Don't rewrite everything at once
- **Test after each refactoring** - Ensure functionality preserved
- **Commit frequently** - Track each improvement
- **Document decisions** - Why each change was made
- **Review with Copilot** - Ask for code review suggestions

### Learning Resources

- [JSP to Servlet Migration](https://docs.oracle.com/javaee/6/tutorial/doc/bnafd.html)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
- [Spring Boot Migration Guide](https://spring.io/guides/gs/serving-web-content/)
- [OWASP Security](https://owasp.org/www-project-top-ten/)
- [GitHub Copilot Best Practices](https://docs.github.com/en/copilot)

---

## 🤝 Contributing

Found an issue or have improvements? Please submit a PR!

---

<div align="center">

**Transform Legacy JSP to Modern Spring Boot!** 🚀

[Back to Main README](README.md) | [Report Issue](../../issues)

Built with ❤️ for legacy modernization

</div>
