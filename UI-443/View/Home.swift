//
//  Home.swift
//  UI-443
//
//  Created by nyannyan0328 on 2022/01/31.
//

import SwiftUI

struct Home: View {
    @State var showPicker : Bool = false
    @State var selectedColor : Color = .white
    var body: some View {
        ZStack{
            
            
            Rectangle()
                .fill(selectedColor)
                .ignoresSafeArea()
            
            
            Button {
                
                
                withAnimation{
                    
                    showPicker.toggle()
                }
                
            } label: {
                
                Text("Show Picker")
                    .font(.title.bold())
                    .foregroundColor(selectedColor.isDarkColor ? .white : .black)
            }

            
            
        }
        .ImagePicker(showPicker: $showPicker, SelectedColor: $selectedColor)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
