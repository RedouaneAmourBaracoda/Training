# Todo iOS App

A small but deliberately structured iOS application built with **SwiftUI** to practice production-oriented iOS fundamentals: state management, MVVM-style separation of responsibilities, Swift Concurrency, dependency injection, HTTP networking, DTO/domain mapping, and a real Supabase backend.

## Features

- Load tasks from a remote backend
- Create new tasks
- Toggle completion state
- Delete tasks
- Pull to refresh
- Loading and error states
- Input validation before task creation
- Automatic ordering of incomplete/completed tasks
- Real CRUD operations persisted through Supabase
- Authentication is work in progress

## Tech Stack

- **Swift**
- **SwiftUI**
- **Swift Concurrency** (`async/await`, `Task`, cancellation)
- **Combine observation** (`ObservableObject`, `@Published`)
- **URLSession**
- **Codable**
- **Supabase REST API / PostgREST**
- **Row Level Security groundwork**
- **Xcode**

## Architecture

The project separates UI, presentation, domain logic, request construction, and transport responsibilities.

```text
SwiftUI View
    ↓
ViewModel
    ↓
Use Case
    ↓
Endpoint Builder
    ↓
API Client
    ↓
URLSession
    ↓
Supabase
```

### View

`TodoListView` is responsible for presentation and forwarding user actions. It owns UI-specific state such as sheet presentation, alert presentation, and the currently running synchronization task.

### ViewModel

`TodoListViewModel` is isolated to `@MainActor` and exposes observable presentation state. It coordinates user actions with the domain/network layer without constructing HTTP requests itself.

### Domain Model

`TodoTask` is the application model used by the UI and business logic.

`TodoListOrganizer` centralizes list invariants and mutations such as:

- add
- update
- delete
- sorting
- remaining task count

This keeps list behavior outside the SwiftUI view.

### Use Case

`TodoUseCase` represents the application operations available for tasks:

```swift
load()
create(todoTaskName:)
update(todoTask:)
delete(todoTask:)
```

It performs input normalization, maps network DTOs into domain models, and keeps backend representation details away from the presentation layer.

### Endpoint Builders

`TodoEndpointBuilder` translates task operations into `URLRequest` values.

It owns endpoint-specific knowledge such as:

- HTTP methods
- headers
- request bodies
- PostgREST query filters

Implemented task operations:

| Operation | HTTP |
|---|---|
| Load tasks | `GET` |
| Create task | `POST` |
| Update task | `PATCH` |
| Delete task | `DELETE` |

An `AuthEndpointBuilder` is also present as groundwork for signup/login integration.

### API Client

The network transport is intentionally generic:

```swift
protocol APIClientType {
    func send<Response: Decodable>(request: URLRequest) async throws -> Response
}
```

`APIClient` does not know about Todos or authentication. It:

1. sends a complete `URLRequest`
2. receives `Data` and `URLResponse`
3. validates the HTTP status code
4. decodes the expected response type
5. propagates API errors

`URLSession` is injected, keeping the transport layer replaceable and testable.

## DTO / Domain Separation

The backend contract is kept separate from the application model.

```text
Supabase JSON
    ↓
TodoResponseDTO
    ↓
TodoTask
```

For writes, `TodoRequestDTO` models the payload sent to the API. This prevents the rest of the application from depending directly on the backend JSON representation.

## Backend

The application currently uses a real **Supabase** project : https://supabase.com/dashboard/project/yjictxhqmuklxifmctgi

> The client uses a Supabase **publishable** key.

## Authentication Work in Progress

The repository contains the first infrastructure pieces for authentication:

- signup/login request DTOs
- authentication endpoint builder
- authentication use case
- `AuthSession` model
- actor-based in-memory `SessionStore`

The remaining authentication work is intentionally not presented as complete. Planned integration includes secure Keychain persistence, Bearer token injection, refresh-token rotation, session restoration, logout, and per-user RLS throughout the app.

## Project Structure

```text
Training/
├── StartApp/
│   └── TrainingApp.swift
├── Resources/
│   └── Strings.swift
└── Views/
    └── TodoTaskList/
        ├── TodoListView.swift
        ├── TodoListViewModel.swift
        ├── TodoModel.swift
        └── Network/
            ├── APIClient.swift
            ├── DTO.swift
            ├── EndpointBuilder.swift
            └── UseCase.swift
```

## Current Focus / Next Steps

The next iterations are focused on core iOS topics :

- local persistence and source-of-truth strategy
- unit and asynchronous testing
- deeper SwiftUI identity (`Identifiable`, `Equatable`, `Hashable`)
- completion of authentication and secure session persistence
- advanced Swift Concurrency topics

## Running the Project

1. Open `Training.xcodeproj` in Xcode.
2. Select an iOS Simulator or physical device.
3. Build and run the `Training` scheme.
4. Ensure the Supabase API configuration points to a valid project/table with the required RLS policies.

---
