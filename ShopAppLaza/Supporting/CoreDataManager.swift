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
    
    func createku(_ cardModel: CardModel) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let creditCardEntity = NSEntityDescription.entity(forEntityName: "DataCard", in: managedContext)
        
        let insert = NSManagedObject(entity: creditCardEntity!, insertInto: managedContext)
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
    
    func create(_ cardModel: CardModel) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataCard")
        fetchRequest.predicate = NSPredicate(format: "numberCard = %@", cardModel.numberCard)
        
        do {
            let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if result?.isEmpty == true {
                // Data tidak ditemukan, tambahkan ke Core Data
                let userEntity = NSEntityDescription.entity(forEntityName: "DataCard", in: managedContext)
                
                //entity body
                let insert = NSManagedObject(entity: userEntity!, insertInto: managedContext)
                insert.setValue(cardModel.cvvCard, forKey: "cvvCard")
                insert.setValue(cardModel.expMonthCard, forKey: "expMonthCard")
                insert.setValue(cardModel.expYearCard, forKey: "expYearCard")
                insert.setValue(cardModel.numberCard, forKey: "numberCard")
                insert.setValue(cardModel.ownerCard, forKey: "ownerCard")
                
                try managedContext.save()
                print("Saved data into CoreData")
                presentAlertSucces?()
            } else {
                presentAlertFailed?()
            }
        } catch let error {
            print("Failed to create data", error)
        }
    }
    
    func retrieve(completion: @escaping ([CardModel]) -> Void) {
        var creditCard = [CardModel]() // Mulai dengan array kosong
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataCard")
        
        do {
            let result = try managedContext?.fetch(fetchRequest)
            result?.forEach { creditCardData in
                let card = CardModel(
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
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "DataCard")
        fetchRequest.predicate = NSPredicate(format: "numberCard = %@", numberCard)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            
            if let updateCard = fetchedResults.first {
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
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DataCard")
        fetchRequest.predicate = NSPredicate(format: "numberCard = %@", creditCard.numberCard)
        
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
