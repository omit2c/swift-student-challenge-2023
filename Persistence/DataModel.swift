import SwiftUI
import CoreData

/// The data model of a team
@objc(Team)
class Team: NSManagedObject {
    @NSManaged var identifier: UUID
    @NSManaged var teamName: String
    @NSManaged var teamColor: String
    @NSManaged var teamIcon: String
    @NSManaged var teamCoach: String
    @NSManaged var members : NSSet
    @NSManaged var register: CashRegister?
    @NSManaged var events: NSSet
}

extension Team: Identifiable {
    var id : UUID {
        identifier
    }
    /// Add a member to the team    
    func addMember(values: NSSet) {
        var items = self.mutableSetValue(forKey: "members")
        for value in values {
            items.add(value)
        }
    }
    /// Remove a member from the team
    func removeMember(values: NSSet) {
        var items = self.mutableSetValue(forKey: "members")
        for value in values {
            items.remove(value)
        }
    }
    /// Add an event to the team
    func addEvent(values: NSSet) {
        var items = self.mutableSetValue(forKey: "events")
        for value in values {
            items.add(value)
        }
    }
    /// Remove an event from the team
    func removeEvent(values: NSSet) {
        var items = self.mutableSetValue(forKey: "events")
        for value in values {
            items.remove(value)
        }
    }
}

/// The event object
@objc(Event)
class Event: NSManagedObject {
    @NSManaged var identifier: UUID
    @NSManaged var eventDescription: String
    @NSManaged var date: Date
    @NSManaged var location: String
    @NSManaged var team: Team?
    @NSManaged var resultOwnTeam: Int
    @NSManaged var resultOpponent: Int
}

extension Event: Identifiable {
    var id : UUID {
        identifier
    }
}

/// The person object
@objc(Person)
class Person: NSManagedObject {
    @NSManaged var identifier: UUID
    @NSManaged var name: String
    @NSManaged var teams : NSSet
    @NSManaged var category: Int
    @NSManaged var picture: Data?
    @NSManaged var position: String
    @NSManaged var birthdate: Date
    @NSManaged var phoneNumber: String
}

extension Person: Identifiable {
    var id : UUID {
        identifier
    }
    /// Add a team to the person
    func addMTeam(values: NSSet) {
        var items = self.mutableSetValue(forKey: "teams")
        for value in values {
            items.add(value)
        }
    }
    
    /// Remove a team from the person
    func removeTeam(values: NSSet) {
        var items = self.mutableSetValue(forKey: "teams")
        for value in values {
            items.remove(value)
        }
    }
}

/// The cash register for a team
@objc(CashRegister)
class CashRegister: NSManagedObject {
    @NSManaged var identifier: UUID
    @NSManaged var cash: Double
    @NSManaged var changes: NSSet
    @NSManaged var team: Team?
}

extension CashRegister: Identifiable {
    var id : UUID {
        identifier
    }
    /// Add changes to a register
    func addChange(values: NSSet) {
        var items = self.mutableSetValue(forKey: "changes")
        for value in values {
            items.add(value)
        }
    }
    /// Remove a change from the register
    func removeChange(values: NSSet) {
        var items = self.mutableSetValue(forKey: "changes")
        for value in values {
            items.remove(value)
        }
    }
}

/// The change object
@objc(CashChanges)
class CashChanges: NSManagedObject {
    @NSManaged var identifier: UUID
    @NSManaged var date: Date
    @NSManaged var amount: Double
    @NSManaged var changeDescription: String
    @NSManaged var register: CashRegister?
}
