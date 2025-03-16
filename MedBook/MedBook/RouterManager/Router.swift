//
//  Router.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func popBack() {
        path.removeLast()
    }
    
    func popALL() {
        path.removeLast(path.count)
    }
    
    func navigateTo(_ screen: Screens) {
        path.append(screen)
    }
}
