import SwiftUI

/// This view represents the foundamental tabbar that is used to navigate within the app
/// The view has three different screens:
/// 1. The Player View, where all created players of your teams are listed for a better overview
/// 2. The teams overview that is used to display all created teams you have to manage
/// 3. The events overview, where all events for all teams are listed to keep an overview of all your upcoming events (e.g. trainings and matches) 
struct ContentView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// Start the app by launching the teams overview
    @State var selectedTab: Int = 1
    /// Stored variable to keep track of the current introduction page
    @AppStorage("currentPageIntro") var currentPage: Int = 0
    /// The body part of the view
    var body: some View {
        VStack {
            if self.currentPage > 3 {
                Group {
                    /// Tabbar created multiple tabs
                    TabView(selection: self.$selectedTab) {
                        /// First tab for the players
                        NavigationView {
                            PlayerView()
                                .environment(\.managedObjectContext, self.viewContext)
                                .navigationBarTitle(Text("Your players"))
                        }
                        .tabItem { 
                            VStack {
                                Image(systemName: "person.2")
                                Text("Players")
                            }
                        }
                        .tag(0)
                        
                        /// Second tab for the team
                        NavigationView {
                            HomeView()
                                .environment(\.managedObjectContext, self.viewContext)
                                .navigationBarTitle("Your teams")
                        }
                        .tabItem { 
                            VStack {
                                Image(systemName: "figure.run.square.stack")
                                Text("Teams")
                            }
                        }
                        .tag(1)
                        // Third tab for the events
                        NavigationView(content: {
                            EventOverView()
                                .environment(\.managedObjectContext, self.viewContext)
                                .navigationTitle(Text("Events"))
                        })
                        .tabItem { 
                            VStack {
                                Image(systemName: "calendar")
                                Text("Events")
                            }
                        }
                        .tag(2)
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else {
                Intro(currentPage: self.$currentPage)
            }
        }
    }
}
