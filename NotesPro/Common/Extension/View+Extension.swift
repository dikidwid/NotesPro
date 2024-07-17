//
//  View+Extension.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 16/07/24.
//

import SwiftUI

extension View {
    func navigationBarBackgroundColor(_ color: Color) -> some View {
        return self.modifier(NavigationBarTitleColorModifier(color: color))
    }
}

struct NavigationBarTitleColorModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .onAppear {
                let coloredAppearance = UINavigationBarAppearance()
                coloredAppearance.configureWithTransparentBackground()
                coloredAppearance.backgroundColor = UIColor(color)

                UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            }
    }
}
