//
//  TodoTaskView.swift
//  Training
//
//  Created by Redouane Amour on 14/07/2026.
//

import SwiftUI

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

#Preview {
    TodoTaskView(todoTask: .random())
}
