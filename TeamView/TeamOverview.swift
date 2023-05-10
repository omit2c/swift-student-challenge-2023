import SwiftUI

/// The overview for a team
/// This view uses a team model to display all stored and important information about a created team.
/// Within this view you can manage your players that belong to the team
struct TeamOverView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// The team model as a parameter for this view
    /// It is a observed object to directly react to changes
    @ObservedObject var team: Team
    /// Calls a alert when a player should be removed from the team
    @State var removePlayer: Bool = false
    /// Toggles the selector to add a new player
    @State var addPlayer: Bool = false
    /// Edit the team 
    @State var editTeam: Bool = false
    /// The body part of the view
    var body: some View {
        VStack {
            Form {
                Rectangle()
                    .frame(height: 200, alignment: .center)
                    .cornerRadius(10)
                    .foregroundColor(Color(hex: self.team.teamColor))
                    .overlay(alignment: .center) { 
                        Image(systemName: self.team.teamIcon)
                            .font(.system(size: 45))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color(hex: self.team.teamColor))
                
                Section { 
                    NavigationLink { 
                        CashRegisterOverView(cashRegister: self.team.register!)
                            .environment(\.managedObjectContext, self.viewContext)
                    } label: { 
                        HStack {
                            Text("Team cash")
                            
                            Spacer()
                            
                            Text("$\(self.team.register?.cash ?? 0.0, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if self.team.teamCoach != "" {
                    Section {
                        Text("Team Coach: \(self.team.teamCoach)")
                    }
                }
                
                Section { 
                    if self.team.events.count == 0 {
                        Text("No events for this team")
                    } else {
                        ForEach(Array(self.team.events as? Set<Event> ?? []), id: \.self) { event in 
                            NavigationLink { 
                                EventView(event: event)
                                    .environment(\.managedObjectContext, self.viewContext)
                            } label: { 
                                VStack {
                                    HStack {
                                        Image(systemName: "calendar")
                                        Text("\(event.eventDescription)")
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Image(systemName: "clock")
                                        Text("\(event.date.toString(dateFormat: "MM/dd/yyyy"))")
                                        
                                        Spacer()
                                    }
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                }
                            }
                        }
                    }
                } header: { 
                    Text("Events")
                }
                
                Section { 
                    if self.team.members.count == 0 {
                        Text("No members in this team")
                        
                        Button(action: {
                            self.addPlayer.toggle()
                        }, label: {
                            Text("Add new member")
                        })
                    } else {
                        ForEach(Array(self.team.members as? Set<Person> ?? []), id: \.self) { member in 
                            NavigationLink { 
                                PlayerOverView(player: member)
                                    .environment(\.managedObjectContext, self.viewContext)
                            } label: { 
                                Text("\(member.name)")
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive, action: {
                                    self.removePlayer.toggle()
                                }, label: {
                                    Image(systemName: "trash")
                                })
                            }
                            .alert(isPresented: self.$removePlayer, content: {
                                Alert(title: Text("Remove player?"), message: Text("Do you want to remove \(member.name) from the team?"), primaryButton: .destructive(Text("Remove"), action: { 
                                    self.team.removeMember(values: NSSet(array: [member]))
                                    
                                    self.save()
                                }), secondaryButton: .cancel())
                            })
                        }
                        
                        Button(action: {
                            self.addPlayer.toggle()
                        }, label: {
                            Text("Add new member")
                        })
                    }
                } header: { 
                    HStack {
                        Text("Members")
                        
                        Spacer()
                        
                        Text("\(self.team.members.count)")
                    }
                }
            }
            .sheet(isPresented: self.$addPlayer, content: {
                NavigationView {
                    SelectPlayerView(team: self.team)
                        .environment(\.managedObjectContext, self.viewContext)
                }
            })
        }
        .navigationTitle(Text(self.team.teamName))
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.editTeam.toggle()
                }, label: {
                    Text("Edit")
                })
            }
        })
        .sheet(isPresented: self.$editTeam, content: {
            NavigationView {
                CreateTeam(team: self.team)
                    .environment(\.managedObjectContext, self.viewContext)
            }
        })
    }
    
    /// Save the current viewContext to write all changes to the database
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            print("\(error)")
        }
    }
}
