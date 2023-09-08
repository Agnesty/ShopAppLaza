//
//  CoreDataManager.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/09/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    var presentAlertSucces: (() -> Void)?
    var presentAlertUpdateSucces: (() -> Void)?
    var presentAlertFailed: (() -> Void)?
    var presentAlertUpdateFailed: (() -> Void)?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var userData: UserElement?
    
    func getUserDataFromKeychain() {
        if let dataProfile = KeychainManager.keychain.getProfileToKeychain(service: Token.saveProfile.rawValue) {
            self.userData = dataProfile
        } else {
            return print("data kosong")
        }
    }
    
    func create(_ cardModel: CardModel) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        getUserDataFromKeychain()
        
        let creditCardEntity = NSEntityDescription.entity(forEntityName: "DataCard", in: managedContext)
        
        let insert = NSManagedObject(entity: creditCardEntity!, insertInto: managedContext)
        insert.setValue(userData?.data.id, forKey: "userId")
        insert.setValue(cardModel.cvvCard, forKey: "cvvCard")
        insert.setValue(cardModel.expMonthCard, forKey: "expMonthCard")
        insert.setValue(cardModel.expYearCard, forKey: "expYearCard")
        insert.setValue(cardModel.numberCard, forKey: "numberCard")
        insert.setValue(cardModel.ownerCard, forKey: "ownerCard")
        
        do {
            try managedContext.save()
            presentAlertSucces?()
            print("Saved data into Core Data")
        } catch let err {
            presentAlertFailed?()
            print("Failed to save data", err)
        }
    }
    
    func retrieveAllCard(completion: @escaping ([CardModel]) -> Void) {
        var creditCard = [CardModel]() // Mulai dengan array kosong
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        getUserDataFromKeychain()
        
        guard let userId = userData?.data.id else {
            print("UserID is nil")
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataCard")
        fetchRequest.predicate = NSPredicate(format: "userId = %@", String(userId))
        
        do {
            let result = try managedContext?.fetch(fetchRequest)
            result?.forEach { creditCardData in
                let card = CardModel(
                    userId: creditCardData.value(forKey: "userId") as! Int,
                    ownerCard: creditCardData.value(forKey: "ownerCard") as! String,
                    numberCard: creditCardData.value(forKey: "numberCard") as! String,
                    cvvCard: creditCardData.value(forKey: "cvvCard") as! String,
                    expMonthCard: creditCardData.value(forKey: "expMonthCard") as! String,
                    expYearCard: creditCardData.value(forKey: "expYearCard") as! String
                )
                creditCard.append(card)
            }
            
            completion(creditCard) // Mengirimkan data yang ditemukan
            print("Success")
        } catch let error {
            print("Failed to fetch data", error)
        }
    }
    
    func updateData(_ cardModel: CardModel, numberCard: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        getUserDataFromKeychain()
        
        guard let userId = userData?.data.id else {
            print("UserID is nil")
            return
        }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "DataCard")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "numberCard = %@", numberCard),
            NSPredicate(format: "userId = %@", String(userId))
        ])
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            
            if let updateCard = fetchedResults.first {
                updateCard.setValue(cardModel.userId, forKey: "userId")
                updateCard.setValue(cardModel.numberCard, forKey: "numberCard")
                updateCard.setValue(cardModel.ownerCard, forKey: "ownerCard")
                updateCard.setValue(cardModel.expMonthCard, forKey: "expMonthCard")
                updateCard.setValue(cardModel.expYearCard, forKey: "expYearCard")
                updateCard.setValue(cardModel.cvvCard, forKey: "cvvCard")
            }
            
            do {
                try managedContext.save()
                presentAlertUpdateSucces?()
                print("Data updated successfully")
            } catch{
                presentAlertUpdateFailed?()
                print("Failed to update data: (error), (error.userInfo)", error)
            }
        } catch {
            print("Fetch error: (error), (error.userInfo)", error)
        }
    }
    
    func delete(_ creditCard: CardModel, completion: @escaping () -> Void) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return }
        
        getUserDataFromKeychain()
        guard let userId = userData?.data.id else {
            print("UserID is nil")
            return
        }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DataCard")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "numberCard = %@", creditCard.numberCard),
            NSPredicate(format: "userId = %@", String(userId))
        ])
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for dataToDelete in result {
                managedContext.delete(dataToDelete as! NSManagedObject)
            }
            try managedContext.save()
            completion()
            
        } catch let error {
            print("Unable to delete data", error)
        }
    }
    
    
    
}
