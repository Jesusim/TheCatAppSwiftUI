//
//  CatsListModelView.swift
//  SwiftUIRxSwiftTheCatApp
//
//  Created by Admin on 1/31/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation

class CatsListModelView : ObservableObject {
    
    private let network: NetworkService = .instance
    @Published var cats = [Cat]()
    
    func setCat() {
        
        network.getCatList(limitCatElemnt: 15) { (cats, error) in
            guard let unrupingCats = cats else { return }
            self.cats += unrupingCats
        }
    }
    
}
