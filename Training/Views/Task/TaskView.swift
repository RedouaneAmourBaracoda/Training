//
//  ContentView.swift
//  Training
//
//  Created by Redouane Amour on 14/07/2026.
//

import Combine
import SwiftUI

struct TaskView: View {
    private let task: Task
    
    init(task: Task) {
        self.task = task
    }

    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Spacer()
            Text(task.name)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TaskView(task: .random())
}
