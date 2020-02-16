//
//  DetectionsList.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 15/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI

struct DetectionsList: View {

    @Binding var detections: [Detection]

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)

            if (!detections.isEmpty) {
                VStack(spacing: 0) {
                    ForEach(0..<detections.endIndex) { index in
                        DetectionRow(label: self.$detections[index].identifier, confidence: self.$detections[index].confidence, isProminent: index == 0)
                    }
                }
            } else {
                VStack {
                    Image(systemName: "eye.slash")
                        .font(.title)
                        .padding(.bottom, 8.0)
                    Text("No animal eyes detected")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color("Secondary"))
            }
        }
        .padding(24.0)
    }
}

struct DetectionRow: View {

    @Binding var label: String
    @Binding var confidence: Float

    var isProminent: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Divider
            if (!isProminent) {
                Rectangle()
                    .foregroundColor(Color("Divider"))
                    .frame(height: 1.0)
                    .padding(.top, 16.0)
                    .padding(.bottom, 16.0)
            }

            // Cell
            HStack {
                // Label
                VStack(spacing: 0) {
                    Text(self.label.capitalized)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Primary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4.0)
                    Text(String(format: "%.4f Confidence", Float(self.confidence)))
                        .font(.system(size: 13.0, weight: .semibold, design: .monospaced))
                        .fontWeight(.semibold)
                        .foregroundColor(self.isProminent ? Color("Accent") : Color("Secondary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Confidence spark-chart
                ConfidenceGauge(confidence: self.$confidence, isProminent: self.isProminent)
            }
            .foregroundColor(Color("Primary"))
        }
    }
}

struct ConfidenceGauge: View {

    @Binding var confidence: Float

    @State private var progress: CGFloat = 0

    var isProminent: Bool

    var confidenceAsPercent: String {
        if (self.confidence > 0.1) {
            let nf = NumberFormatter()
            nf.numberStyle = .percent
            return nf.string(from: NSNumber(value: self.confidence)) ?? "0%"
        } else {
            return "<1%"
        }
    }

    var body: some View {
        ZStack {
            Group {
                Circle()
                    .stroke(lineWidth: 4.0)
                    .opacity(0.2)
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 270.0))
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1)
                        return withAnimation(baseAnimation) {
                            self.progress = CGFloat(self.confidence)
                        }
                    }
            }.foregroundColor(self.isProminent ? Color("Accent") : Color("Secondary"))

            Text("\(self.confidenceAsPercent)")
                .font(.system(size: 12.0, weight: .medium, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(Color("Primary"))
        }
        .padding(4.0)
        .frame(width: 46.0, height: 46.0)
    }
}

struct DetectionsList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // State 1 of 2: No Detection
            DetectionsList(detections: .constant([]))
                .previewLayout(.fixed(width: 375.0, height: 394.0))
                .background(
                    Rectangle()
                        .foregroundColor(Color("Background"))
            )

            // State 2 of 2: Has Detections
            DetectionsList(detections: .constant([
                Detection(identifier: "Possum", confidence: 0.9765),
                Detection(identifier: "Cat"),
                Detection(identifier: "Fox"),
                Detection(identifier: "Sheep"),
                Detection(identifier: "Cow")
            ]))
                .previewLayout(.fixed(width: 375.0, height: 394.0))
                .background(
                    Rectangle()
                        .foregroundColor(Color("Background"))
            )
        }
    }
}
