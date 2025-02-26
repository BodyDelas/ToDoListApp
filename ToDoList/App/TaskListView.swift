import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)],
        animation: .easeIn)
    
    private var items: FetchedResults<TaskItem>
    @State private var searchText = ""
    @State private var isSecondScreenPresented = false
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private var filteredItems: [TaskItem] {
        if searchText.isEmpty {
            return Array(items) // Возвращаем все задачи, если строка поиска пустая
        } else {
            return items.filter { item in
                item.name?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List() {
                    ForEach(filteredItems) { item in
                        NavigationLink {
                            EditingTaskView(item: item)
                        } label: {
                            VStack(alignment: .leading ,spacing: 0) {
                                Text(item.name ?? "Без названия")
                                    .font(.headline)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: item.desc!.isEmpty ? 0 : 10, trailing: 0))
                                Text(item.desc ?? "Без описания")
                                    .font(.subheadline)
                                    .padding(.bottom, 3)
                                if let dueDate = item.dueDate {
                                    Text(itemFormatter.string(from: dueDate))
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .contextMenu {
                            NavigationLink{
                                EditingTaskView(item: item)
                            }
                            label:{
                                Text("Редактировать")
                                Image(systemName: "highlighter")
                            }
                            Button{}
                            label:{
                                Text("Поделиться")
                                Image(systemName: "paperplane")
                            }
                            Button(role: .destructive) {
                                deleteItem(item)
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Задачи")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        ZStack {
                            if filteredItems.count % 10 == 1{
                                Text("\(filteredItems.count) задачa")
                                    .font(.system(size: 15, weight: .light))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else if
                                filteredItems.count % 10 == 2 ||
                                filteredItems.count % 10 == 3 ||
                                filteredItems.count % 10 == 4 {
                                Text("\(filteredItems.count) задачи")
                                    .font(.system(size: 15, weight: .light))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                Text("\(filteredItems.count) задач")
                                    .font(.system(size: 15, weight: .light))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            ZStack {
                                NavigationLink {
//                                    isSecondScreenPresented = true
                                    NewTaskView()
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.yellow)
                                }
//                                .sheet(isPresented: $isSecondScreenPresented) {
//                                    NewTaskView()
//                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
            }
        }
    }
    private func deleteItem(_ item: TaskItem) {
        withAnimation {
            viewContext.delete(item)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    TaskListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}




