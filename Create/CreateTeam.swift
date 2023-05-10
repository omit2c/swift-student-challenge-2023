import SwiftUI

/// The view to create a new team
struct CreateTeam: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// Dismiss the view as it will always be displayed as a sheet
    @Environment(\.dismiss) var dismiss
    /// The name of the new team
    @State var teamName: String = ""
    /// The color of the new team
    @State var teamColor: Color = .blue
    /// All available icons to choose
    @State var availableIcons: [String : String] = ["Football" : "football", "Soccer" : "soccerball"]
    /// The selected team icon
    @State var teamIcon: String = "football"
    /// The team Coach
    @State var teamCoach: String = ""
    /// The team that can be edited
    var team: Team? = nil
    
    var body: some View {
        VStack {
            Form {
                Section { 
                    TextField("Team name", text: self.$teamName)
                }
                
                Section { 
                    TextField("Team coach", text: self.$teamCoach)
                }
                
                Section { 
                    ColorPicker("Team color", selection: self.$teamColor, supportsOpacity: false)
                    
                    
                    Picker("Team Icon", selection: self.$teamIcon) { 
                        ForEach(self.availableIcons.sorted(by: >), id: \.value) { name, icon in
                            HStack {
                                Text(name)
                                Image(systemName: icon)
                            }
                        }
                    }
                }
                
                Button(action: {
                    if !self.teamName.isEmpty {
                        if self.team != nil {
                            self.team!.teamName = self.teamName
                            self.team!.teamCoach = self.teamCoach
                            self.team!.teamColor = self.teamColor.toHex() ?? "#ef56ef"
                            self.team!.teamIcon = self.teamIcon
                        } else {
                            let newTeam = Team(context: self.viewContext)
                            newTeam.identifier = UUID()
                            newTeam.teamName = self.teamName
                            newTeam.teamCoach = self.teamCoach
                            newTeam.teamColor = self.teamColor.toHex() ?? "#ef56ef"
                            newTeam.teamIcon = self.teamIcon
                            newTeam.members = []
                            
                            let newRegister = CashRegister(context: self.viewContext)
                            newRegister.identifier = UUID()
                            newRegister.changes = []
                            newRegister.cash = 0.0
                            newRegister.team = newTeam
                            
                            newTeam.register = newRegister
                        }
                        
                        self.save()
                        
                        self.dismiss()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text(self.team != nil ? "Save team" : "Create team")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                })
                .disabled(self.teamName.isEmpty)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .listRowInsets(EdgeInsets())
            }
         }
        .navigationTitle(Text(self.team != nil ? "Save team" : "Create a new team"))
        .onAppear(perform: {
            if self.team != nil {
                self.teamName = self.team!.teamName
                self.teamIcon = self.team!.teamIcon
                self.teamCoach = self.team!.teamCoach
                self.teamColor = Color(hex: self.team!.teamColor)
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
        })
    }
    /// Save the current viewContext to save the changes to the database
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            print("\(error)")
        }
    }
}
