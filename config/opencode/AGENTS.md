
# Global Coding Guidelines for AI Agents

## Purpose

This document provides comprehensive guidance for AI coding agents working on this codebase. It enforces architectural principles, coding standards, and best practices across all supported languages (OCaml, SQL, Go, Python, TypeScript, JavaScript, Bash, C, C++).

**This is not merely a style guide—it is a contract for software excellence.**

---

## Core Operating Protocol

### The Clarification-First Mandate

**BEFORE writing ANY code, the agent MUST:**

1. **Understand the Complete Context**
   - What problem are we solving? (State the problem in EARS format)
   - Why does this problem need solving now?
   - What are the constraints and assumptions?
   - What are the dependencies and side effects?

2. **Define Clear Win Conditions**
   - What does "done" look like?
   - How will we verify correctness?
   - What are the acceptance criteria?
   - What edge cases must be handled?

3. **Plan the Implementation Strategy**
   - Break down the work into discrete steps
   - Identify risks and unknowns
   - Determine what needs to be measured or validated
   - Specify the order of operations

4. **Seek Approval for the Plan**
   - Present the understanding, win conditions, and strategy
   - Request confirmation or correction
   - **REFUSE TO PROCEED until the plan is validated**
   - Iterate on the plan based on feedback

**Rationale:** As per "How to write a good design document" (Grant Slatton), good engineering starts with clarity of thought. Code is expensive to change—planning is cheap. A clear plan prevents wasted effort, reduces defects, and ensures alignment with actual requirements.

### Ambiguity Resolution Protocol

When encountering ambiguity:

1. **HALT** - Do not make assumptions or proceed
2. **ENUMERATE** - List all possible interpretations
3. **QUESTION** - Ask specific clarifying questions:
   - "Do you mean X or Y?"
   - "Should this handle case Z?"
   - "What should happen when condition W occurs?"
4. **CONFIRM** - Verify understanding before proceeding

**Example Ambiguity Resolution:**

❌ BAD:
User: "Add error handling to the database layer"
Agent: *Adds try-catch blocks everywhere*

✅ GOOD:
User: "Add error handling to the database layer"
Agent: "I need clarification on the error handling requirements:
1. Which specific errors should be caught? (Connection timeouts, constraint violations, deadlocks, etc.)
2. What is the desired behavior for each error type? (Retry, log and fail, return default, raise to caller?)
3. Should we implement circuit breaker patterns for connection failures?
4. What is the expected recovery strategy for transient vs. permanent failures?
5. Should error details be logged? If so, what information (sanitizing PII)?

Win Condition: Database operations fail gracefully with appropriate retries, logging, and error propagation.

Proposed Steps:
1. Categorize database errors (transient, permanent, fatal)
2. Implement retry logic with exponential backoff for transient errors
3. Add structured logging for all error paths
4. Define error boundary for propagation vs. handling
5. Add integration tests for each error scenario

May I proceed with this approach?"

---

## Philosophical Foundation

### Guiding Principles (Tiger Style + 12-Factor App)

**Safety First (Tiger Style)**
- Write code that works in **all** situations, not just the happy path
- Design for failure—assume everything will fail and plan accordingly
- Use assertions aggressively to catch impossible states
- Fail fast and loud—detect problems as early as possible

**Performance from the Start (Tiger Style)**
- Use napkin math during design—estimate before implementing
- Optimize in order: Network → Disk → Memory → CPU
- Static memory allocation prevents fragmentation and OOM errors
- Batch operations to amortize overhead

**Developer Experience (Tiger Style)**
- Get the nouns and verbs right—names should reveal intent
- Code should read like prose to domain experts
- Minimize cognitive load through simplicity
- Make the right thing easy and the wrong thing hard

**12-Factor Methodology for Cloud-Native Systems**
1. **Codebase** - One codebase tracked in version control, many deploys
2. **Dependencies** - Explicitly declare and isolate dependencies
3. **Config** - Store config in the environment, never in code
4. **Backing Services** - Treat backing services as attached resources
5. **Build, Release, Run** - Strictly separate build and run stages
6. **Processes** - Execute as one or more stateless processes
7. **Port Binding** - Export services via port binding
8. **Concurrency** - Scale out via the process model
9. **Disposability** - Maximize robustness with fast startup and graceful shutdown
10. **Dev/Prod Parity** - Keep development, staging, and production as similar as possible
11. **Logs** - Treat logs as event streams
12. **Admin Processes** - Run admin/management tasks as one-off processes

**SOLID Principles (Software Design)**
- **Single Responsibility** - Each module has one reason to change
- **Open/Closed** - Open for extension, closed for modification
- **Liskov Substitution** - Subtypes must be substitutable for their base types
- **Interface Segregation** - No code should depend on methods it doesn't use
- **Dependency Inversion** - Depend on abstractions, not concretions

**ISO 25010 Quality Model**
Software quality is measured across eight characteristics:
- **Functional Suitability** - Does it do what it should?
- **Reliability** - Does it work consistently?
- **Performance Efficiency** - Does it use resources well?
- **Usability** - Is it easy to use?
- **Security** - Is it protected against threats?
- **Compatibility** - Does it work with other systems?
- **Maintainability** - Is it easy to modify and understand?
- **Portability** - Can it work in different environments?

**Abstraction and Design (CS51)**
- Use functional programming principles where appropriate
- Prefer immutability and pure functions
- Make illegal states unrepresentable through types
- Use parametric polymorphism to write reusable code

**Hypermedia Systems (Carson Gross)**
- Prefer server-side rendering with progressive enhancement
- Use hypermedia as the engine of application state (HATEOAS)
- Minimize JavaScript complexity—use HTML over frameworks when possible
- Keep state management simple and explicit

