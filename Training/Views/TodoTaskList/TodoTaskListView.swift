//
//  TaskListView.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import SwiftUI

struct TodoTaskListView: View {
    @StateObject private var viewModel: TodoTaskListViewModel

    init(todoTasks: [TodoTask] = []) {
        self._viewModel = StateObject(wrappedValue: TodoTaskListViewModel(list: .init(todoTasks: todoTasks)))
    }

    var body: some View {
        NavigationStack {
            VStack {
                list()
                button()
            }
            .navigationTitle(Resources.Titles.navigationStackTitle)
            .sheet(isPresented: $viewModel.isSheetPresented) {
                sheetContent()
            }
        }
    }
    
    private func list() -> some View {
        List {
            ForEach(viewModel.list.todoTasks) { todoTask in
                TodoTaskView(todoTask: todoTask)
                    .onTapGesture { viewModel.select(todoTask) }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.delete(todoTask)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
            }
            Text(Resources.Titles.remainingTasks + "\(viewModel.uncompletedTasksCount())")
        }
    }

    private func button() -> some View {
        Button {
            viewModel.presentSheet()
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
                Button(role: .cancel) {
                    viewModel.dismissSheet()
                }
                Spacer()
                Button(role: .confirm) {
                    viewModel.save()
                }
            }
            Spacer()
            TextField(Resources.Titles.textFieldPlaceholder, text: $viewModel.text)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TodoTaskListView(todoTasks: .random())
}
