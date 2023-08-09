//
//  ContentView.swift
//  BodyTracking2022
//
//  Created by 柳铭坤 on 2023/8/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
