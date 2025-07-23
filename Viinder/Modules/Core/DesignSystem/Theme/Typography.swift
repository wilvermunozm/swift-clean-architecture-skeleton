import SwiftUI

let workSansExtraBoldFontName = "WorkSans-ExtraBold"
let workSansBoldFontName = "WorkSans-Bold"
let workSansSemiBoldFontName = "WorkSans-SemiBold"
let workSansRegularFontName = "WorkSans-Regular"
let workSansMediumFontName = "WorkSans-Medium"

struct Typography {
    let headlineLarge: Font
    let headlineMedium: Font
    let headlineSmall: Font
    let titleLarge: Font
    let titleMedium: Font
    let titleSmall: Font
    let bodyLarge: Font
    let bodyMedium: Font
    let bodySmall: Font
    let labelLarge: Font
    let labelMedium: Font
    let labelSmall: Font
}

extension ViinderTheme {
    
    static func typography() -> Typography {
        return Typography(
            headlineLarge: .custom(workSansBoldFontName, size: 32),
            headlineMedium: .custom(workSansBoldFontName, size: 28),
            headlineSmall: .custom(workSansBoldFontName, size: 24),
            titleLarge: .custom(workSansSemiBoldFontName, size: 22),
            titleMedium: .custom(workSansSemiBoldFontName, size: 18),
            titleSmall: .custom(workSansSemiBoldFontName, size: 16),
            bodyLarge: .custom(workSansRegularFontName, size: 16),
            bodyMedium: .custom(workSansRegularFontName, size: 14),
            bodySmall: .custom(workSansRegularFontName, size: 12),
            labelLarge: .custom(workSansMediumFontName, size: 14),
            labelMedium: .custom(workSansMediumFontName, size: 12),
            labelSmall: .custom(workSansMediumFontName, size: 11)
        )
    }
}

extension Font {
    static func workSansBold(size: CGFloat) -> Font {
        return .custom(workSansBoldFontName, size: size)
    }
    
    static func workSansExtraBold(size: CGFloat) -> Font {
        return .custom(workSansExtraBoldFontName, size: size)
    }
    
    static func workSansSemiBold(size: CGFloat) -> Font {
        return .custom(workSansSemiBoldFontName, size: size)
    }
    
    static func workSansMedium(size: CGFloat) -> Font {
        return .custom(workSansMediumFontName, size: size)
    }
    
    static func workSansRegular(size: CGFloat) -> Font {
        return .custom(workSansRegularFontName, size: size)
    }
    
    static func workSansLight(size: CGFloat) -> Font {
        return .custom("worksans_light", size: size)
    }
}
