//
//  ShoppingAppApp.swift
//  ShoppingApp
//
//  Created by Andrii Piddubnyi on 1/14/24.
//

import SwiftUI
import Firebase
@main
struct ShoppingAppApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
