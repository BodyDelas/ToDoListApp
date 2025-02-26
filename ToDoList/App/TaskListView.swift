import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.dueData, ascending: true)],
        animation: .easeIn)
    
    private var items: FetchedResults<TaskItem>
    @State private var searchText = ""
    @State private var isSecondScreenPresented = false
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List() {
                    ForEach(items) { item in
                        NavigationLink {
                            EditingTaskView()
                        } label: {
                            VStack(alignment: .leading ,spacing: 0) {
                                Text(item.name ?? "Без названия")
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: item.desc!.isEmpty ? 0 : 10, trailing: 0))
                                Text(item.desc ?? "Без описания")
                                    .font(.subheadline)
                                    .padding(.bottom, 3)
                                if let dueDate = item.dueData {
                                    Text(itemFormatter.string(from: dueDate))
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .contextMenu {
                            Button{}
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
                            Text("Задачи")
                            ZStack {
                                NavigationLink {
                                    //isSecondScreenPresented = true
                                    NewTaskView()
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.yellow)
                                }
                                //.sheet(isPresented: $isSecondScreenPresented) {
                                //TwoScene()
                                //}
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
            // Удаляем задачу
            viewContext.delete(item)
            
            // Сохраняем изменения в контексте
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




