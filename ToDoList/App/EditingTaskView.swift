
import SwiftUI

struct EditingTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var item: TaskItem
    
    @State private var name: String
    @State private var desc: String
    @State private var dueDate: Date
    
    init(item: TaskItem) {
        self.item = item
        _name = State(initialValue: item.name ?? "")
        _desc = State(initialValue: item.desc ?? "")
        _dueDate = State(initialValue: item.dueDate ?? Date())
    }
    
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
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Отмена")
                        }
                        .foregroundStyle(.yellow)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveItem()
                    }
                    .foregroundStyle(.yellow)
                    .disabled(name.isEmpty)
                }
            }
        }
        
    }
    
    private func saveItem() {
        item.name = name
        item.desc = desc
        item.dueDate = dueDate
        
        do {
            try item.managedObjectContext?.save()
            dismiss()
        } catch {
            print("Ошибка при сохранении задачи: \(error)")
        }
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let task = TaskItem(context: context)
    task.name = "Test Task"
    task.desc = "This is a description for the test task"
    task.dueDate = Date()
    
    return EditingTaskView(item: task)
}