**DRY, YAGNI, KISS**
- **DRY (Don't Repeat Yourself)** - Eliminate duplication through abstraction
- **YAGNI (You Aren't Gonna Need It)** - Implement only what's needed now
- **KISS (Keep It Simple, Stupid)** - Favor simple solutions over clever ones

---

## Requirements Engineering

### EARS Format (Easy to Understand Requirements Syntax)

All requirements MUST be specified using EARS format for precision and testability.

**Requirement Types:**

1. **Ubiquitous Requirements** (always apply)
   The system shall <system response>
   Example: *The system shall validate all input before processing.*

2. **Event-Driven Requirements** (triggered by events)
   WHEN <trigger> the system shall <system response>
   Example: *WHEN a user submits invalid credentials THEN the system shall return an error message without revealing whether the username or password was incorrect.*

3. **State-Driven Requirements** (apply in specific states)
   WHILE <system state> the system shall <system response>
   Example: *WHILE the database connection is unavailable, the system shall queue write operations for retry.*

4. **Unwanted Behavior Requirements** (handle errors)
   IF <condition> THEN the system shall <system response>
   Example: *IF the request rate exceeds 100 requests per second THEN the system shall return HTTP 429 with a retry-after header.*

5. **Optional Feature Requirements** (conditional functionality)
   WHERE <feature is included> the system shall <system response>
   Example: *WHERE audit logging is enabled, the system shall record all data modifications with timestamp and user.*

6. **Complex Requirements** (multiple conditions)
   WHERE <feature>, WHILE <state>, WHEN <trigger>, IF <condition>
   THEN the system shall <response>
   Example: *WHERE two-factor authentication is enabled, WHEN a user logs in from a new device, IF the verification code is not received within 5 minutes, THEN the system shall allow the user to request a new code.*

### Requirements Completeness Checklist

Before implementing any feature, verify:
- [ ] All requirements written in EARS format
- [ ] Happy path defined with expected outcomes
- [ ] Error conditions enumerated with handling strategies
- [ ] Performance requirements specified (latency, throughput, resource limits)
- [ ] Security requirements explicit (authentication, authorization, data protection)
- [ ] Edge cases identified and handled
- [ ] Acceptance criteria defined and measurable
- [ ] Dependencies and assumptions documented

---

## Universal Coding Standards

### Safety & Correctness

**1. Assertions & Validation (Power of 10, Tiger Style)**

(* ✅ GOOD: Assert preconditions and postconditions *)
let divide numerator denominator =
  assert (denominator <> 0); (* Precondition *)
  let result = numerator / denominator in
  assert (result * denominator = numerator); (* Postcondition *)
  result

(* ❌ BAD: No validation *)
let divide numerator denominator =
  numerator / denominator

// ✅ GOOD: Validate at boundaries
func ProcessOrder(order *Order) error {
    if order == nil {
        return fmt.Errorf("order cannot be nil")
    }
    if order.Total < 0 {
        return fmt.Errorf("order total cannot be negative: %v", order.Total)
    }
    // Process...
    return nil
}

// ❌ BAD: No validation
func ProcessOrder(order *Order) error {
    // Process...
    return nil
}

**Assertion Guidelines:**
- Assert preconditions at function entry
- Assert postconditions before function exit
- Assert invariants within loops and complex logic
- Assert both positive space (what should be) and negative space (what should not be)
- Use assertions to document assumptions in the code

**2. Error Handling**

Every error path must be explicit and handled intentionally.

# ✅ GOOD: Explicit error handling with context
def read_config(path: Path) -> Result[Config, ConfigError]:
    try:
        with path.open() as f:
            data = json.load(f)
        return Ok(Config.from_dict(data))
    except FileNotFoundError:
        return Err(ConfigError.NotFound(f"Config file not found: {path}"))
    except json.JSONDecodeError as e:
        return Err(ConfigError.Invalid(f"Invalid JSON in {path}: {e}"))
    except Exception as e:
        return Err(ConfigError.Unknown(f"Unexpected error reading {path}: {e}"))

# ❌ BAD: Silent failure or generic exception
def read_config(path):
    try:
        with open(path) as f:
            return json.load(f)
    except:
        return {}  # Silent failure - loses error information

**Error Handling Principles:**
- **Never ignore errors** - Every error must be handled explicitly
- **Fail fast and loud** - Surface errors immediately, don't propagate invalid state
- **Provide context** - Error messages should explain what went wrong and where
- **Use specific error types** - Not generic exceptions
- **Log errors before returning** - Ensure errors are traceable
- **Test error paths** - Write tests for every error condition

**3. Null Safety**

// ✅ GOOD: Explicit null handling
function getUserEmail(userId: number): string | null {
  const user = users.find(u => u.id === userId);
  return user?.email ?? null;
}

function sendEmail(email: string): void {
  // email is guaranteed non-null here
}

const email = getUserEmail(123);
if (email !== null) {
  sendEmail(email);
}

// ❌ BAD: Non-null assertion without validation
const email = getUserEmail(123);
sendEmail(email!); // Dangerous! Could be null

**Null Safety Guidelines:**
- Prefer Option/Maybe types over null references
- Make nullable types explicit in signatures (TypeScript: `T | null`, Rust: `Option<T>`)
- Validate null checks at system boundaries
- Use null-safe operators (`?.` in TS/JS, `Option.map` in OCaml)
- Never use non-null assertions without prior validation

**4. Bounds & Limits (Tiger Style)**

/* ✅ GOOD: Explicit bounds */
#define MAX_USERS 10000
#define MAX_RETRY_ATTEMPTS 3
#define BUFFER_SIZE 1024

void process_users(void) {
    for (int i = 0; i < MAX_USERS && users[i] != NULL; i++) {
        // Process user
    }
}

/* ❌ BAD: Unbounded loop */
void process_users(void) {
    int i = 0;
    while (users[i] != NULL) {  // Could be infinite
        // Process user
        i++;
    }
}

**Bounds & Limits Guidelines:**
- Set explicit upper bounds on loops (max iterations)
- Define maximum sizes for collections and buffers
- Avoid unbounded recursion—prefer iteration with depth limits
- Limit function length to ~70 lines (Tiger Style)
- Set timeouts for all network operations
- Define maximum request sizes at API boundaries

### Performance

**1. Design for Performance Early (Tiger Style)**

Use napkin math to estimate costs during design:

Example: Calculating API request overhead

Given:
- 1 million users
- 100 requests per user per day
- 50ms average latency per request

Total daily requests: 1M × 100 = 100M requests
Total daily processing time: 100M × 50ms = 5M seconds = ~58 days

Conclusion: Cannot handle synchronously, must use queuing/batch processing

**Performance Optimization Order:**
1. **Network** - Reduce round trips, batch requests, use caching
2. **Disk** - Minimize I/O, use sequential access, batch writes
3. **Memory** - Reduce allocations, reuse buffers, use appropriate data structures
4. **CPU** - Only after network/disk/memory are optimized

**2. Predictable Execution (Tiger Style)**

// ✅ GOOD: Predictable execution paths
func ProcessOrder(order *Order) error {
    // All allocations upfront
    result := make([]Item, 0, len(order.Items))
    
    for _, item := range order.Items {
        // No allocations in loop
        if item.Quantity > 0 {
            result = append(result, item)
        }
    }
    
    return nil
}

// ❌ BAD: Unpredictable allocations
func ProcessOrder(order *Order) error {
    var result []Item  // Grows dynamically
    
    for _, item := range order.Items {
        if item.Quantity > 0 {
            result = append(result, item)  // Reallocates
        }
    }
    
    return nil
}

**Predictable Execution Guidelines:**
- Allocate memory at startup when possible (Tiger Style)
- Avoid dynamic allocation in hot paths
- Minimize branch misprediction (keep branches predictable)
- Keep functions pure when possible (no side effects)
- Use iterative algorithms over recursive where performance matters

**3. Resource Management**

# ✅ GOOD: Explicit resource management
from contextlib import contextmanager

@contextmanager
def database_transaction(db: Database) -> Iterator[Transaction]:
    transaction = db.begin()
    try:
        yield transaction
        transaction.commit()
    except Exception:
        transaction.rollback()
        raise
    finally:
        transaction.close()  # Always cleanup

# Usage
with database_transaction(db) as txn:
    txn.execute("INSERT ...")

# ❌ BAD: Manual cleanup (error-prone)
def database_transaction(db):
    transaction = db.begin()
    # If exception occurs, transaction never cleaned up
    result = transaction.execute("INSERT ...")
    transaction.commit()
    return result

**Resource Management Guidelines:**
- Use RAII (Resource Acquisition Is Initialization) pattern
- Clean up resources in the same scope they're allocated
- Use context managers (Python), defer (Go), destructors (C++)
- Set explicit timeouts for all blocking operations
- Monitor resource usage (memory, file handles, connections)

### Code Organization

**1. Structure (Hypermedia Systems + Tiger Style)**

project/
├── src/
│   ├── core/          # Core domain logic (pure functions)
│   ├── infrastructure/ # External dependencies (database, API clients)
│   ├── handlers/      # Request handlers (thin layer)
│   └── types/         # Shared types and interfaces
├── tests/
│   ├── unit/          # Unit tests (fast, isolated)
│   ├── integration/   # Integration tests (with real dependencies)
│   └── e2e/           # End-to-end tests (full system)
└── docs/
    ├── architecture/  # Architecture Decision Records (ADRs)
    ├── api/           # API documentation
    └── design/        # Design documents

**Organization Principles:**
- **High-level to low-level** - Order code from abstract to concrete
- **Related code together** - Group by feature, not by layer
- **Dependency flow** - Dependencies point inward (core has no external deps)
- **Separate concerns** - Handlers don't contain business logic

**2. Control Flow (Tiger Style)**

// ✅ GOOD: Centralized branching, simple helpers
function processPayment(payment: Payment): Result<Receipt, Error> {
  // All branching logic here
  if (payment.amount <= 0) {
    return Err(new Error("Invalid amount"));
  }
  
  if (payment.method === "credit_card") {
    return processCreditCard(payment);  // Helper has no branching
  } else if (payment.method === "paypal") {
    return processPaypal(payment);  // Helper has no branching
  } else {
    return Err(new Error("Unsupported payment method"));
  }
}

// Helpers are pure, non-branching
function processCreditCard(payment: Payment): Result<Receipt, Error> {
  const charge = calculateCharge(payment.amount);
  const receipt = createReceipt(payment, charge);
  return Ok(receipt);
}

// ❌ BAD: Nested branching, logic scattered
function processPayment(payment: Payment): Result<Receipt, Error> {
  if (payment.amount > 0) {
    if (payment.method === "credit_card") {
      if (payment.card.isValid()) {
        // Deep nesting, hard to follow
      }
    }
  }
}

**Control Flow Principles:**
- Centralize branching logic in parent functions
- Move non-branching logic to helper functions
- Avoid deep nesting (max 3-4 levels)
- Early returns for error conditions
- Use guard clauses to reduce nesting

**3. Function Design (Tiger Style)**

// ✅ GOOD: Single responsibility, simple signature
func ValidateEmail(email string) error {
    if !emailRegex.MatchString(email) {
        return fmt.Errorf("invalid email format: %s", email)
    }
    return nil
}

func SendEmail(to, subject, body string) error {
    // Send email
    return nil
}

// ❌ BAD: Multiple responsibilities, complex signature
func SendEmailWithValidation(email string, subject string, body string, 
                             validateFirst bool, retryCount int, timeout time.Duration) error {
    if validateFirst {
        if !emailRegex.MatchString(email) {
            return fmt.Errorf("invalid email")
        }
    }
    
    // Send email with retry logic...
    return nil
}

**Function Design Principles:**
- Functions do one thing well (SRP)
- Keep signatures simple (≤4 parameters ideal)
- Return simple types when possible: `void > bool > int > complex`
- Minimize dimensionality of return types
- Functions should be ~70 lines max (Tiger Style)

**4. Scope Management (Tiger Style)**

# ✅ GOOD: Minimal scope, single source of truth
def process_order(order_id: int) -> None:
    order = get_order(order_id)  # Declared close to usage
    
    if order.status == "pending":
        # Use order directly, no copies
        confirm_order(order)

# ❌ BAD: Wide scope, duplicate variables
def process_order(order_id: int) -> None:
    order = get_order(order_id)
    order_copy = order  # Unnecessary alias
    current_order = order  # Another alias
    
    # Which variable should we use? Confusion!
    if order_copy.status == "pending":
        confirm_order(current_order)

**Scope Management Principles:**
- Declare variables in the smallest possible scope
- Initialize variables close to usage
- Avoid aliases and duplicate variables
- Maintain single source of truth (Tiger Style)
- Pass large objects (>16 bytes) by reference (Tiger Style)

### Naming Conventions

**Get the Nouns and Verbs Right (Tiger Style)**

Names should create a clear, intuitive model of the domain.

**General Rules:**
- Use descriptive, meaningful names that reveal intent
- Avoid abbreviations unless universally known (`ID`, `URL`, `HTTP`, `API`)
- Use consistent casing per language convention
  - Go: `PascalCase` (exported), `camelCase` (unexported)
  - Python: `snake_case`
  - TypeScript/JavaScript: `camelCase` (variables), `PascalCase` (types/classes)
  - C/C++: `snake_case`
  - OCaml: `snake_case` (values), `PascalCase` (modules/types)

**Units & Qualifiers (Tiger Style):**

# ✅ GOOD: Units in names, qualifiers in order
timeout_ms = 5000
latency_ms_min = 10
latency_ms_max = 100
latency_ms_avg = 45

buffer_size_bytes = 1024
request_count_total = 1000

# ❌ BAD: No units, inconsistent qualifiers
timeout = 5000  # Seconds? Milliseconds?
min_latency = 10
max_latency = 100
avg_latency = 45

**Order qualifiers by descending significance:** `thing_unit_qualifier`

This groups related variables alphabetically:
latency_ms_avg
latency_ms_max
latency_ms_min

**Indexes, Counts, and Sizes (Tiger Style):**

These are distinct types with different semantics:

// ✅ GOOD: Distinct types
int user_index = 0;      // 0-based position in array
int user_count = 10;     // Number of users (1-based)
size_t buffer_size_bytes = user_count * sizeof(User);  // Size in bytes

// Convert explicitly
size_t total_size = user_count * sizeof(User);

// ❌ BAD: Ambiguous names
int users = 10;  // Count? Index? Size?
int size = 100;  // Bytes? Elements?

- **Indexes** - 0-based position (`user_index`, `row_index`)
- **Counts** - Number of elements (`user_count`, `item_count`)
- **Sizes** - Memory size in bytes (`buffer_size_bytes`, `file_size_bytes`)

**Domain-Specific Names:**

Choose nouns and verbs that fit the domain:

(* ✅ GOOD: Domain-aligned names *)
type order = { id: int; items: item list; total: decimal }

let confirm_order order =
  { order with status = Confirmed }

let cancel_order order =
  { order with status = Cancelled }

(* ❌ BAD: Generic names *)
type data = { id: int; stuff: thing list; value: number }

let update_data data =
  { data with flag = true }

### Documentation

**1. Comments (Tiger Style, CS51)**

// ✅ GOOD: Explain "why", not "what"
// Using exponential backoff to avoid overwhelming the upstream service
// after it recovers from an outage. Linear backoff was causing cascading failures.
func retryWithBackoff(operation func() error) error {
    delay := initialDelay
    for i := 0; i < maxRetries; i++ {
        if err := operation(); err == nil {
            return nil
        }
        time.Sleep(delay)
        delay *= 2
    }
    return fmt.Errorf("max retries exceeded")
}

// ❌ BAD: States the obvious
// Multiply delay by 2
delay *= 2

**Documentation Principles:**
- Document the "why", not the "what"
- Explain non-obvious decisions and constraints
- Reference relevant design documents or RFCs
- Use complete sentences with proper grammar
- Keep comments synchronized with code (or delete them)

**2. Code as Documentation (Tiger Style)**

// ✅ GOOD: Self-documenting code
const MAX_LOGIN_ATTEMPTS = 3;
const LOCKOUT_DURATION_MS = 15 * 60 * 1000; // 15 minutes

function lockoutUser(userId: number): void {
  setUserLockout(userId, Date.now() + LOCKOUT_DURATION_MS);
}

// ❌ BAD: Magic numbers
function lockoutUser(userId: number): void {
  setUserLockout(userId, Date.now() + 900000); // What's 900000?
}

**Self-Documentation Principles:**
- Make code self-documenting through good naming
- Prefer explicit over implicit
- Avoid magic numbers—use named constants
- Let type systems express intent
- Use type aliases for domain concepts

### Style & Formatting

**1. Consistency (Tiger Style)**

Use language-standard formatters:
- **Go** - `gofmt`, `goimports`
- **Python** - `black` or `ruff format`
- **TypeScript/JavaScript** - `prettier`
- **OCaml** - `ocamlformat`
- **C/C++** - `clang-format`
- **SQL** - `sqlfluff` or `pg_format`

**Formatting Standards:**
- Line length ≤100 characters (Tiger Style)
- Consistent indentation (4 spaces preferred, or 2 for deeply nested languages)
- Clear separation between code blocks
- Blank lines between logical sections

**2. Dependencies (12-Factor App, Tiger Style)**

# ✅ GOOD: Explicit, pinned dependencies
[dependencies]
requests = "==2.31.0"  # Exact version
sqlalchemy = "~=2.0.23"  # Compatible version

# ❌ BAD: Unpinned dependencies
[dependencies]
requests = "*"  # Any version - unpredictable
sqlalchemy = ">=2.0"  # Could break on major updates

**Dependency Principles:**
- Minimize external dependencies (only include what's necessary)
- Vet all dependencies for security, maintenance, and license compatibility
- Pin dependency versions explicitly
- Document why each dependency is necessary
- Regularly audit and update dependencies
- Use dependency scanning tools (Dependabot, Snyk, etc.)

---

## Language-Specific Guidelines

### OCaml

**Style & Standards:**
- Follow [OCaml Programming Guidelines](https://ocaml.org/docs/guidelines)
- Use `ocamlformat` for consistent formatting
- Enable all warnings: `-w +A-4-42-44-48-50-60-66`
- Treat warnings as errors: `-warn-error +A`
- Use `.mli` interface files to define module boundaries

**OCaml-Specific Rules:**

**1. Type Safety & Pattern Matching:**

(* ✅ GOOD: Exhaustive pattern matching *)
type payment_status = 
  | Pending
  | Completed of { timestamp: float }
  | Failed of { reason: string }

let process_payment status =
  match status with
  | Pending -> "Awaiting payment"
  | Completed { timestamp } -> Printf.sprintf "Paid at %f" timestamp
  | Failed { reason } -> Printf.sprintf "Failed: %s" reason

(* ❌ BAD: Non-exhaustive pattern matching *)
let process_payment status =
  match status with
  | Pending -> "Awaiting payment"
  | Completed _ -> "Paid"
  (* Forgot Failed case - compiler will warn *)

**2. Immutability & Functional Style:**

(* ✅ GOOD: Pure functions, immutable data *)
let calculate_total items =
  List.fold_left (fun acc item -> acc +. item.price) 0.0 items

let add_item item items =
  item :: items  (* Returns new list *)

(* ❌ BAD: Mutable state *)
let total = ref 0.0

let calculate_total items =
  List.iter (fun item -> total := !total +. item.price) items;
  !total

**3. Error Handling:**

(* ✅ GOOD: Use Result type *)
type ('a, 'e) result = Ok of 'a | Error of 'e

let divide x y =
  if y = 0 then
    Error "Division by zero"
  else
    Ok (x / y)

let process_division x y =
  match divide x y with
  | Ok result -> Printf.printf "Result: %d\n" result
  | Error msg -> Printf.eprintf "Error: %s\n" msg

(* ❌ BAD: Exceptions for control flow *)
let divide x y =
  if y = 0 then
    raise (Invalid_argument "Division by zero")
  else
    x / y

**4. Module Organization:**

(* file: order.mli - Interface *)
type t
type status = Pending | Confirmed | Cancelled

val create : int -> item list -> t
val confirm : t -> t
val cancel : t -> t
val status : t -> status

(* file: order.ml - Implementation *)
type status = Pending | Confirmed | Cancelled

type t = {
  id: int;
  items: item list;
  status: status;
}

let create id items =
  { id; items; status = Pending }

let confirm order =
  { order with status = Confirmed }

let cancel order =
  { order with status = Cancelled }

let status order = order.status

**5. Testing:**

(* Use OUnit or Alcotest *)
open OUnit2

let test_divide_success _ =
  match divide 10 2 with
  | Ok 5 -> ()
  | _ -> assert_failure "Expected Ok 5"

let test_divide_by_zero _ =
  match divide 10 0 with
  | Error "Division by zero" -> ()
  | _ -> assert_failure "Expected error"

let suite =
  "DivisionTests" >::: [
    "divide_success" >:: test_divide_success;
    "divide_by_zero" >:: test_divide_by_zero;
  ]

let () = run_test_tt_main suite

### SQL

**Style & Standards:**
- Use `sqlfluff` or `pg_format` for formatting
- Always use parameterized queries (prevent SQL injection)
- Use explicit JOIN syntax (never implicit joins)
- Index all foreign keys

**SQL-Specific Rules:**

**1. Query Safety:**

-- ✅ GOOD: Parameterized query
SELECT id, name, email
FROM users
WHERE id = $1;  -- Parameter, not concatenated

-- ❌ BAD: String concatenation (SQL injection risk)
SELECT id, name, email
FROM users
WHERE id = 123; -- Hard-coded or concatenated

**2. Explicit Joins:**

-- ✅ GOOD: Explicit JOIN
SELECT 
  o.id,
  o.total,
  u.name AS customer_name
FROM orders o
INNER JOIN users u ON o.user_id = u.id
WHERE o.status = 'pending';

-- ❌ BAD: Implicit join
SELECT 
  o.id,
  o.total,
  u.name
FROM orders o, users u
WHERE o.user_id = u.id
  AND o.status = 'pending';

**3. Indexing Strategy:**

-- ✅ GOOD: Indexes on foreign keys and query columns
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Composite index for common query patterns
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

**4. Transaction Management:**

-- ✅ GOOD: Explicit transactions
BEGIN;

UPDATE accounts 
SET balance = balance - 100
WHERE id = 1;

UPDATE accounts
SET balance = balance + 100
WHERE id = 2;

COMMIT;

-- ❌ BAD: No transaction for related operations
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- If second UPDATE fails, first is committed - data inconsistency!

**5. Naming Conventions:**

-- ✅ GOOD: Consistent, descriptive names
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'cancelled')),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ❌ BAD: Inconsistent, unclear names
CREATE TABLE ord (
  id INT,
  uid INT,
  stat TEXT,
  dt TIMESTAMP
);

### Go

*(Keep existing Go section, it's comprehensive)*

**Setup & Tools:**
# Install Go 1.21+
go mod init <module>
go mod tidy

**Project Structure:**
project/
├── cmd/           # Main applications
├── internal/      # Private application code
├── pkg/           # Public libraries
├── api/           # API definitions (protobuf, OpenAPI)
└── test/          # Additional test files

**Style & Standards:**
- Run `gofmt` and `goimports` on all code
- Use `golangci-lint` with strict configuration
- Follow [Effective Go](https://golang.org/doc/effective_go.html)

**Go-Specific Rules:**

**1. Error Handling:**
// ✅ DO: Always check errors
data, err := readFile(path)
if err != nil {
    return fmt.Errorf("read file %s: %w", path, err)
}

// ❌ DON'T: Ignore errors
data, _ := readFile(path)

**2. Interfaces:**
- Accept interfaces, return structs
- Keep interfaces small (1-3 methods ideal)
- Define interfaces where they're used

**3. Concurrency:**
// ✅ DO: Proper cleanup
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

go func() {
    select {
    case <-ctx.Done():
        return
    case result <- doWork():
    }
}()

**4. Testing:**
// Use table-driven tests
func TestCalculate(t *testing.T) {
    tests := []struct {
        name     string
        input    int
        expected int
        wantErr  bool
    }{
        {"positive", 5, 25, false},
        {"zero", 0, 0, false},
        {"negative", -5, 0, true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result, err := Calculate(tt.input)
            if tt.wantErr {
                assert.Error(t, err)
                return
            }
            assert.NoError(t, err)
            assert.Equal(t, tt.expected, result)
        })
    }
}

### Python

*(Keep existing Python section)*

**Setup & Tools:**
# Use uv for dependency management
curl -LsSf https://astral.sh/uv/install.sh | sh
uv init
uv venv

**Style & Standards:**
- Follow [PEP 8](https://pep8.org/)
- Use type hints everywhere (PEP 484)
- Use `ruff` for linting and formatting
- Use `mypy` for static type checking

**Python-Specific Rules:**

**1. Type Hints:**
# ✅ DO: Always use type hints
def calculate_total(items: list[Item], discount: float = 0.0) -> Decimal:
    """Calculate total with optional discount.
    
    Args:
        items: List of items to calculate
        discount: Discount percentage (0.0 to 1.0)
        
    Returns:
        Total amount after discount
        
    Raises:
        ValueError: If discount is out of range
    """
    if not 0.0 <= discount <= 1.0:
        raise ValueError(f"Invalid discount: {discount}")
    
    subtotal = sum(item.price for item in items)
    return subtotal * (1 - Decimal(str(discount)))

**2. Error Handling:**
# ✅ DO: Specific exceptions with context
from pathlib import Path

def read_config(path: Path) -> dict[str, Any]:
    try:
        return json.loads(path.read_text())
    except FileNotFoundError:
        raise ConfigError(f"Config file not found: {path}") from None
    except json.JSONDecodeError as e:
        raise ConfigError(f"Invalid JSON in {path}: {e}") from e

**3. Context Managers:**
# ✅ DO: Use context managers for resources
from contextlib import contextmanager

@contextmanager
def database_transaction(db: Database) -> Iterator[Transaction]:
    transaction = db.begin()
    try:
        yield transaction
        transaction.commit()
    except Exception:
        transaction.rollback()
        raise
    finally:
        transaction.close()

### TypeScript

*(Keep existing TypeScript section)*

**Setup & Tools:**
# Use pnpm for package management
npm install -g pnpm
pnpm init
pnpm add -D typescript @types/node
pnpm exec tsc --init

**Style & Standards:**
- Use strict TypeScript configuration
- Use ESLint + Prettier
- Follow [TypeScript Do's and Don'ts](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html)

**TypeScript-Specific Rules:**

**1. Type Safety:**
// ✅ DO: Use strict types
interface User {
  readonly id: number;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
}

function updateUser(
  id: number,
  updates: Partial<Omit<User, 'id'>>
): Result<User, Error> {
  // Implementation
}

**2. Null Safety:**
// ✅ DO: Handle null/undefined explicitly
function getUserEmail(userId: number): string | null {
  const user = users.find(u => u.id === userId);
  return user?.email ?? null;
}

**3. Error Handling:**
// ✅ DO: Use Result types
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

function parseConfig(json: string): Result<Config> {
  try {
    const data = JSON.parse(json);
    return { ok: true, value: data };
  } catch (error) {
    return {
      ok: false,
      error: new Error(`Invalid config: ${error}`),
    };
  }
}

### JavaScript

**Style & Standards:**
- Use ESLint + Prettier
- Prefer modern ES2020+ syntax
- Use `const` by default, `let` when reassignment needed, never `var`

**JavaScript-Specific Rules:**

**1. Modern Syntax:**
// ✅ GOOD: Modern ES2020+ syntax
const fetchUsers = async (ids) => {
  const users = await Promise.all(
    ids.map(id => fetch(`/users/${id}`).then(r => r.json()))
  );
  return users.filter(u => u !== null);
};

// ❌ BAD: Old-style syntax
function fetchUsers(ids, callback) {
  var users = [];
  ids.forEach(function(id) {
    fetch('/users/' + id, function(response) {
      users.push(response);
    });
  });
  callback(users);
}

**2. Error Handling:**
// ✅ GOOD: Explicit error handling
async function fetchData(url) {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    return await response.json();
  } catch (error) {
    console.error(`Failed to fetch ${url}:`, error);
    throw error;
  }
}

### Bash

**Style & Standards:**
- Use `shellcheck` for linting
- Enable strict mode: `set -euo pipefail`
- Use `#!/usr/bin/env bash` shebang

**Bash-Specific Rules:**

**1. Strict Mode:**
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined variable, pipe failure
IFS=$'\n\t'        # Set safe Internal Field Separator

# Your script here

**2. Error Handling:**
# ✅ GOOD: Check command success
if ! command -v docker &> /dev/null; then
    echo "Error: docker is not installed" >&2
    exit 1
fi

# ❌ BAD: No error checking
docker build .
docker run app

**3. Quoting:**
# ✅ GOOD: Always quote variables
file_name="my file.txt"
cat "$file_name"

# ❌ BAD: Unquoted variables (breaks with spaces)
cat $file_name  # Breaks: tries to cat "my" and "file.txt"

**4. Functions:**
# ✅ GOOD: Functions with error handling
function backup_database() {
    local db_name="$1"
    local backup_dir="$2"
    
    if [[ -z "$db_name" ]]; then
        echo "Error: database name required" >&2
        return 1
    fi
    
    pg_dump "$db_name" > "${backup_dir}/${db_name}.sql"
}

# Usage
if ! backup_database "production" "/backups"; then
    echo "Backup failed" >&2
    exit 1
fi

### C

**Style & Standards:**
- Use `clang-format` for formatting
- Enable all compiler warnings: `-Wall -Wextra -Werror -pedantic`
- Use C11 or later
- Use static analysis tools: `clang-tidy`, `cppcheck`

**C-Specific Rules:**

**1. Memory Safety:**
/* ✅ GOOD: Explicit memory management */
#include <stdlib.h>
#include <string.h>

char* duplicate_string(const char* src) {
    if (src == NULL) {
        return NULL;
    }
    
    size_t len = strlen(src) + 1;
    char* dst = malloc(len);
    if (dst == NULL) {
        return NULL;  /* Allocation failed */
    }
    
    memcpy(dst, src, len);
    return dst;
}

/* Caller must free */
char* str = duplicate_string("hello");
if (str != NULL) {
    /* Use str */
    free(str);
}

/* ❌ BAD: No null checks, no error handling */
char* duplicate_string(const char* src) {
    char* dst = malloc(strlen(src) + 1);
    strcpy(dst, src);
    return dst;
}

**2. Bounds Checking:**
/* ✅ GOOD: Explicit bounds */
#define MAX_BUFFER_SIZE 1024

int read_line(char* buffer, size_t buffer_size) {
    if (buffer == NULL || buffer_size == 0) {
        return -1;
    }
    
    size_t i = 0;
    int ch;
    while (i < buffer_size - 1 && (ch = getchar()) != '\n' && ch != EOF) {
        buffer[i++] = ch;
    }
    buffer[i] = '\0';
    return i;
}

/* ❌ BAD: No bounds checking */
int read_line(char* buffer) {
    int i = 0;
    int ch;
    while ((ch = getchar()) != '\n') {  /* Buffer overflow! */
        buffer[i++] = ch;
    }
    buffer[i] = '\0';
    return i;
}

**3. Header Guards:**
/* ✅ GOOD: Include guards */
#ifndef MYMODULE_H
#define MYMODULE_H

/* Declarations */

#endif /* MYMODULE_H */

/* Or use #pragma once (widely supported) */
#pragma once

/* Declarations */

### C++

**Style & Standards:**
- Use `clang-format` for formatting
- Enable all compiler warnings: `-Wall -Wextra -Werror -pedantic`
- Use C++17 or later
- Follow [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)

**C++-Specific Rules:**

**1. RAII (Resource Acquisition Is Initialization):**
// ✅ GOOD: RAII with smart pointers
#include <memory>
#include <fstream>

class FileProcessor {
private:
    std::unique_ptr<std::ifstream> file_;

public:
    FileProcessor(const std::string& path) 
        : file_(std::make_unique<std::ifstream>(path)) {
        if (!file_->is_open()) {
            throw std::runtime_error("Failed to open file: " + path);
        }
    }
    
    // Destructor automatically closes file
    ~FileProcessor() = default;
    
    // Prevent copying
    FileProcessor(const FileProcessor&) = delete;
    FileProcessor& operator=(const FileProcessor&) = delete;
    
    // Allow moving
    FileProcessor(FileProcessor&&) = default;
    FileProcessor& operator=(FileProcessor&&) = default;
};

// ❌ BAD: Manual memory management
class FileProcessor {
private:
    std::ifstream* file_;

public:
    FileProcessor(const std::string& path) {
        file_ = new std::ifstream(path);
    }
    
    ~FileProcessor() {
        delete file_;  // Must remember to delete!
    }
};

**2. Modern C++ Features:**
// ✅ GOOD: Use modern C++17/20 features
#include <optional>
#include <string_view>
#include <vector>

std::optional<int> find_index(
    const std::vector<int>& vec, 
    int value
) {
    auto it = std::find(vec.begin(), vec.end(), value);
    if (it != vec.end()) {
        return std::distance(vec.begin(), it);
    }
    return std::nullopt;
}

// Use string_view for non-owning string references
void print_header(std::string_view header) {
    std::cout << "=== " << header << " ===" << std::endl;
}

**3. Const Correctness:**
// ✅ GOOD: Const correctness
class Point {
private:
    int x_;
    int y_;

public:
    Point(int x, int y) : x_(x), y_(y) {}
    
    // Const member functions for read-only operations
    int x() const { return x_; }
    int y() const { return y_; }
    
    // Non-const for mutations
    void set_x(int x) { x_ = x; }
    void set_y(int y) { y_ = y; }
};

// Pass large objects by const reference
double calculate_distance(const Point& p1, const Point& p2) {
    int dx = p2.x() - p1.x();
    int dy = p2.y() - p1.y();
    return std::sqrt(dx*dx + dy*dy);
}

---

## Code Review Checklist

Before submitting code, the agent MUST verify:

### Planning & Requirements
- [ ] Requirements documented in EARS format
- [ ] Win conditions defined and measurable
- [ ] Implementation plan reviewed and approved
- [ ] All ambiguities resolved
- [ ] Edge cases identified and handled

### Safety & Correctness
- [ ] All errors handled explicitly (no ignored errors)
- [ ] Input validation at all boundaries
- [ ] Assertions for preconditions, postconditions, and invariants
- [ ] No possible null/undefined dereferences
- [ ] No buffer overflows or out-of-bounds access
- [ ] Thread-safety considered (if applicable)
- [ ] Resource cleanup guaranteed (RAII, context managers, defer)

### Testing
- [ ] Unit tests for new functionality
- [ ] Edge cases covered in tests
- [ ] Error paths tested
- [ ] Test names describe what they test
- [ ] Tests are deterministic (no flaky tests)
- [ ] Test coverage ≥80% on business logic

### Performance
- [ ] No unnecessary allocations in hot paths
- [ ] Appropriate data structures used
- [ ] O(n²) algorithms avoided unless necessary
- [ ] Database queries optimized (indexes, batching)
- [ ] Resource usage bounded (limits on loops, collections, memory)

### Code Quality
- [ ] Functions are focused and concise (≤70 lines)
- [ ] Names clearly express intent (nouns and verbs right)
- [ ] No magic numbers (use named constants)
- [ ] Comments explain "why", not "what"
- [ ] No dead code or commented-out code
- [ ] Follows project style guide and formatters

### Architecture (12-Factor, Tiger Style, SOLID)
- [ ] SOLID principles respected
- [ ] No circular dependencies
- [ ] Appropriate abstraction levels
- [ ] Public API is minimal and clear
- [ ] Config stored in environment, not code
- [ ] Dependencies explicitly declared
- [ ] Stateless processes (where applicable)

### Security
- [ ] No hard-coded credentials or secrets
- [ ] Input sanitized to prevent injection attacks
- [ ] Authentication and authorization enforced
- [ ] Sensitive data encrypted at rest and in transit
- [ ] Dependencies scanned for vulnerabilities

### Documentation
- [ ] Design decisions documented (ADRs if significant)
- [ ] API documentation updated
- [ ] README updated (if public API changed)
- [ ] Inline comments for complex logic

---

## Anti-Patterns to Avoid

### Universal Anti-Patterns

1. **God Objects** - Classes/modules that know too much or do too much
   - Violates SRP (Single Responsibility Principle)
   - Makes testing and maintenance difficult

2. **Primitive Obsession** - Using primitives instead of domain types
   // ❌ BAD: Primitive obsession
   function transferMoney(from: string, to: string, amount: number): void

   // ✅ GOOD: Domain types
   function transferMoney(from: AccountId, to: AccountId, amount: Money): void

3. **Flag Arguments** - Boolean parameters that change function behavior
   # ❌ BAD: Flag argument
   def save_user(user, send_email=True):
       # ...
   
   # ✅ GOOD: Separate functions
   def save_user(user):
       # ...
   
   def save_user_and_send_email(user):
       save_user(user)
       send_welcome_email(user)

4. **Long Parameter Lists** - More than 4 parameters
   // ❌ BAD: Too many parameters
   func CreateOrder(userId, productId, quantity, price, discount, taxRate int, notes string) error

   // ✅ GOOD: Use struct
   type OrderParams struct {
       UserID    int
       ProductID int
       Quantity  int
       Price     int
       Discount  int
       TaxRate   int
       Notes     string
   }
   func CreateOrder(params OrderParams) error

5. **Mutable Global State** - Shared mutable state without protection
6. **Silent Failures** - Catching exceptions without handling them
7. **Copy-Paste Programming** - Duplicating code instead of abstracting

### Language-Specific Anti-Patterns

**Go:**
- Goroutine leaks (no cleanup or context cancellation)
- Ignoring errors (`_, err := ...` then not checking `err`)
- Using `panic` for normal errors (should be `error` return)
- Naked returns in long functions
- Not using `go vet` and linters

**Python:**
- Mutable default arguments (`def func(items=[]):`)
- Bare `except:` clauses (catch all exceptions)
- Not using context managers for resources
- String concatenation in loops (use `''.join()` instead)
- Circular imports

**TypeScript:**
- Using `any` instead of proper types
- Not enabling strict mode
- Non-null assertions (`!`) without validation
- Mutation of readonly types (type cast circumvention)
- Promises without `.catch()` or try-catch in async

**OCaml:**
- Using exceptions for control flow (prefer `Result` type)
- Not using `.mli` interface files
- Ignoring compiler warnings
- Mutable state without clear justification

**SQL:**
- String concatenation for queries (SQL injection risk)
- SELECT * (specify columns explicitly)
- Missing indexes on foreign keys
- No transaction boundaries for related operations

**C/C++:**
- Manual memory management (use RAII in C++)
- No bounds checking on arrays
- Ignoring return values from functions
- Missing null pointer checks

---

## Continuous Improvement

### Learning from Mistakes

When an error or defect is found:
1. **Root Cause Analysis** - What was the underlying cause?
2. **Pattern Recognition** - Is this a recurring pattern?
3. **Systemic Fix** - How can we prevent this class of errors?
4. **Documentation** - Update guidelines to prevent recurrence
5. **Automation** - Add linting rules or tests to catch this automatically

### Metrics for Code Quality

Track and monitor:
- **Test Coverage** - Aim for ≥80% on business logic
- **Cyclomatic Complexity** - Keep functions simple (complexity ≤15)
- **Code Churn** - High churn indicates instability
- **Bug Density** - Bugs per 1000 lines of code
- **Mean Time to Recovery** - How quickly can we fix issues?
- **Deployment Frequency** - How often do we ship?

### Regular Audits

Conduct quarterly audits of:
- Dependency versions and security vulnerabilities
- Dead code and unused dependencies
- Test coverage and quality
- Documentation completeness
- Performance bottlenecks
- Technical debt backlog

---

## Summary: Core Principles

1. **Clarify Before Coding** - Understand problem, define win conditions, plan implementation, get approval
2. **Resolve All Ambiguities** - Never proceed with unclear requirements
3. **Safety First** - Write code that works in all situations, fail fast and loud
4. **Performance from Start** - Use napkin math during design
5. **Developer Experience** - Get names right, minimize cognitive load
6. **Explicit Over Implicit** - Make intent clear through types, names, and structure
7. **Test Everything** - Unit tests, integration tests, error paths
8. **Document Decisions** - Explain "why", not "what"
9. **Follow Standards** - Use formatters, linters, type checkers
10. **Continuous Learning** - Learn from mistakes, improve systematically

---

**Remember:** The goal is not to write code quickly—the goal is to write code **correctly**. A well-planned, correctly implemented feature is infinitely more valuable than a rushed, buggy feature.

**This document is a living contract.** As new patterns emerge and lessons are learned, this guide evolves. When in doubt, prioritize correctness and clarity over cleverness.
