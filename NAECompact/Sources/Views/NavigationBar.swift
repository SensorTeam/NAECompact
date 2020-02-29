//
//  NavigationBar.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 16/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI

struct NavigationBar: View {

    // use regular SwiftUI navigation view

    var title: String = ""
    var symbol: String = "ellipsis"
    var action: (() -> Void)

    var body: some View {
        ZStack {
            Text(self.title)
                .foregroundColor(Color("Primary"))
                .fontWeight(.semibold)
            Group {
                Button(action: self.action) {
                    Image(systemName: self.symbol)
                        .foregroundColor(Color("Accent"))
                        .font(.system(size: 22.0))
                        .frame(width: 44.0, height: 44.0, alignment: .trailing)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 44.0, alignment: .trailing)
        }
        .padding(.leading, 16.0)
        .padding(.trailing, 16.0)
        .frame(maxWidth: .infinity, maxHeight: 44.0)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "Page Title", symbol: "ellipsis", action: {
            // do nothing
        })
            .previewLayout(.fixed(width: 375.0, height: 44.0))
            .background(
                Rectangle()
                    .foregroundColor(Color("Background"))
            )
    }
}
