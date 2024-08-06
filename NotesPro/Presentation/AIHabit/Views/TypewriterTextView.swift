//
//  TypewriterTextView.swift
//  NotesPro
//
//  Created by Diki Dwi Diro on 01/08/24.
//

import SwiftUI
import Combine

struct TypewriterTextView: View {
    let text: String
    let interval: TimeInterval
    let onComplete: (() -> Void)?
    
    @State private var displayedText: String = ""
    @State private var isAnimationComplete = false
    @State private var animationCancellable: AnyCancellable?
    @State private var isPaused = false
    
    init(_ text: String, interval: TimeInterval = 0.02, onComplete: (() -> Void)? = nil) {
        self.text = text
        self.interval = interval
        self.onComplete = onComplete
    }
    
    var body: some View {
        Text(displayedText)
            .onAppear(perform: startAnimation)
            .onDisappear(perform: cancelAnimation)
            .onChange(of: text) {
                resetAnimation()
            }
    }
    
    private func startAnimation() {
        guard !isAnimationComplete else { return }
        
        let characters = Array(text)
        var currentIndex = 0
        
        animationCancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard !isPaused && currentIndex < characters.count else {
                    if currentIndex >= characters.count {
                        isAnimationComplete = true
                        animationCancellable?.cancel()
                        onComplete?()
                    }
                    return
                }
                
                displayedText.append(characters[currentIndex])
                currentIndex += 1
            }
    }
    
    private func cancelAnimation() {
        animationCancellable?.cancel()
    }
    
    private func resetAnimation() {
        cancelAnimation()
        displayedText = ""
        isAnimationComplete = false
        startAnimation()
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
    }
}
