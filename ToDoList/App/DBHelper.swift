import Foundation


class DBHelper {
    static let shared = DBHelper()
    
    func addTask(item: TodoItem) {
        let context = PersistenceController.shared.container.viewContext
        
        // Создаем новый объект Task
        let newTask = TaskItem(context: context)
        newTask.name = item.todo
        newTask.desc = ""
        newTask.dueDate = Date()
        newTask.isCompleted = item.completed // Устанавливаем начальное состояние как невыполненное
        
        // Сохраняем контекст
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
    
    func addTaskArray(items:[TodoItem]) {
        for el in items {
            addTask(item: el)
        }
    }
}
