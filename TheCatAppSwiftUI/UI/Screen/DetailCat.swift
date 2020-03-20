//
//  DitailCat.swift
//  SwiftUITheCatApp
//
//  Created by Admin on 2/7/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import SwiftUI

struct DetailCat: View {
    
    var cat : Cat
       
    @ObservedObject var data : InstalImageByURL
    
    init(cat : Cat) {
        self.cat =  cat
        data = InstalImageByURL(cat.url)
    }
   
    
    var body: some View {
        
        Image(uiImage: UIImage(data: data.data) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
