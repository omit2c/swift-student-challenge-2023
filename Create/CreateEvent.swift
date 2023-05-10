import SwiftUI

// Create a new event for a team or event no team
struct CreateEvent: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// Dismiss the view as this will always be displayed as a sheet
    @Environment(\.dismiss) var dismiss
    /// A Core Data fetch request to get all teams
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Team.teamName, ascending: true)
    ], animation: .default)
    private var teams: FetchedResults<Team>
    /// A description for the event
    @State var newDescription: String = ""
    /// A date when the event will happen
    @State var newDate: Date = Date()
    /// A location of the event
    @State var location: String = ""
    /// The selected team to store the event for
    @State var selectedTeam: Team? = nil
    /// A event that can be edited
    var event: Event? = nil
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Description", text: self.$newDescription)
                    TextField("Location", text: self.$location)
                    
                    DatePicker(selection: self.$newDate, displayedComponents: [.date, .hourAndMinute]) { 
                        Text("Date")
                    }
                    
                    Picker(selection: self.$selectedTeam) { 
                        HStack {
                            Image(systemName: "slash.circle")
                            Text("No team")
                        }
                        .tag(nil as Team?)
                        
                        ForEach(self.teams, id: \.self.id) { team in
                            HStack {
                                Image(systemName: team.teamIcon)
                                Text("\(team.teamName)")
                            }
                            .tag(Optional(team))
                        }
                    } label: { 
                        Text("Team")
                    }
                }
                
                Section {
                    Button(action: {
                        if self.event != nil {
                            self.event!.date = self.newDate
                            self.event!.eventDescription = self.newDescription
                            self.event!.location = self.location
                            
                            self.event!.team?.removeEvent(values: NSSet(array: [self.event!]))
                            
                            self.event!.team = nil
                            if self.selectedTeam != nil {
                                self.selectedTeam!.addEvent(values: NSSet(array: [self.event!]))
                                self.event!.team = self.selectedTeam!
                            }
                        } else {
                            let newEvent = Event(context: self.viewContext)
                            newEvent.identifier = UUID()
                            newEvent.date = self.newDate
                            newEvent.eventDescription = self.newDescription
                            newEvent.location = self.location
                            
                            if self.selectedTeam != nil {
                                self.selectedTeam!.addEvent(values: NSSet(array: [newEvent]))
                                newEvent.team = self.selectedTeam!
                            }
                        }
                        
                        self.save()
                        
                        self.dismiss()
                    }, label: {
                        HStack {
                            Spacer()
                            Text(self.event != nil ? "Save event" : "Add event")
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                    })
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .listRowInsets(EdgeInsets())
                }
            }
        }
        .navigationTitle(Text(self.event != nil ? "Edit event" : "Create event"))
        .onAppear(perform: {
            if self.event != nil {
                self.newDescription = self.event!.eventDescription
                self.location = self.event!.location
                self.newDate = self.event!.date
                self.selectedTeam = self.event!.team
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
    /// Save the current viewContext to save all changes to the database
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            print("\(error)")
        }
    }
}
