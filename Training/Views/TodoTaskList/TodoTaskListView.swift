//
//  TaskListView.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import SwiftUI

struct TodoTaskListView: View {
    @StateObject private var viewModel: TodoTaskListViewModel
    @State private var text: String = ""
    @State private var showSheet: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String?
    @State private var saveTask: Task<Void, Never>?

    init(todoTasks: [TodoTask] = []) {
        self._viewModel = StateObject(wrappedValue: TodoTaskListViewModel(list: .init(todoTasks: todoTasks)))
    }

    var body: some View {
        NavigationStack {
            VStack {
                list()
                addTodoTaskButton()
            }
            .navigationTitle(Resources.Titles.navigationStackTitle)
            .sheet(isPresented: $showSheet) {
                sheetContent()
            }
        }
    }
    
    private func list() -> some View {
        List {
            ForEach(viewModel.list.todoTasks) { todoTask in
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
    }
    
    private func sheetContent() -> some View {
        VStack {
            HStack {
                cancelTodoTaskButton()
                Spacer()
                saveTodoTaskButton()
            }
            Spacer()
            TextField(Resources.Titles.textFieldPlaceholder, text: $text)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }
        .loadingActivity(isAnimating: viewModel.isLoading)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage ?? "Error"), dismissButton: .cancel(Text("Ok"), action: {
                alertMessage = nil
            }))
        }
        .padding()
    }
    
    private func cancelTodoTaskButton() -> some View {
        Button(role: .cancel) {
            saveTask?.cancel()
            saveTask = nil
            dismissSheet()
        }
    }
    
    private func saveTodoTaskButton() -> some View {
        Button(role: .confirm) {
            saveTask = Task {
                let result = await viewModel.save(todoTaskName: text)
                guard Task.isCancelled == false else { return }
                switch result {
                case .success(()):
                    dismissSheet()
                case let .failure(error):
                    presentAlert(error: error)
                }
            }
        }
        .disabled(viewModel.isLoading)
    }

    private func presentAlert(error: Error) {
        if let error = error as? AddTodoError {
            alertMessage = error.description
        } else {
            alertMessage = AddTodoError.unknown.description
        }
        showAlert = true
    }

    private func dismissSheet() {
        showSheet = false
        text = ""
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
    TodoTaskListView(todoTasks: .random())
}

