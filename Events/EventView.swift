import SwiftUI

/// A detailed view of an event to show all important information
struct EventView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// The event model
    /// This is a observed object to react to changes and update the UI
    @ObservedObject var event: Event
    /// Toggle this to edit the event
    @State var editEvent: Bool = false
    
    var body: some View {
        VStack {
            Form {
                
                Section { 
                    VStack {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            
                            Text("\(self.event.date.toString(dateFormat: "MM/dd/YYYY"))")
                                .bold()
                            
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section { 
                    Text("\(self.event.eventDescription)")
                    Text("Location: \(self.event.location)")
                }
            }
        }
        .navigationTitle(Text("\(self.event.eventDescription)"))
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.editEvent.toggle()
                }, label: {
                    Text("Edit")
                })
            }
        })
        .sheet(isPresented: self.$editEvent, content: {
            NavigationView(content: {
                CreateEvent(event: self.event)
                    .environment(\.managedObjectContext, self.viewContext)
            })
        })
    }
}
