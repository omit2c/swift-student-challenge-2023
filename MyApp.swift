import SwiftUI


/// The starting point of the Team Manager
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack { 
                ContentView()
                    .environment(\.managedObjectContext, Persistence.shared.container.viewContext)
            }
        }
    }
}
