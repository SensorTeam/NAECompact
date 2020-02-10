//
//  ContentView.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 10/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var hasImage = false

    var body: some View {
        VStack {
            AnimalImage(imageName: "Test Image")
            VStack {
                Button(action: { self.hasImage.toggle() }) {
                    Text("Choose Image")
                        .fontWeight(.bold)
                        .padding(16.0)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AnimalImage: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(8.0)
            .padding(16.0)
            .shadow(radius: 10)
    }
}
