//
//  UIBlurView.swift
//  Recipe
//
//  Created by Даниил Иваньков on 05.02.2025.
//

import Foundation
import UIKit
import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
    
    
}
