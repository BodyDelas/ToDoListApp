import SwiftUI

struct NewTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var desc: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Название")) {
                    TextField("Введите название задачи", text:  $name)
                        .padding([.leading, .trailing], 3)
                }
                
                Section(header: Text("Описание")) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $desc)
                            .frame(minHeight: 80, maxHeight: .infinity)
                        
                        if desc.isEmpty {
                            Text("Введите описание")
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .padding(.top, 8)
                                .padding([.leading, .trailing], 3)
                                .font(.body)
                        }
                    }
                }
            }
            .navigationTitle(name.isEmpty ? "Новая задача" : name)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Кнопка "Назад"
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Назад")
                        }
                        .foregroundStyle(.yellow)
                    }
                }
                
                // Кнопка "Сохранить"
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveTask()
                    }
                    .foregroundStyle(.yellow)
                    .disabled(name.isEmpty) // Запрещаем сохранение, если поле пустое
                }
            }
        }
    }
    
    private func saveTask() {
        let newTask = TaskItem(context: viewContext)
        newTask.name = name
        newTask.desc = desc
        newTask.dueData = Date() // Ставим текущую дату

        do {
            try viewContext.save()
            dismiss() // Закрываем экран после сохранения
        } catch {
            print("Ошибка сохранения: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NewTaskView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

