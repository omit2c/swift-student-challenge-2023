import SwiftUI

/// The pverview of a player to display all important information
struct PlayerOverView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// The player / person object 
    /// This is a observed object to directly react to changes and update the UI
    @ObservedObject var player: Person
    /// Edit the person
    @State var editPerson: Bool = false
    
    var body: some View {
        VStack {
            Form {
                VStack { 
                    if self.player.picture != nil {
                        Image(uiImage: UIImage(data: self.player.picture!)!)
                            .frame(height: 200, alignment: .center)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .cornerRadius(10)
                    }
                }
                
                Section {
                    Text("Name: \(self.player.name)")
                    Text("Date of birth: \(self.player.birthdate.toString(dateFormat: "MM/dd/yyyy"))")
                }
                
                Section { 
                    HStack {
                        switch PlayerCategories(rawValue: player.category) {
                        case .coach:
                            CategoryBadge(caseName: "Coach", color: .red)
                        case .player:
                            CategoryBadge(caseName: "Player", color: .blue)
                        case .medical:
                            CategoryBadge(caseName: "Medical", color: .green)
                        case .supervisor:
                            CategoryBadge(caseName: "Supervisor", color: .teal)
                        case .other:
                            CategoryBadge(caseName: "Other", color: .gray)
                        default:
                            CategoryBadge(caseName: "Other", color: .gray)
                        }
                        
                        Spacer()
                    }
                } header: { 
                    Text("Role")
                }

                
                Section { 
                    ForEach(Array(self.player.teams as? Set<Team> ?? []), id: \.self) { team in
                        NavigationLink { 
                            TeamOverView(team: team)
                                .environment(\.managedObjectContext, self.viewContext)
                        } label: { 
                            HStack {
                                Image(systemName: team.teamIcon)
                                Text("\(team.teamName)")
                            }
                        }
                    }
                } header: { 
                    HStack {
                        Text("Teams")
                        
                        Spacer()
                        
                        Text("\(self.player.teams.count)")
                    }
                }
            }
        }
        .navigationBarTitle(Text("\(player.name)"))
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.editPerson.toggle()
                }, label: {
                    Text("Edit")
                })
            }
        })
        .sheet(isPresented: self.$editPerson, content: {
            NavigationView {
                CreatePerson(person: self.player)
                    .environment(\.managedObjectContext, self.viewContext)
            }
        })
    }
    
    /// A badge to determine which role a person has
    private func CategoryBadge(caseName: String, color: Color) -> some View {
        Rectangle()
            .fill(color.opacity(0.3))
            .cornerRadius(10)
            .frame(width: 100, height: 25, alignment: .center)
            .overlay {
                Text(caseName)
                    .font(.system(size: 12))
                    .foregroundColor(color)
                    .bold()
            }
            .padding(.top, -10)
    }

}
