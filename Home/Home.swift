import SwiftUI

struct HomeView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// A Core Data fetch request to get all teams
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Team.teamName, ascending: true)
    ], animation: .default)
    private var teams: FetchedResults<Team>
    /// Create a new team when true
    @State var createNewTeam: Bool = false
    /// Confirm the deletion of a team
    @State var deleteTeam: Bool = false
    ///A search term to search for teams
    @State var searchTerm: String = ""
    
    var body: some View {
        VStack {
            if self.teams.isEmpty {
                Text("Seems like you don't have any teams yet.\nStart with creating one")
                    .bold()
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation { 
                        self.createNewTeam.toggle()
                    }
                }, label: {
                    Text("Create your first team")
                        .bold()
                        .foregroundColor(.white)
                })
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            } else {
                List {
                    if !self.teams.isEmpty {
                        ForEach(self.teams, id: \.self.identifier) { team in
                            NavigationLink(destination: { 
                                TeamOverView(team: team)
                                    .environment(\.managedObjectContext, self.viewContext)
                            }, label: { 
                                HStack {
                                    Image(systemName: team.teamIcon)
                                        .foregroundColor(Color(hex: team.teamColor))
                                    Text(team.teamName)
                                        .foregroundColor(Color(hex: team.teamColor))
                                    Spacer()
                                    Text("\(team.members.count) members")
                                        .foregroundColor(.secondary)
                                }
                            })
                            .contextMenu(menuItems: {
                                Button(role: .destructive, action: {
                                    withAnimation { 
                                        self.deleteTeam.toggle()
                                        self.save()
                                    }
                                }, label: {
                                    Image(systemName: "trash")
                                    Text("Delete")
                                })
                            })
                            .alert(isPresented: self.$deleteTeam, content: {
                                Alert(title: Text("Delete team?"), message: Text("Do you really want to delete the team \(team.teamName)?"), primaryButton: .destructive(Text("Delete"), action: { 
                                    DispatchQueue.main.async {
                                        self.viewContext.delete(team)
                                    }
                                }), secondaryButton: .cancel())
                            })
                        }
                    }
                }
                .searchable(text: self.$searchTerm, prompt: Text("Search for a team"))
                .onChange(of: self.searchTerm, perform: { value in
                    if value != "" {
                        self.teams.nsPredicate = NSPredicate(format: "teamName CONTAINS %@", value)
                    } else {
                        self.teams.nsPredicate = nil
                    }
                })
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.createNewTeam.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                })
            }
        })
        .sheet(isPresented: self.$createNewTeam, onDismiss: {}, content: {
            NavigationView(content: {
                CreateTeam()
                    .environment(\.managedObjectContext, self.viewContext)
            })
        })
    }
    
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            print("\(error)")
        }
    }
}

