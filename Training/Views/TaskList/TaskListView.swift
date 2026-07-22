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
                ForEach(viewModel.list.tasks) { task in
                    TaskView(task: task)
                        .onTapGesture {
                            viewModel.list.check(task)
                        }
                }
            }
            .navigationTitle(Resources.Titles.navigationStackTitle)
        }
    }
}

#Preview {
    TaskListView(tasks: .random())
}
