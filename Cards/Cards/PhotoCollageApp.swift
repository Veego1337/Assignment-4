import SwiftUI

@main
struct PhotoCollageApp: App {
    @StateObject private var model = CollageModel()
    
    var body: some Scene {
        WindowGroup {
            CollageView()
                .environmentObject(model)
        }
    }
}
