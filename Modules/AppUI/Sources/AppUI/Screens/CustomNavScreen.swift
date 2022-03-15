//
//  CustomNavScreen.swift
//  SwiftUI-App
//
//  Created by ILIYA on 24.09.2021.
//

import SwiftUI
import UITools

struct ThirdScreen: View {
    var body: some View {
        VStack {
            Text("Third")
            NavPopButton(destination: .root) {
                Text("Pop to Root")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .background(Color.yellow)
        }
    }
}

struct SecondScreen: View {
    var body: some View {
        VStack {
            Text("Second")
            NavPopButton(destination: .previous) {
                Text("Pop")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
            }
            .background(Color.red)
            
            NavPushButton(destination: ThirdScreen()) {
                Text("Push Third")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                
            }
            .background(Color.blue)
        }
    }
}

struct FirstScreen: View {
    var body: some View {
        VStack {
            Text("First")
            NavPushButton(destination: SecondScreen()) {
                Text("Push")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .background(Color.red)
        }
    }
}

struct CustomNavScreen: View {
    var body: some View {
        NavControllerView {
            FirstScreen()
        }
    }
}


