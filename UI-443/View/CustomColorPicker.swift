//
//  CustomColorPicker.swift
//  UI-443
//
//  Created by nyannyan0328 on 2022/01/31.
//

import SwiftUI
import PhotosUI

extension View{
    
    
    func ImagePicker(showPicker : Binding<Bool>,SelectedColor : Binding<Color>)->some View{
        
        return self
            .fullScreenCover(isPresented: showPicker) {
                
                
            } content: {
                
                Helper(showPicker: showPicker, SlectedColor: SelectedColor)
              
                
                
            }

        
        
    }
}

struct Helper : View{
    
    @Binding var showPicker : Bool
    @Binding var SlectedColor : Color
    
    @State var showImagePicker : Bool = false
    
    @State var imageData : Data = .init(count: 0)
    
    var body: some View{
        
        NavigationView{
            
            
            VStack(spacing:10){
                
                
                GeometryReader{proxy in
                    
                 let size = proxy.size
                    
                    
                    
                    VStack(spacing:10){
                        
                        if let image = UIImage(data: imageData){
                            
                            
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width, height: size.height)
                              
                            
                            
                        }
                        else{
                            
                            
                            Image(systemName: "plus")
                                .font(.system(size: 15, weight: .bold))
                            
                            
                            
                            Text("Tap To Image")
                                .font(.system(size: 20, weight: .light))
                        }
                            
                        
                        
                    
                        
                        
                        
                        
                    }
                    .frame(maxWidth:.infinity,maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        
                        
                        withAnimation{
                            
                            showImagePicker.toggle()
                            
                            
                        }
                        
                        
                    }
                }
                
                
                
                ZStack(alignment: .top){
                    
                    
                    Rectangle()
                        .fill(SlectedColor)
                        .frame(height:90)
                    
                    
                    customColorPicker(color: $SlectedColor)
                        .frame(width: 100, height: 50,alignment: .topLeading)
                        .clipped()
                        .offset(x: 20)
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            }
        
            
            
            
            .ignoresSafeArea(.container, edges: .bottom)
                .navigationTitle("Color Picker")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    
                    Button("Cancel"){
                        
                        
                        showPicker.toggle()
                    }
                
                
            
        }
            
                .sheet(isPresented: $showImagePicker) {
                    
                    
                } content: {
                    
                    ImagePickerView(showPicker: $showImagePicker, imageData: $imageData)
                    
                   
                }

      
        }
    }
    
    
}

struct ImagePickerView : UIViewControllerRepresentable{
    
    
    @Binding var showPicker : Bool
    @Binding var imageData : Data
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
        
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let pikcer =  PHPickerViewController(configuration: config)
        pikcer.delegate = context.coordinator
        
        
        return pikcer
        
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,PHPickerViewControllerDelegate{
       
        
        
        var parent : ImagePickerView
        
        init(parent : ImagePickerView) {
            self.parent = parent
        }
        
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            
            if let first = results.first{
                
                first.itemProvider.loadObject(ofClass: UIImage.self) {[self] result, err in
                    
                    
                    
                    guard let image = result as? UIImage else{
                        
                        
                        parent.showPicker.toggle()
                        
                        return
                    }
                    
                    parent.imageData = image.jpegData(compressionQuality: 1) ?? .init(count: 0)
                    parent.showPicker.toggle()
                }
            }
            
            else{
                
                parent.showPicker.toggle()
            }
            
        }
        
    }
    
    
}


struct customColorPicker : UIViewControllerRepresentable{
    
    
    @Binding var color : Color
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController{
        
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.selectedColor = UIColor(color)
        picker.title = ""
        picker.delegate = context.coordinator
        
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        
        uiViewController.view.tintColor = (color.isDarkColor ? .white : .black)
        
    }
    
    class Coordinator : NSObject,UIColorPickerViewControllerDelegate{
        
        
        var parent : customColorPicker
        
        init(parent : customColorPicker) {
            self.parent = parent
        }
        
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            
            parent.color = Color(viewController.selectedColor)
            
        }
        
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            
            
            parent.color = Color(color)
            
            
        }
        
        
        
    }
    
    
}

extension Color{
    
    var isDarkColor : Bool{
        
        return UIColor(self).isDarkColor
    }
    
    
}

extension UIColor{
    
    
    var isDarkColor : Bool{
        
        var (r, g, b, a): (CGFloat,CGFloat,CGFloat,CGFloat) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
        
    }
}



