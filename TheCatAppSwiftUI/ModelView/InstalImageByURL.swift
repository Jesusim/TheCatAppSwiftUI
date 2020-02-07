//
//  InstalImageByURL.swift
//  SwiftUITheCatApp
//
//  Created by Admin on 2/6/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation

class InstalImageByURL : ObservableObject {
    
    @Published var data = Data()

    init(_ imageString: String) {
        
        DispatchQueue.global().async {
            if let url = URL(string: imageString ), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                     self.data = data
                }
            }
        }
       
    }

}
