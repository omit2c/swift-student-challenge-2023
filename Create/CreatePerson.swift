import SwiftUI
import PhotosUI

// A view to create a new person
struct CreatePerson: View {
    /// The environment of the persistence container
    @Environment(\.managedObjectContext) var viewContext
    /// Dismiss the view as it will always be displayed as a sheet
    @Environment(\.dismiss) var dismiss
    /// A Core Data fetch request to get all teams
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Team.teamName, ascending: true)
    ], animation: .default)
    private var teams: FetchedResults<Team>
    /// Select a team for the new person
    @State var selectedTeam: Team? = nil
    /// The name for the new person
    @State var personName: String = ""
    /// The position for the new person (e.g. Defence)
    @State var personPosition: String = ""
    /// An image for the person for better recognition
    @State var personImage: Data? = nil
    /// The birthdate of the new person
    @State var personBirthday: Date = Date()
    /// A phone number to call the person
    @State var personPhoneNumber: String = ""
    /// Selection of selected photos from the photos picker
    /// Selection is limited to one image
    @State var selection: [PhotosPickerItem] = []
    /// Toggle the visibility of the image picker
    @State var showPhotosPicker: Bool = false
    /// The standard category for a new person
    @State var selectedCategory: Int = 4
    /// All available categories
    @State var availableCategories: [PlayerCategories] = [.player, .coach, .medical, .supervisor, .other]
    /// A person object that can be edited
    var person: Person? = nil
    
    var body: some View {
        VStack {
            Form {
                
                if self.personImage != nil {
                    PhotosPicker(selection: self.$selection, maxSelectionCount: 1, matching: .images) {
                        Image(uiImage: UIImage(data: self.personImage!)!)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200, alignment: .center)
                            .cornerRadius(10)
                            .foregroundColor(.clear)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                    }
                    .listRowInsets(EdgeInsets())
                } else {
                    PhotosPicker(selection: self.$selection, maxSelectionCount: 1, matching: .images) {
                        Rectangle()
                            .frame(height: 200, alignment: .center)
                            .cornerRadius(10)
                            .foregroundColor(.clear)
                            .overlay(alignment: .center) { 
                                Image(systemName: "person.crop.rectangle.badge.plus")
                                    .font(.system(size: 45))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                            .listRowInsets(EdgeInsets())
                     }
                }
                
                Section { 
                    TextField("Name", text: self.$personName)
                    DatePicker("Birthday", selection: self.$personBirthday, in: ...Date(), displayedComponents: .date)
                    TextField("Phone number", text: self.$personPhoneNumber)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Personal information")
                }
                
                Section { 
                    TextField("Position", text: self.$personPosition)
                    Picker(selection: self.$selectedCategory) { 
                        ForEach(self.availableCategories, id: \.self) { category in 
                            switch category {
                            case .coach:
                                Text("Coach")
                                    .tag(category.rawValue)
                            case .player:
                                Text("Player")
                                    .tag(category.rawValue)
                            case .medical:
                                Text("Medical")
                                    .tag(category.rawValue)
                            case .supervisor:
                                Text("Supervisor")
                                    .tag(category.rawValue)
                            case .other:
                                Text("Other")
                                    .tag(category.rawValue)
                            }
                        }
                    } label: { 
                        Text("Category")
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
                } header: {
                    Text("Team information")
                }
                
                Button(action: {
                    if !self.personName.isEmpty {
                        DispatchQueue.main.async {
                            if self.person != nil {
                                self.person!.category = self.selectedCategory
                                self.person!.name = self.personName
                                self.person!.picture = self.personImage
                                self.person!.position = self.personPosition
                                self.person!.birthdate = self.personBirthday
                                self.person!.phoneNumber = self.personPhoneNumber
                                
                                if self.selectedTeam != nil {
                                    self.selectedTeam!.addMember(values: NSSet(array: [self.person!]))
                                    self.person!.addMTeam(values: NSSet(array: [self.selectedTeam!]))
                                }
                            } else {
                                let newPerson = Person(context: self.viewContext)
                                newPerson.identifier = UUID()
                                print(self.selectedCategory)
                                newPerson.category = self.selectedCategory
                                newPerson.name = self.personName
                                newPerson.picture = self.personImage
                                newPerson.position = self.personPosition
                                newPerson.birthdate = self.personBirthday
                                newPerson.phoneNumber = self.personPhoneNumber
                                
                                if self.selectedTeam != nil {
                                    self.selectedTeam!.addMember(values: NSSet(array: [newPerson]))
                                    newPerson.addMTeam(values: NSSet(array: [self.selectedTeam!]))
                                    print(self.selectedTeam!)
                                    print(newPerson)
                                }
                            }
                            
                            self.save()
                            
                            self.dismiss()
                        }
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text(self.person != nil ? "Save" : "Create player")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                })
                .disabled(self.personName.isEmpty)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .listRowInsets(EdgeInsets())
            }
        }
        .onChange(of: self.selection) { newValue in
            for value in newValue {
                let _ = self.loadTransferable(from: value)
            }
        }
        .onAppear(perform: {
            if self.person != nil {
                self.personName = self.person!.name
                self.personPosition = self.person!.position
                self.selectedTeam = Array(self.person!.teams as? Set<Team> ?? []).first
                self.personImage = self.person!.picture
                self.personBirthday = self.person!.birthdate
                self.personPhoneNumber = self.person!.phoneNumber
                self.selectedCategory = self.person!.category
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
    
    /// Load the image data from the photospicker's selection
    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == imageSelection else { return }
                switch result {
                case .success(let data?):
                    self.personImage = data
                    // Handle the success case with the image.
                case .success(nil):
                    break
                    // Handle the success case with an empty value.
                case .failure(_):
                    break
                    // Handle the failure case with the provided error.
                }
            }
        }
    }
    
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            print("\(error)")
        }
    }
}

struct CreatePerson_Previews: PreviewProvider {
    static var previews: some View {
        CreatePerson()
    }
}

enum PlayerCategories: Int {
    case player = 0
    case coach = 1
    case medical = 2
    case supervisor = 3
    case other = 4
}
