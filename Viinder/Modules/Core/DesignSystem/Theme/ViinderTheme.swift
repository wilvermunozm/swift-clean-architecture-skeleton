import SwiftUI

struct ViinderTheme {
    let colors: ColorPalette
    let typography: Typography
}

extension ViinderTheme {
    static let light = ViinderTheme(
        colors: .light,
        typography: ViinderTheme.typography()
    )
    
    static let dark = ViinderTheme(
        colors: .dark,
        typography: ViinderTheme.typography()
    )
}

private struct ViinderThemeKey: EnvironmentKey {
    static let defaultValue: ViinderTheme = .light
}

extension EnvironmentValues {
    var viinderTheme: ViinderTheme {
        get { self[ViinderThemeKey.self] }
        set { self[ViinderThemeKey.self] = newValue }
    }
}

extension View {
    func viinderTheme(_ theme: ViinderTheme) -> some View {
        self.environment(\.viinderTheme, theme)
    }
}

extension ColorPalette {
    static let light = ColorPalette(
        primary: Color(hex: "#00FFFF"),
        onPrimary: Color(hex: "#000000"),
        primaryContainer: Color(hex: "#000000"),
        onPrimaryContainer: Color(hex: "#000000"),
        secondary: Color(hex: "#03DAC6"),
        onSecondary: Color(hex: "#000000"),
        secondaryContainer: Color(hex: "#018786"),
        onSecondaryContainer: Color(hex: "#000000"),
        tertiary: Color(hex: "#000000"),
        onTertiary: Color(hex: "#000000"),
        tertiaryContainer: Color(hex: "#000000"),
        onTertiaryContainer: Color(hex: "#000000"),
        error: Color(hex: "#B00020"),
        onError: Color(hex: "#FFFFFF"),
        errorContainer: Color(hex: "#B00020"),
        onErrorContainer: Color(hex: "#FFFFFF"),
        background: Color(hex: "#FFFFFF"),
        onBackground: Color(hex: "#000000"),
        surface: Color(hex: "#FFFFFF"),
        onSurface: Color(hex: "#000000"),
        surfaceVariant: Color(hex: "#FFFFFF"),
        onSurfaceVariant: Color(hex: "#000000"),
        outline: Color(hex: "#B3B3B3")
    )

    static let dark = ColorPalette(
        primary: Color(hex: "#00FFFF"),
        onPrimary: Color(hex: "#000000"),
        primaryContainer: Color(hex: "#00FFFF"),
        onPrimaryContainer: Color(hex: "#000000"),
        secondary: Color(hex: "#03DAC6"),
        onSecondary: Color(hex: "#000000"),
        secondaryContainer: Color(hex: "#03DAC6"),
        onSecondaryContainer: Color(hex: "#000000"),
        tertiary: Color(hex: "#FFFFFF"),
        onTertiary: Color(hex: "#FFFFFF"),
        tertiaryContainer: Color(hex: "#FFFFFF"),
        onTertiaryContainer: Color(hex: "#FFFFFF"),
        error: Color(hex: "#CF6679"),
        onError: Color(hex: "#000000"),
        errorContainer: Color(hex: "#CF6679"),
        onErrorContainer: Color(hex: "#000000"),
        background: Color(hex: "#121212"),
        onBackground: Color(hex: "#000000"),
        surface: Color(hex: "#1E1E1E"),
        onSurface: Color(hex: "#FFFFFF"),
        surfaceVariant: Color(hex: "#1E1E1E"),
        onSurfaceVariant: Color(hex: "#FFFFFF"),
        outline: Color(hex: "#707070")
    )
}
