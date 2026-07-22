//
//  TaskListView.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel: TaskListViewModel

    init(tasks: [Task] = []) {
        self._viewModel = StateObject(wrappedValue: TaskListViewModel(list: .init(tasks: tasks)))
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                list()
                Spacer()
                button()
            }
            .navigationTitle(Resources.Titles.navigationStackTitle)
            .sheet(isPresented: $viewModel.isSheetPresented) {
                sheetContent()
            }
        }
    }
    
    private func list() -> some View {
        ForEach(viewModel.list.tasks) { task in
            TaskView(task: task)
                .onTapGesture {
                    viewModel.select(task)
                }
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
    TaskListView(tasks: .random())
}
