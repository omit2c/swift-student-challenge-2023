import SwiftUI

/// A view to select players and the add them to the team
struct SelectPlayerView: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// Dismiss this view with the environment variable as this view will always be displayed as a sheet
    @Environment(\.dismiss) var dismiss
    /// A Core Data fetch request to get all existing players
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Person.name, ascending: true)
    ], animation: .default)
    private var players: FetchedResults<Person>
    /// The team object as a observed object to react to changes within the model
    @ObservedObject var team: Team
    /// The body part of the view
    var body: some View {
        VStack {
            Form {
                /// Using a foreach loop to display all players
                /// The players will be filtered and only those are shown which aren't in the current team
                /// The filtering avoids double adding of players to the same team
                ForEach(Array(self.players).filter({ !$0.teams.contains(self.team) }), id: \.self) { player in
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
                        
                        Button(action: {
                            self.team.addMember(values: NSSet(array: [player]))
                            player.addMTeam(values: NSSet(array: [self.team]))
                            
                            self.save()
                            self.dismiss()
                        }, label: {
                            Rectangle()
                                .fill(Color.accentColor.opacity(0.3))
                                .cornerRadius(10)
                                .frame(width: 45, height: 45, alignment: .center)
                                .overlay {
                                    Text("Add")
                                        .font(.system(size: 12))
                                        .foregroundColor(.accentColor)
                                        .bold()
                                }
                                .padding(.top, -10)
                        })
                    }
                }
            }
        }
        .navigationTitle(Text("Select new member"))
    }
    /// A badge determinding which role a person can have
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
    /// Save the current viewContext to save all changes to the database
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            print("\(error)")
        }
    }
}
