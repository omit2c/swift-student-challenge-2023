import SwiftUI
import CoreData

extension Persistence {
    /// Create the team model with all attributes and relations
     static func createTeamModel() -> NSManagedObjectModel {
         let teamEntity = NSEntityDescription()
         teamEntity.name = "Team"
         teamEntity.managedObjectClassName = "Team"
        
         let teamNameAttribute = NSAttributeDescription()
         teamNameAttribute.name = "teamName"
         teamNameAttribute.type = .string
         teamEntity.properties.append(teamNameAttribute)
         
         let teamCoachAttribute = NSAttributeDescription()
         teamCoachAttribute.name = "teamCoach"
         teamCoachAttribute.type = .string
         teamEntity.properties.append(teamCoachAttribute)
         
         let teamColorAttribute = NSAttributeDescription()
         teamColorAttribute.name = "teamColor"
         teamColorAttribute.type = .string
         teamEntity.properties.append(teamColorAttribute)
         
         let teamIconAttribute = NSAttributeDescription()
         teamIconAttribute.name = "teamIcon"
         teamIconAttribute.type = .string
         teamEntity.properties.append(teamIconAttribute)
         
         let teamIDAttribute = NSAttributeDescription()
         teamIDAttribute.name = "identifier"
         teamIDAttribute.type = .uuid
         teamEntity.properties.append(teamIDAttribute)
         
         let model = NSManagedObjectModel()
         let person = Persistence.createPersonEntity() 
         
         let memberRelation = NSRelationshipDescription()
         memberRelation.destinationEntity = person
         memberRelation.name = "members"
         memberRelation.minCount = 0
         memberRelation.maxCount = 0
         memberRelation.isOptional = true
         memberRelation.deleteRule = .nullifyDeleteRule
         
         let teamRelation = NSRelationshipDescription()
         teamRelation.destinationEntity = teamEntity
         teamRelation.name = "teams"
         teamRelation.minCount = 0
         teamRelation.maxCount = 0
         teamRelation.isOptional = true
         teamRelation.deleteRule = .nullifyDeleteRule
         
         memberRelation.inverseRelationship = teamRelation
         teamRelation.inverseRelationship = memberRelation
         
         teamEntity.properties.append(memberRelation)
         person.properties.append(teamRelation)
         
         let cashRegister = Persistence.createCashRegisterEntity()
         let cashChanges = Persistence.createCashChangesEntity()
         
         let cashRelation = NSRelationshipDescription()
         cashRelation.destinationEntity = cashRegister
         cashRelation.name = "register"
         cashRelation.minCount = 0
         cashRelation.maxCount = 1
         cashRelation.isOptional = true
         cashRelation.deleteRule = .nullifyDeleteRule
         
         let teamRelationCash = NSRelationshipDescription()
         teamRelationCash.destinationEntity = teamEntity
         teamRelationCash.name = "team"
         teamRelationCash.minCount = 0
         teamRelationCash.maxCount = 1
         teamRelationCash.isOptional = true
         teamRelationCash.deleteRule = .nullifyDeleteRule
         
         teamEntity.properties.append(cashRelation)
         cashRegister.properties.append(teamRelationCash)
         
         let eventEntity = Persistence.createEventEntity()
         
         let eventRelation = NSRelationshipDescription()
         eventRelation.destinationEntity = eventEntity
         eventRelation.name = "events"
         eventRelation.minCount = 0
         eventRelation.maxCount = 0
         eventRelation.isOptional = true
         eventRelation.deleteRule = .nullifyDeleteRule
         
         let teamRelationEvent = NSRelationshipDescription()
         teamRelationEvent.destinationEntity = teamEntity
         teamRelationEvent.name = "team"
         teamRelationEvent.minCount = 0
         teamRelationEvent.maxCount = 1
         teamRelationEvent.isOptional = true
         teamRelationEvent.deleteRule = .nullifyDeleteRule
         
         teamEntity.properties.append(eventRelation)
         eventEntity.properties.append(teamRelationEvent)
         
         let chnagesRelation = NSRelationshipDescription()
         chnagesRelation.destinationEntity = cashChanges
         chnagesRelation.name = "changes"
         chnagesRelation.minCount = 0
         chnagesRelation.maxCount = 0
         chnagesRelation.isOptional = true
         chnagesRelation.deleteRule = .nullifyDeleteRule
         
         let cashChangeRelation = NSRelationshipDescription()
         cashChangeRelation.destinationEntity = cashRegister
         cashChangeRelation.name = "register"
         cashChangeRelation.minCount = 0
         cashChangeRelation.maxCount = 1
         cashChangeRelation.isOptional = true
         cashChangeRelation.deleteRule = .nullifyDeleteRule
         
         cashRegister.properties.append(chnagesRelation)
         cashChanges.properties.append(cashChangeRelation)
         
         model.entities = [teamEntity, person, cashChanges, cashRegister, eventEntity]
        
         return model
    }
    /// Create the person model with all attributes
    static func createPersonEntity() -> NSEntityDescription {
        let personEntity = NSEntityDescription()
        personEntity.name = "Person"
        personEntity.managedObjectClassName = "Person"
        
        let personNameAttribute = NSAttributeDescription()
        personNameAttribute.name = "name"
        personNameAttribute.type = .string
        personEntity.properties.append(personNameAttribute)
        
        let personCategoryAttribute = NSAttributeDescription()
        personCategoryAttribute.name = "category"
        personCategoryAttribute.type = .integer64
        personEntity.properties.append(personCategoryAttribute)
        
        let personPictureAttribute = NSAttributeDescription()
        personPictureAttribute.name = "picture"
        personPictureAttribute.type = .binaryData
        personEntity.properties.append(personPictureAttribute)
        
        let personPositionAttribute = NSAttributeDescription()
        personPositionAttribute.name = "position"
        personPositionAttribute.type = .string
        personEntity.properties.append(personPositionAttribute)
        
        let personBirthDateAttribute = NSAttributeDescription()
        personBirthDateAttribute.name = "birthdate"
        personBirthDateAttribute.type = .date
        personEntity.properties.append(personBirthDateAttribute)
        
        let personPhoneAttribute = NSAttributeDescription()
        personPhoneAttribute.name = "phoneNumber"
        personPhoneAttribute.type = .string
        personEntity.properties.append(personPhoneAttribute)
        
        let personIDAttribute = NSAttributeDescription()
        personIDAttribute.name = "identifier"
        personIDAttribute.type = .uuid
        personEntity.properties.append(personIDAttribute)
        
        return personEntity
    }
    /// Create the cash register model with all attributes
    static func createCashRegisterEntity() -> NSEntityDescription {
        let cashRegisterEntity = NSEntityDescription()
        cashRegisterEntity.name = "CashRegister"
        cashRegisterEntity.managedObjectClassName = "CashRegister"
        
        let cashRegisterIDAttribute = NSAttributeDescription()
        cashRegisterIDAttribute.name = "identifier"
        cashRegisterIDAttribute.type = .uuid
        cashRegisterEntity.properties.append(cashRegisterIDAttribute)
        
        let cashRegisterCashAttribute = NSAttributeDescription()
        cashRegisterCashAttribute.name = "cash"
        cashRegisterCashAttribute.type = .double
        cashRegisterEntity.properties.append(cashRegisterCashAttribute)
        
        return cashRegisterEntity
    }
    /// Create the cash change model with all attributes
    static func createCashChangesEntity() -> NSEntityDescription {
        let cashChangeEntity = NSEntityDescription()
        cashChangeEntity.name = "CashChanges"
        cashChangeEntity.managedObjectClassName = "CashChanges"
        
        let cashChangeDateAttribute = NSAttributeDescription()
        cashChangeDateAttribute.name = "date"
        cashChangeDateAttribute.type = .date
        cashChangeEntity.properties.append(cashChangeDateAttribute)
        
        let cashChangeAmountAttribute = NSAttributeDescription()
        cashChangeAmountAttribute.name = "amount"
        cashChangeAmountAttribute.type = .double
        cashChangeEntity.properties.append(cashChangeAmountAttribute)
        
        let cashChangeDescriptionAttribute = NSAttributeDescription()
        cashChangeDescriptionAttribute.name = "changeDescription"
        cashChangeDescriptionAttribute.type = .string
        cashChangeEntity.properties.append(cashChangeDescriptionAttribute)
        
        let cashChangeIDAttribute = NSAttributeDescription()
        cashChangeIDAttribute.name = "identifier"
        cashChangeIDAttribute.type = .uuid
        cashChangeEntity.properties.append(cashChangeIDAttribute)
        
        return cashChangeEntity
    }
    /// Create the event model with all attributes
    static func createEventEntity() -> NSEntityDescription {
        let eventEntity = NSEntityDescription()
        eventEntity.name = "Event"
        eventEntity.managedObjectClassName = "Event"
        
        let eventDateAttribute = NSAttributeDescription()
        eventDateAttribute.name = "date"
        eventDateAttribute.type = .date
        eventEntity.properties.append(eventDateAttribute)
        
        let eventLocationAttribute = NSAttributeDescription()
        eventLocationAttribute.name = "location"
        eventLocationAttribute.type = .string
        eventEntity.properties.append(eventLocationAttribute)
        
        let eventDescriptionAttribute = NSAttributeDescription()
        eventDescriptionAttribute.name = "eventDescription"
        eventDescriptionAttribute.type = .string
        eventEntity.properties.append(eventDescriptionAttribute)
        
        let eventResultOwnAttribute = NSAttributeDescription()
        eventResultOwnAttribute.name = "resultOwnTeam"
        eventResultOwnAttribute.type = .integer16
        eventEntity.properties.append(eventResultOwnAttribute)
        
        let eventResultOpponentAttribute = NSAttributeDescription()
        eventResultOpponentAttribute.name = "resultOpponent"
        eventResultOpponentAttribute.type = .integer16
        eventEntity.properties.append(eventResultOpponentAttribute)
        
        let eventIDAttribute = NSAttributeDescription()
        eventIDAttribute.name = "identifier"
        eventIDAttribute.type = .uuid
        eventEntity.properties.append(eventIDAttribute)
        
        return eventEntity
    }
}
