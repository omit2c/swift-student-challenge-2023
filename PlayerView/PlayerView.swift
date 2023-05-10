import SwiftUI

struct PlayerView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// A Core Data fetch request to fetch all players in the store
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Person.name, ascending: true)
    ], animation: .default)
    private var players: FetchedResults<Person>
    /// A search term that is used to search for players by their names
    @State var searchTerm: String = ""
    /// A toggle to create a new person
    @State var createNewPerson: Bool = false
    /// A toggle to show an alert before deleting a person
    @State var deletePerson: Bool = false
    /// The person that should be deleted
    /// This is a extra variable due to unsure behavior of the player object in foreach loops
    @State var selectedPlayerToDelete: Person? = nil
    
    var body: some View {
        VStack {
            List { 
                Group {
                    ForEach(self.players, id: \.self.identifier) { player in
                        NavigationLink { 
                            PlayerOverView(player: player)
                                .environment(\.managedObjectContext, self.viewContext)
                        } label: { 
                            HStack {
                                if player.picture != nil {
                                    Image(uiImage: UIImage(data: player.picture!)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .cornerRadius(10)
                                } else {
                                    Rectangle()
                                        .foregroundColor(.secondary)
                                        .scaledToFill()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .cornerRadius(10)
                                        .overlay { 
                                            Image(systemName: "figure.soccer")
                                        }
                                }
                                
                                VStack {
                                    HStack {
                                        Text("\(player.name)")
                                        Spacer()
                                    }
                                    
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
                                }
                                .padding(.leading)
                            }
                            .contextMenu(menuItems: {
                                Button(role: .destructive, action: {
                                    self.selectedPlayerToDelete = player
                                    self.deletePerson.toggle()
                                }, label: {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    }
                                })
                            })
                            .alert(isPresented: self.$deletePerson, content: {
                                Alert(title: Text("Delete Player?"), message: Text("Are you sure, you want to delete \(self.selectedPlayerToDelete?.name ?? "the player")"), primaryButton: .destructive(Text("Delete"), action: { 
                                    DispatchQueue.main.async {
                                        if self.selectedPlayerToDelete != nil {
                                            self.viewContext.delete(self.selectedPlayerToDelete!)
                                        }
                                    }
                                    self.save()
                                }), secondaryButton: .cancel())
                            })
                        }
                    }
                }
            }
            .searchable(text: self.$searchTerm, prompt: Text("Search for a person"))
                .onChange(of: self.searchTerm, perform: { value in
                    if value != "" {
                        self.players.nsPredicate = NSPredicate(format: "name CONTAINS %@", value)
                    } else {
                        self.players.nsPredicate = nil
                    }
                })
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.createNewPerson.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                })
            }
        })
        .sheet(isPresented: self.$createNewPerson, content: {
            NavigationView(content: {
                CreatePerson()
                    .environment(\.managedObjectContext, self.viewContext)
            })
        })
    }
    
    /// Save the current viewContext to save all changes to the data base
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            print("\(error)")
        }
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
