import Foundation
import SwiftUI

enum CustomFonts: String {
    case ubuntu = "Ubuntu"
}

extension Font {
    static func custom(_ customFonts: CustomFonts, size: CGFloat) -> Font {
        return Font.custom(customFonts.rawValue, fixedSize: size)
    }
}

struct FontBuilder {
    let font: Font
    let tracking: Double
    let lineSpacing: Double
    let verticalPadding: Double
    let weight: Font.Weight
    
    init(
        customFont: CustomFonts,
        fontSize: Double,
        letterSpacing: Double,
        lineHeight: Double,
        weight: Font.Weight
    ) {
        self.font = Font.custom(customFont, size: fontSize)
        self.tracking = fontSize * letterSpacing
        let uiFont = UIFont(name: customFont.rawValue, size: fontSize) ?? .systemFont(ofSize: fontSize)
        self.lineSpacing = lineHeight - uiFont.lineHeight
        self.verticalPadding = lineSpacing / 2
        self.weight = weight
    }
}

extension FontBuilder {
    static let titleMainFoodDiary = FontBuilder(
        customFont: .ubuntu,
        fontSize: 20,
        letterSpacing: 1.0,
        lineHeight: 24.0,
        weight: .bold
    )
        static let titleSecondFoodDiary = FontBuilder(
            customFont: .ubuntu,
            fontSize: 16,
            letterSpacing: 1.0,
            lineHeight: 24.0,
            weight: .regular
        )
    static let bottombarText = FontBuilder(
        customFont: .ubuntu,
        fontSize: 12,
        letterSpacing: 1.0,
        lineHeight: 16.0,
        weight: .heavy
        
    )
    static let scrollText = FontBuilder(
        customFont: .ubuntu,
        fontSize: 18,
        letterSpacing: 1.0,
        lineHeight: 24.0,
        weight: .regular
    )
    static let searchResultRow = FontBuilder(
        customFont: .ubuntu,
        fontSize: 18,
        letterSpacing: 1.0,
        lineHeight: 24.0,
        weight: .medium
    )
    static let h2 = FontBuilder(
        customFont: .ubuntu,
        fontSize: 24,
        letterSpacing: 1.0,
        lineHeight: 24.0,
        weight: .heavy
    )
}


// Создание собсвенного модификатора
struct CustomFontsModifire: ViewModifier {

    private let fontBuilder: FontBuilder

    init(_ fontBuilder: FontBuilder) {
        self.fontBuilder = fontBuilder
    }

    func body (content: Content) -> some View {
        content
            .font(fontBuilder.font)
            .lineSpacing(fontBuilder.lineSpacing)
            .fontWeight(fontBuilder.weight)
    }
}

extension View {
    func customFont(_ fontBuilder: FontBuilder) -> some View {
        return self.modifier(CustomFontsModifire(fontBuilder))
    }
}

