import SwiftUI

/// Introduction views to guide the user
struct Intro: View {
    /// The current page, linked with the ContentView
    @Binding var currentPage: Int
    /// The amount of pages
    @State var totalPages = 3
    
    var body: some View {
        ZStack {
            Color(hex: "#6C63FF")
                .ignoresSafeArea(.all)
            
            VStack {
                if self.currentPage == 0 {
                    FirstPage
                } else if self.currentPage == 1 {
                    SecondPage
                } else if self.currentPage == 2 {
                    ThirdPage
                } else if self.currentPage == 3 {
                    FourthPage
                }
            }
            .overlay(
                VStack {
                    Spacer()
                        .allowsHitTesting(false)
                    
                    Button(action:{
                        withAnimation { 
                            if (currentPage <= totalPages && currentPage != 3) {
                                currentPage += 1
                            } else {
                                currentPage += 1
                                
                                ExampleCreation.shared.createExampleData()
                            }
                        }
                    })
                    {
                        if (currentPage != 4) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(
                                    ZStack {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 4)
                                        
                                        Circle()
                                            .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                            .stroke(Color.black, lineWidth: 5)
                                            .rotationEffect(.init(degrees: -90))
                                    })
                        }
                    }
                    .padding(.bottom, 10)
                })
        }
    }
    
    /// The first page that is shown
    var FirstPage: some View {
        VStack {
            HStack {
                Text("Welcome to TeamManager")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 20)
            
            HStack {
                Text("Manage your friends and team members to win the next season and to keep track of all your teams and events.")
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 20)
            
            Spacer()
            
            Image("team")
                .resizable()
                .scaledToFit()
            
            Spacer()
        }
    }
    /// The second page that is shown
    var SecondPage: some View {
        VStack {
            HStack {
                Text("Manage your players")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 20)
            
            HStack {
                Text("Show all players, coaches, medicals and other persons from all your teams.")
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 20)
            
            Image("Manage_Players")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 2)
            
            Spacer()
        }
    }
    /// The third page that is shown
    var ThirdPage: some View {
        VStack {
            HStack {
                Text("Manage your teams")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 20)
            
            HStack {
                Text("Show all teams and manage events, players and your team cash register.")
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 20)
            
            Image("Manage_Cash")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 2)
            
            Spacer()
        }
    }
    /// The fourth page that is shown
    var FourthPage: some View {
        VStack {
            HStack {
                Text("Start with an example")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 20)
            
            HStack {
                Text("To discover all features of this project you will start with some created players, a team and some cash. I also added some events for you.")
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 20)
            
            Image("team")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 2)
            
            Spacer()
        }
    }
}
