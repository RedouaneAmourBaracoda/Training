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
        self._viewModel = StateObject(wrappedValue: TaskListViewModel(tasks: tasks))
    }

    var body: some View {
        NavigationStack {
            VStack {
                ForEach(viewModel.tasks, id: \.name) {
                    TaskView(task: $0)
                }
            }
            .navigationTitle(Resources.Titles.navigationStackTitle)
        }
    }
}

#Preview {
    TaskListView(tasks: .random())
}
