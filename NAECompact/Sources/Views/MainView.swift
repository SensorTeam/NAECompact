//
//  MainView.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 15/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI

struct MainView: View {

    @ObservedObject var mainViewModel: MainViewModel
    @State private var image: UIImage?
    @State private var showingImagePicker: Bool = false
    @State private var showingConfig: Bool = false

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Background"))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {

                // Navigation Bar
                NavigationBar(title: "Wildlife Identifier", symbol: "ellipsis", action: {
                    withAnimation: do {
                        self.showingConfig.toggle()
                    }
                })
                .sheet(isPresented: $showingConfig, onDismiss: {

                }) {
                    ConfigView(isOn: self.$mainViewModel.usesRealModel)
                }

                // Image Viewfinder
                Button(action: {
                    self.showingImagePicker.toggle()
                }) {
                    Viewfinder(image: self.$image, boundingBox: $mainViewModel.boundingBox)
                        .frame(maxHeight: 272.0)
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePicker { image in
                                guard let image = image else {
                                    return
                                }

                                self.image = image
                                self.mainViewModel.startClassification(for: image)
                            }
                        }
                }
                .buttonStyle(PlainButtonStyle())

                // Detections List
                if (image != nil) {
                    DetectionsList(detections: $mainViewModel.detections)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainViewModel: MainViewModel())
    }
}