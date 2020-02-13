//
//  ContentView.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 10/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var image: Image? = nil
    @State private var showingImagePicker: Bool = false

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Background"))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                TitleBar()
                if (image == nil) {
                    Text("Choose photo to start")
                        .foregroundColor(Color("Tertiary"))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(spacing: 0) {
                        ClassificationImage(image: image)
                        HStack {
                            ClassificationLabel(label: "Ringtail Possum")
                            ClassificationConfidence(confidence: 0.67)
                        }
                        .padding(.horizontal, 32.0)
                        .padding(.vertical, 16.0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                Button(action: {
                    withAnimation: do {
                        self.showingImagePicker.toggle()
                    }
                }) {
                    LibraryButton()
                }
                .foregroundColor(Color("Background"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: self.$image)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TitleBar: View {
    var body: some View {
        Text("Wildlife Identifier")
            .foregroundColor(Color("Primary"))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: 44.0)
            .padding(.bottom, 16.0)
    }
}

struct ClassificationImage: View {
    @State var image: Image? = nil

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .foregroundColor(Color("Background"))
                .cornerRadius(8.0)
            self.image?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .mask(
                    Rectangle()
                        .foregroundColor(Color("Background"))
                        .cornerRadius(8.0)
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
            )
            RoundedRectangle(cornerRadius: 7.0)
                .stroke(lineWidth: 1.0)
                .foregroundColor(Color("Divider"))
                .frame(maxWidth: geometry.size.width - 2, maxHeight: geometry.size.height - 2)
                .offset(x: 1.0, y: 1.0)
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(lineWidth: 4.0)
                .foregroundColor(Color("Accent"))
                .frame(maxWidth: 96.0, maxHeight: 69.0)
                .offset(x: 94.0, y: 70.0)
        }
        .padding(.horizontal, 16.0)
        .frame(maxHeight: 240.0)
    }
}

struct ClassificationConfidence: View {
    @State var confidence: Float = 0.0

    var percentConfidence: String {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        return nf.string(from: NSNumber(value: confidence)) ?? "0%"
    }

    var body: some View {
        ZStack {
            if (confidence > 0.0) {
                Circle()
                    .stroke(lineWidth: 4.0)
                    .foregroundColor(Color("Accent"))
                    .opacity(0.2)
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.confidence, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color("Accent"))
                    .rotationEffect(Angle(degrees: 270.0))
            } else {
                Circle()
                    .stroke(lineWidth: 4.0)
                    .foregroundColor(Color("Primary"))
                    .opacity(0.2)
            }
            Text("\(percentConfidence)")
                .foregroundColor(Color("Primary"))
                .font(.footnote)
                .fontWeight(.bold)
        }.frame(maxWidth: 48.0, maxHeight: 48.0)
    }
}

struct ClassificationLabel: View {
    @State var label: String

    var body: some View {
        VStack {
            if (label != "") {
                Text("Detected")
                    .foregroundColor(Color("Accent"))
                    .font(.footnote)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(label)")
                    .foregroundColor(Color("Primary"))
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Detected")
                    .foregroundColor(Color("Secondary"))
                    .font(.footnote)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("None Detected")
                    .foregroundColor(Color("Primary"))
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct LibraryButton: View {
    var body: some View {
        GeometryReader { screenGeometry in
            ZStack {
                Rectangle()
                    .foregroundColor(Color("Primary"))
                    .cornerRadius(28.0)
                Text("Choose Photo")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: screenGeometry.size.width - 64.0)
        }
        .frame(maxWidth: .infinity, maxHeight: 56.0)
        .padding(.bottom, 32.0)
    }
}
