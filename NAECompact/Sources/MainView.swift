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
    @State private var showingImagePicker: Bool = false

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Background"))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation: do {
                        self.showingImagePicker.toggle()
                    }
                }) {
                    Viewfinder(image: $mainViewModel.image, boundingBox: $mainViewModel.boundingBox)
                        .frame(maxHeight: 272.0)
                }
                .buttonStyle(PlainButtonStyle())
                if (mainViewModel.image != nil) {
                    DetectionsList(detections: $mainViewModel.detections)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            self.mainViewModel.startClassification()
        }) {
            ImagePicker(image: self.$mainViewModel.image)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mainViewModel: MainViewModel(mlModel: Possums().model))
    }
}
