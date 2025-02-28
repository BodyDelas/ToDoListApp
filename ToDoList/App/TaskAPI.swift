import Foundation

struct TodosModel: Codable {
    let todos: [TodoItem]
}

struct TodoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

class TaskAPI {
    static let shared = TaskAPI()
    
    func fetchTasks() async throws -> [TodoItem] {

        guard let url = URL(string: "https://dummyjson.com/todos") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedTasks = try JSONDecoder().decode(TodosModel.self, from: data)
        print(decodedTasks.todos)
        return decodedTasks.todos
    }
}
