import SwiftUI

/// The overview of the cash register of a team
struct CashRegisterOverView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// The cash register object
    /// This is a observed object to react to changes and to update the UI
    @ObservedObject var cashRegister: CashRegister
    /// A bool to add a change and open the sheet
    @State var addChange: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("$\(self.cashRegister.cash, specifier: "%.2f")")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                
                Spacer()
            }
            
            Form {
                ForEach(Array(self.cashRegister.changes as? Set<CashChanges> ?? []), id: \.self) { change in
                    HStack {
                        if change.amount <= 0 {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)
                        }
                        VStack {
                            HStack {
                                Text("\(change.changeDescription)")
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("\(change.date.toString(dateFormat: "MM/dd/yyyy"))")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 12))
                                Spacer()
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(change.amount, specifier: "%.2f")")
                    }
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.addChange.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                })
            }
        })
        .sheet(isPresented: self.$addChange, content: {
            NavigationView(content: {
                AddChange(register: self.cashRegister)
                    .environment(\.managedObjectContext, self.viewContext)
            })
        })
    }
}
