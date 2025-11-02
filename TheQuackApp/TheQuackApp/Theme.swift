import SwiftUI

enum Theme {
    // Pale mint background (top)
    //static let bgTop = Color(red: 226/255, green: 247/255, blue: 235/255)
    static let bgTop = Color(red: 0.8, green: 0.9, blue: 0.8)
    // Slightly darker mint (bottom)
    static let bgBottom = Color(red: 217/255, green: 243/255, blue: 224/255)
    
    // Stronger green for buttons
    static let buttonGreen = Color(red: 98/255, green: 143/255, blue: 98/255)
    
    // Card background
    static let cardBackground = Color.white.opacity(0.95)
    
    // Search background
    static let searchBackground = Color(red: 98/255, green: 143/255, blue: 98/255).opacity(0.15)
}
