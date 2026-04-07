# C4 Architecture Diagram Templates

Standard C4 model diagrams using Mermaid syntax.

---

## Level 1: System Context

Shows the system and its relationships with users and external systems.

```mermaid
C4Context
    title System Context — {Project Name}

    Person(user1, "{User Type}", "{Description}")
    Person(user2, "{User Type}", "{Description}")

    System(system, "{Project Name}", "{Description}")

    System_Ext(ext1, "{External System}", "{Purpose}")
    System_Ext(ext2, "{External System}", "{Purpose}")

    Rel(user1, system, "{Uses}")
    Rel(system, ext1, "{Integrates with}", "{protocol}")
    Rel(ext2, system, "{Sends data to}", "{protocol}")
```

---

## Level 2: Container Diagram

Shows the high-level technology choices and how containers communicate.

```mermaid
C4Container
    title Container Diagram — {Project Name}

    Person(user, "{User}", "{Description}")

    System_Boundary(system, "{Project Name}") {
        Container(web, "Web Application", "{Technology}", "{Description}")
        Container(api, "API Server", "{Technology}", "{Description}")
        Container(db, "Database", "{Technology}", "{Description}")
        Container(queue, "Message Queue", "{Technology}", "{Description}")
    }

    System_Ext(ext, "{External System}", "{Purpose}")

    Rel(user, web, "Uses", "HTTPS")
    Rel(web, api, "Calls", "REST/JSON")
    Rel(api, db, "Reads/Writes", "SQL/ORM")
    Rel(api, queue, "Publishes", "AMQP")
    Rel(ext, api, "Webhooks", "HTTPS")
```

---

## Level 3: Component Diagram

Shows the internals of a container — modules, services, controllers.

```mermaid
C4Component
    title Component Diagram — {Container Name}

    Container_Boundary(api, "API Server") {
        Component(controller, "Controller", "{Technology}", "Handles HTTP requests")
        Component(service, "Service Layer", "{Technology}", "Business logic")
        Component(repo, "Repository", "{Technology}", "Data access")
        Component(auth, "Auth Middleware", "{Technology}", "Authentication")
    }

    Container(db, "Database", "{Technology}")
    System_Ext(ext, "{External System}")

    Rel(controller, service, "Calls")
    Rel(service, repo, "Uses")
    Rel(repo, db, "Queries")
    Rel(controller, auth, "Validates token")
    Rel(service, ext, "Calls API")
```

---

## Sequence Diagram (for key workflows)

```mermaid
sequenceDiagram
    participant U as User
    participant W as Web App
    participant A as API Server
    participant D as Database
    participant E as External Service

    U->>W: {Action}
    W->>A: {API Call}
    A->>D: {Query}
    D-->>A: {Result}
    A->>E: {External Call}
    E-->>A: {Response}
    A-->>W: {API Response}
    W-->>U: {Display Result}
```

---

## Rules

- Level 1 (Context) is REQUIRED for every project
- Level 2 (Container) is REQUIRED — shows technology choices
- Level 3 (Component) is REQUIRED for containers with >3 internal modules
- Sequence diagrams are REQUIRED for complex workflows (>3 participants)
- Every diagram must have a title
- Labels on relationships describe WHAT is communicated, not HOW
- Include technology names in container descriptions
