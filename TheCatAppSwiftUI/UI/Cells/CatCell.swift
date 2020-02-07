//
//  CatCell.swift
//  SwiftUITheCatApp
//
//  Created by Admin on 2/6/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import SwiftUI

struct CatCell: View {
    
    var cat : Cat
    
    @ObservedObject var data : InstalImageByURL
    
    init(cat : Cat) {
        self.cat =  cat
        data = InstalImageByURL(cat.url)
    }
    
    var body: some View {
        
        VStack {
            Image(uiImage: UIImage(data: data.data) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(7)
            Text(cat.id)
        }
        
    }
    
}
