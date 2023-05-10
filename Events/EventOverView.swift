import SwiftUI

/// An overview of all events
struct EventOverView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// Add a new event
    @State var addEvent: Bool = false
    /// A Core Data fetch request to get all events
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Event.date, ascending: true)
    ], animation: .default)
    private var events: FetchedResults<Event>
    /// A search term to search for events
    @State var searchTerm: String = ""
    /// Confirm the deletion of an event
    @State var deleteEvent: Bool = false
    
    var body: some View {
        VStack {
            List {
                Group {
                    ForEach(self.events, id: \.self) { event in
                        NavigationLink { 
                            EventView(event: event)
                                .environment(\.managedObjectContext, self.viewContext)
                        } label: { 
                            HStack {
                                Image(systemName: "calendar")
                                VStack {
                                    HStack {
                                        Text("\(event.eventDescription)")
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(event.date.toString(dateFormat: "MM/dd/YYYY"))")
                                            .foregroundColor(.secondary)
                                            .font(.system(size: 12))
                                        
                                        Spacer()
                                    }
                                }
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(role: .destructive) { 
                                        self.deleteEvent.toggle()
                                    } label: { 
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Delete")
                                        }
                                    }
                                }))
                                .alert(isPresented: self.$deleteEvent) { 
                                    Alert(title: Text("Delete event?"), message: Text("Do you want to delete \(event.eventDescription)?"), primaryButton: .destructive(Text("Delete"), action: { 
                                        DispatchQueue.main.async {
                                            self.viewContext.delete(event)
                                            self.save()
                                        }
                                    }), secondaryButton: .cancel())
                                }
                            }
                        }
                        .searchable(text: self.$searchTerm, prompt: Text("Search for events"))
                            .onChange(of: self.searchTerm, perform: { value in
                                if value != "" {
                                    self.events.nsPredicate = NSPredicate(format: "eventDescription CONTAINS %@", value)
                                } else {
                                    self.events.nsPredicate = nil
                                }
                            })
                    }
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.addEvent.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                })
            }
        })
        .sheet(isPresented: self.$addEvent, content: {
            NavigationView {
                CreateEvent()
                    .environment(\.managedObjectContext, self.viewContext)
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

struct EventOverView_Previews: PreviewProvider {
    static var previews: some View {
        EventOverView()
    }
}
