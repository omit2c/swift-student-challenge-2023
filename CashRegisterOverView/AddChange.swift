import SwiftUI

/// The view that allows to add a change to the cash of the team
struct AddChange: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// Dismiss the view as this will always be displayed as a sheet
    @Environment(\.dismiss) var dismiss
    /// The register where the change should be registered
    /// This is a observed object to react to changes and update the UI 
    @ObservedObject var register: CashRegister
    /// The amount of money that should be added or removed
    @State var newAmount: String = ""
    /// A description why the change happened
    @State var newDescription: String = ""
    /// A date of the transaction
    @State var newDate: Date = Date()
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Enter amount of change (e.g. -10$ or 12.54$)", text: self.$newAmount)
                        .keyboardType(.numberPad)
                    TextField("Description", text: self.$newDescription)
                    
                    DatePicker(selection: self.$newDate, displayedComponents: .date) { 
                        Text("Date")
                    }
                }
                
                Section {
                    Button(action: {
                        if !self.newAmount.isEmpty && !self.newDescription.isEmpty {
                            /// Create a new CashChanges object and add it to the cash register
                            let newChange = CashChanges(context: self.viewContext)
                            newChange.identifier = UUID()
                            newChange.amount = Double(self.newAmount) ?? 0.0
                            newChange.changeDescription = self.newDescription
                            newChange.date = self.newDate
                            
                            self.register.cash += newChange.amount
                            
                            self.register.addChange(values: NSSet(array: [newChange]))
                            
                            self.save()
                            
                            self.dismiss()
                        }
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Add change")
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
                .disabled(self.newAmount.isEmpty || self.newDescription.isEmpty)
            }
        }
        .navigationTitle(Text("Add change"))
    }
    
    // Save the current view context to save all changes to the database
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            print("\(error)")
        }
    }
}
