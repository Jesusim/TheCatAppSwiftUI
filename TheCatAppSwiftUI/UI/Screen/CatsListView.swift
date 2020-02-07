//
//  ContentView.swift
//  SwiftUIRxSwiftTheCatApp
//
//  Created by Admin on 1/28/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import SwiftUI

struct CatsListView: View {
    
    @ObservedObject private var viewModel = CatsListModelView()
    
    init() {
        UITableView.appearance().separatorColor = UIColor.clear
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                List(viewModel.cats) { cat in
                    
                    NavigationLink(destination: DitailCat(cat: cat), label: {
                        CatCell(cat: cat)
                    })
                        
                
                }.navigationBarTitle("Cats")
                
                Button(action: {
                    
                    self.viewModel.setCat()
                    
                }, label: {
                    ZStack {
                        Rectangle()
                            .frame(width: CGFloat(100), height: CGFloat(50), alignment: .center)
                            .cornerRadius(CGFloat(12.0))
                        Text("More cats").foregroundColor(.white)
                    }
                })
                
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatsListView()
    }
}
