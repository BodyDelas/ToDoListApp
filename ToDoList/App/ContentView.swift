import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .easeIn)
    private var items: FetchedResults<Item>
    
    @State private var item = ["Заметки", "Моя Задача 1", "Моя задача 2", "Игра", "Задача 5", "Заметки", "Моя Задача 1", "Моя задача 2", "Игра", "Задача 5", "Заметки", "Моя Задача 1", "Моя задача 2", "Игра", "Задача 5", "Заметки", "Моя Задача 1", "Моя задача 2", "Игра", "Задача 5"]
    @State private var searchText = ""
    @State private var isSecondScreenPresented = false
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List(filteredItems, id: \.self) { item in
                    HStack(spacing: 0) {
                        Text(item)
                            .padding(5)
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
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Задачи")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        ZStack {
                            if filteredItems.count == 1 {
                                Text("\(filteredItems.count) задачa")
                                    .font(.system(size: 15, weight: .light))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else if (2...4).contains(filteredItems.count) {
                                Text("\(filteredItems.count) задачи")
                                    .font(.system(size: 15, weight: .light))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                Text("\(filteredItems.count) задач")
                                    .font(.system(size: 15, weight: .light))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            ZStack {
                                Button {
                                    isSecondScreenPresented = true
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.yellow)
                                }
                                .sheet(isPresented: $isSecondScreenPresented) {
                                    TwoScene()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
            }
        }
        
        // Фильтрация элементов по поисковому запросу
        var filteredItems: [String] {
            if searchText.isEmpty {
                return item  // Возвращаем все элементы, если текст поиска пустой
            } else {
                // Фильтруем элементы по тексту
                return item.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        }
    }
}


//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

#Preview {
    ContentView()
}
