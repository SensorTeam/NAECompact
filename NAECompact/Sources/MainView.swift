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

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Background"))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                Button(action: {
                    self.mainViewModel.setImage()
                    self.mainViewModel.setDetections()
                }) {
                    Viewfinder(image: $mainViewModel.image, boundingBox: $mainViewModel.boundingBox)
                        .frame(maxHeight: 272.0)
                }
                .buttonStyle(PlainButtonStyle())
                if (mainViewModel.image != nil) {
                    ScrollView {
                        DetectionsList(detections: $mainViewModel.detections)
                    }
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
