import SwiftUI

struct CollageView: View {
    @EnvironmentObject var model: CollageModel
    @State private var showingFeatureAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    model.backgroundColor
                        .ignoresSafeArea()
                    
                    ForEach(model.elements.indices, id: \.self) { index in
                        Group {
                            if model.elements[index].isSystemImage {
                                Image(systemName: model.elements[index].image)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(model.elements[index].color)
                            } else {
                                Image(model.elements[index].image)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .frame(width: 150, height: 150)
                        .transformable(
                            scale: $model.elements[index].scale,
                            offset: $model.elements[index].offset,
                            rotation: $model.elements[index].rotation
                        )
                    }
                }
                .clipped()
                
                Divider()
                
                HStack(spacing: 20) {
                    ColorPicker("", selection: $model.backgroundColor)
                        .labelsHidden()
                    
                    Button("Photos") {
                        model.addElephantPhoto()
                    }
                    
                    Button("Frames") {
                        alertMessage = "Frames feature tapped!"
                        showingFeatureAlert = true
                    }
                    
                    Button("Text") {
                        alertMessage = "Text feature tapped!"
                        showingFeatureAlert = true
                    }
                    
                    Button("Stickers") {
                        model.addSticker()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGray6))
            }
            .navigationTitle("Photo Collage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        model.clearCollage()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        alertMessage = "Collage saved!"
                        showingFeatureAlert = true
                    }
                    .font(.headline)
                }
            }
            .alert(isPresented: $showingFeatureAlert) {
                Alert(title: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
