import SwiftUI

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if !isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            DispatchQueue.global(qos: .background).async {
                Task {
                    do {
                        let data = try await TaskAPI.shared.fetchTasks()
                        DBHelper.shared.addTaskArray(items: data)
                    } catch {
                        print("Ошибка при загрузке данных: \(error)")
                    }
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}
