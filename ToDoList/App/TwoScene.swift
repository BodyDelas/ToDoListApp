
import SwiftUI

struct TwoScene: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text("Второй экран")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Кастомная кнопка "Назад"
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
            }
    }
}


#Preview {
    TwoScene()
}
