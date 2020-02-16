//
//  ConfigView.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 16/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI

struct ConfigView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var isOn: Bool = true

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Background"))
                .edgesIgnoringSafeArea(.all)
            Rectangle()
                .foregroundColor(Color("Primary"))
                .edgesIgnoringSafeArea(.all)
                .opacity(0.025)
            
            VStack(spacing: 0) {
                NavigationBar(title: "Config", symbol: "xmark", action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .padding(.top, 8.0)
                .padding(.bottom, 24.0)

                Toggle(isOn: $isOn) {
                    Text("Classify Real Wildlife")
                        .foregroundColor(Color("Primary"))
                }
                .padding(16.0)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
