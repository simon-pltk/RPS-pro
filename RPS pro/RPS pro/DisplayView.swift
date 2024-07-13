//
//  DisplayView.swift
//  RPS pro
//
//  Created by Simon Plotkin on 6/27/24.
//

import SwiftUI

struct DisplayView: View {
    var image: CGImage?
    private var label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
        } else {
            ZStack {
                Color.black
                Text("Sorry, no camera. :(")
                    .foregroundStyle(.white)
            }
        }
    }
    
    init(image: CGImage? = nil, label: Text = Text("frame")) {
        self.image = image
        self.label = label
    } 
}

#Preview {
    DisplayView()
}
