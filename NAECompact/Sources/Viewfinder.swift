//
//  Viewfinder.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 15/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI

struct Viewfinder: View {

    @Binding var image: UIImage?
    @Binding var boundingBox: CGRect?

    var body: some View {
        ZStack {
            // Image container
            GeometryReader { geometry in
                // Base
                RoundedRectangle(cornerRadius: 8.0)
                    .foregroundColor(Color("Primary"))
                    .opacity(0.02)

                // Scaled image
                if (self.image != nil) {
                    Image(uiImage: self.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        .mask(
                            RoundedRectangle(cornerRadius: 8.0)
                                .foregroundColor(Color("Background"))
                                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        )
                }

                // Detection bounding box
                if (self.image != nil && self.boundingBox != nil) {
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color("Accent"))
                        .frame(maxWidth: self.boundingBox!.width * geometry.size.width, maxHeight: self.boundingBox!.height * geometry.size.height)
                        .offset(x: self.boundingBox!.minX * geometry.size.width, y: (1 - self.boundingBox!.minY - self.boundingBox!.height) * geometry.size.height)
                }

                // Border overlay
                RoundedRectangle(cornerRadius: 7.0)
                    .stroke(lineWidth: 1.0)
                    .foregroundColor(Color("Primary"))
                    .opacity(0.1)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            }

            // Show button action as placeholder if no image is available
            if (image == nil) {
                VStack {
                    Image(systemName: "photo")
                        .font(.title)
                        .padding(.bottom, 8.0)
                    Text("Choose Photo")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color("Accent"))
            }
        }
        .padding(16.0)
    }
}

struct Viewfinder_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // State 1 of 3: No Image
            Viewfinder(image: .constant(nil), boundingBox: .constant(nil))
                .previewLayout(.fixed(width: 375.0, height: 272.0))
                .background(
                    Rectangle()
                        .foregroundColor(Color("Background"))
                )

            // State 2 of 3: Image with Detection
            Viewfinder(image: .constant(UIImage(named: "Possum")), boundingBox: .constant(CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)))
                .previewLayout(.fixed(width: 375.0, height: 272.0))
                .background(
                    Rectangle()
                        .foregroundColor(Color("Background"))
                )

            // State 3 of 3: Image without Detection
            Viewfinder(image: .constant(UIImage(named: "Possum")), boundingBox: .constant(nil))
                .previewLayout(.fixed(width: 375.0, height: 272.0))
                .background(
                    Rectangle()
                        .foregroundColor(Color("Background"))
                )
        }
    }
}
