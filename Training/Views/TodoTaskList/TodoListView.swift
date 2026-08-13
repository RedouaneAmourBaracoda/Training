//
//  TaskListView.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel: TodoListViewModel
    @State private var text: String = ""
    @State private var showSheet: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String?
    @State private var loadingTask: Task<Void, Never>?

    init() {
        self._viewModel = StateObject(wrappedValue: TodoListViewModel(todoUseCase: TodoUseCase()))
    }

    var body: some View {
        NavigationStack {
            VStack {
                list()
                addTodoTaskButton()
            }
            .navigationTitle(Resources.Titles.navigationStackTitle)
        }
    }

    private func list() -> some View {
        List {
            ForEach(viewModel.todoListOrganizer.list) { todoTask in
                TodoTaskView(todoTask: todoTask)
                    .onTapGesture { viewModel.toggleCompletion(todoTask) }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.delete(todoTask)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
            }
            Text(Resources.Titles.remainingTasks + "\(viewModel.uncompletedTasksCount)")
        }
        .loadingActivity(isAnimating: loadingTask != nil)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage ?? "Error"), dismissButton: .cancel(Text("Ok"), action: {
                alertMessage = nil
            }))
        }
        .disabled(loadingTask != nil)
        .onAppear { syncTodos { try await viewModel.loadTodos() }}
        .refreshable { syncTodos { try await viewModel.loadTodos() }}
    }

    private func addTodoTaskButton() -> some View {
        Button {
            showSheet = true
        } label: {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
        }
        .disabled(loadingTask != nil)
        .sheet(isPresented: $showSheet) {
            sheetContent()
        }
    }
    
    private func sheetContent() -> some View {
        VStack {
            HStack {
                cancelButton()
                Spacer()
                saveButton()
            }
            Spacer()
            TextField(Resources.Titles.textFieldPlaceholder, text: $text)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }
        .loadingActivity(isAnimating: loadingTask != nil)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage ?? "Error"), dismissButton: .cancel(Text("Ok"), action: {
                alertMessage = nil
            }))
        }
        .padding()
    }
    
    private func cancelButton() -> some View {
        Button(role: .cancel) {
            loadingTask?.cancel()
            loadingTask = nil
            dismissSheet()
        }
    }
    
    private func saveButton() -> some View {
        Button(role: .confirm) {
            syncTodos {
                try await viewModel.createTodo(name: text)
                dismissSheet()
            }
        }
        .disabled(loadingTask != nil)
    }

    private func syncTodos(asyncAction: (() async throws -> Void)? = nil) {
        guard loadingTask == nil else { return }
        loadingTask = Task {
            defer {
                loadingTask?.cancel()
                loadingTask = nil
            }
            do {
                try await asyncAction?()
            } catch {
                guard !Task.isCancelled else { return }
                presentAlert(error: error)
            }
        }
    }

    private func presentAlert(error: Error) {
        if let _ = error as? CancellationError {
            return
        } else if let error = error as? TodoError {
            alertMessage = error.userMessage
        } else {
            alertMessage = TodoError.unknown.userMessage
        }
        showAlert = true
    }

    private func dismissSheet() {
        showSheet = false
        text = ""
    }
}

struct TodoTaskView: View {
    private let todoTask: TodoTask
    
    init(todoTask: TodoTask) {
        self.todoTask = todoTask
    }

    var body: some View {
        HStack {
            Image(systemName: todoTask.isCompleted ? "checkmark.circle" : "circle")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(todoTask.name)
                .strikethrough(todoTask.isCompleted)
                .foregroundStyle(todoTask.isCompleted ? .secondary : .primary)
            Spacer()
        }
        .padding()
    }
}

fileprivate extension View {
    func loadingActivity(isAnimating: Bool) -> some View {
        modifier(LoadingActivity(isAnimating: isAnimating))
    }
}

fileprivate struct LoadingActivity: ViewModifier {
    private let isAnimating: Bool
    
    init(isAnimating: Bool) {
        self.isAnimating = isAnimating
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                if isAnimating {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.blue)
                }
            }
    }
}

#Preview {
    TodoListView()
}

