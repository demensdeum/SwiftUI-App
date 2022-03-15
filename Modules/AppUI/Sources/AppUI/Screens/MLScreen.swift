//
//  File.swift
//  
//
//  Created by ILIYA on 07.01.2022.
//

import SwiftUI
import CoreML

struct MLScreen: View {
    
    @ObservedObject var viewModel = MLScreenViewModel()
    
    var body: some View {
        VStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .scaledToFill()
                .frame(width: 320, height: 320)
                .clipped()
                .background(Color.black.opacity(0.2))
            
            Text("Load photo")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(16)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .onTapGesture {
                    viewModel.showSheet = true
                }
            Text(viewModel.text)
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $viewModel.showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.image)
        }
    }
    
}

class MLScreenViewModel: ObservableObject {
    
    private let ml = try? KeiraOrPortman(configuration: MLModelConfiguration())
    
    @Published var image = UIImage() {
        didSet {
            classify(image: image)
        }
    }
    @Published var showSheet = false
    @Published var text = "Load someone's photo"
    
    private func classify(image: UIImage) {
        guard let buffer = image.toCVPixelBuffer(),
              let predictions = try? ml?
                .prediction(image: buffer)
                .featureValue(for: "classLabelProbs")?
                .dictionaryValue,
        let keira = predictions["keira knightley"]?.floatValue,
        let natalie = predictions["natalie portman"]?.floatValue
        else {
                  text = "Eh? Error! 146%"
                  return
              }
        text = "Keira Knightley: \(Int(keira * 100)) %\nNatalie Portman: \(Int(natalie * 100))%"
    }
}
