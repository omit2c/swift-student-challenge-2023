import SwiftUI

class ExampleCreation {
    static let shared: ExampleCreation = ExampleCreation()
    
    let context = Persistence.shared.container.viewContext
    
    func createExampleData() {
        let team = Team(context: self.context)
        team.identifier = UUID()
        team.teamName = "Developer team"
        team.teamIcon = "soccerball"
        team.teamCoach = "Timo Eichelmann"
        team.teamColor = "#AFADCA"
        
        let changesArray = ["100" : "Start", "10" : "Coach payment", "-25" : "A new ball"]
        var changesObjects: [CashChanges] = []
        
        for change in changesArray {
            let changeObject = CashChanges(context: self.context)
            changeObject.identifier = UUID()
            changeObject.changeDescription = change.value
            changeObject.amount = Double(change.key) ?? 0.0
            changeObject.date = Date.parse(Date.randomBetween(start: "21.03.2023", end: "30.06.2023", format: "dd.MM.yyyy"), format: "dd.MM.yyyy")
            
            changesObjects.append(changeObject)
        }
        
        let cashRegister = CashRegister(context: self.context)
        cashRegister.identifier = UUID()
        cashRegister.cash = 85.0
        cashRegister.addChange(values: NSSet(array: changesObjects))
        
        for change in changesObjects {
            change.register = cashRegister
        }
        
        team.register = cashRegister
        cashRegister .team = team
        
        let eventsArrayTraining = ["Developer Team vs. Designer Team" : "Apple Soccer Field", "Designer Team vs. Developer Team" : "Apple Soccer Field", "Developer Team vs. Marketing Team" : "Apple Soccer Field", "Marketing Team vs. Developer Team" : "Apple Soccer Field"]
        
        for eventA in eventsArrayTraining {
            let event = Event(context: self.context)
            event.identifier = UUID()
            event.date = Date.parse(Date.randomBetween(start: "21.03.2023", end: "30.06.2023", format: "dd.MM.yyyy"), format: "dd.MM.yyyy")
            event.eventDescription = eventA.key
            event.location = eventA.value
            
            event.team = team
            team.addEvent(values: NSSet(array: [event]))
        }
        
        for _ in 0..<10 {
            let event = Event(context: self.context)
            event.identifier = UUID()
            event.date = Date.parse(Date.randomBetween(start: "21.03.2023", end: "30.06.2023", format: "dd.MM.yyyy"), format: "dd.MM.yyyy")
            event.eventDescription = "Training"
            event.location = "Apple Soccer Field"
            
            event.team = team
            team.addEvent(values: NSSet(array: [event]))
        }
        
        let persons = self.createPersons(team: team)
        team.addMember(values: NSSet(array: persons))
    }
    
    private func createPersons(team: Team) -> [Person] {
        
        let p1 = Person(context: context)
        p1.identifier = UUID()
        p1.birthdate = Date()
        p1.category = 0
        p1.name = "George"
        p1.phoneNumber = "1234567891011"
        p1.picture = UIImage(named: "memoji1")!.pngData()
        p1.position = "Defence"
        p1.addMTeam(values: NSSet(array: [team]))
        
        let p2 = Person(context: context)
        p2.identifier = UUID()
        p2.birthdate = Date()
        p2.category = 0
        p2.name = "Micheal"
        p2.phoneNumber = "1234567891011"
        p2.picture = UIImage(named: "memoji2")!.pngData()
        p2.position = "Attack"
        p2.addMTeam(values: NSSet(array: [team]))
        
        let p3 = Person(context: context)
        p3.identifier = UUID()
        p3.birthdate = Date()
        p3.category = 0
        p3.name = "Lisa"
        p3.phoneNumber = "1234567891011"
        p3.picture = UIImage(named: "memoji3")!.pngData()
        p3.position = "Goalkeeper"
        p3.addMTeam(values: NSSet(array: [team]))
        
        let p4 = Person(context: context)
        p4.identifier = UUID()
        p4.birthdate = Date()
        p4.category = 0
        p4.name = "Sara"
        p4.phoneNumber = "1234567891011"
        p4.picture = UIImage(named: "memoji4")!.pngData()
        p4.position = "Midfield"
        
        let p5 = Person(context: context)
        p5.identifier = UUID()
        p5.birthdate = Date()
        p5.category = 2
        p5.name = "Anna"
        p5.phoneNumber = "1234567891011"
        p5.picture = UIImage(named: "memoji5")!.pngData()
        p5.position = ""
        p5.addMTeam(values: NSSet(array: [team]))
        
        let p6 = Person(context: context)
        p6.identifier = UUID()
        p6.birthdate = Date()
        p6.category = 1
        p6.name = "Timo"
        p6.phoneNumber = "1234567891011"
        p6.picture = UIImage(named: "memoji6")!.pngData()
        p6.position = "Coach"
        p6.addMTeam(values: NSSet(array: [team]))
        
        let p7 = Person(context: context)
        p7.identifier = UUID()
        p7.birthdate = Date()
        p7.category = 3
        p7.name = "Rita"
        p7.phoneNumber = "1234567891011"
        p7.picture = UIImage(named: "memoji7")!.pngData()
        p7.position = ""
        p7.addMTeam(values: NSSet(array: [team]))
        
        return []
    }
}
