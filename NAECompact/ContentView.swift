//
//  ContentView.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 10/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var image: Image? = nil
    @State var showImagePicker: Bool = false

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.black)
                    self.image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    VStack {
                        Rectangle()
                            .frame(width: 64.0, height: 48.0)
                            .foregroundColor(.clear)
                            .border(Color.green, width: 3.0)
                            .cornerRadius(4.0)
                        ZStack {
                            Rectangle()
                                .foregroundColor(.green)
                            Text("Sheep")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 64.0, height: 24.0)
                        .cornerRadius(4.0)
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.width * 1.44)
                .cornerRadius(8.0)
                .shadow(radius: 10)
            }
            .frame(maxHeight: 256.0)
            .padding(16.0)
            VStack {
                Button(action: {
                    withAnimation: do {
                        self.showImagePicker.toggle()
                    }
                }) {
                    Text("Choose Image")
                        .fontWeight(.bold)
                        .padding(16.0)
                }
            }
            .sheet(isPresented: $showImagePicker) {
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

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
