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
    var presentAlertFailed: (() -> Void)?
    var navigateToBack: (() -> Void)?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
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
                navigateToBack?()
            } else {
                presentAlertFailed?()
            }
        } catch let error {
            print("Failed to create data", error)
        }
    }
    
    func retrieve(completion: @escaping ([CardModel]) -> Void) {
        var creditCard = [CardModel]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataCard")
        
        do {
            let result = try managedContext?.fetch(fetchRequest)
            result?.forEach { creditCardData in
                creditCard.append(CardModel(
                    ownerCard: creditCardData.value(forKey: "ownerCard") as! String,
                    numberCard: creditCardData.value(forKey: "numberCard") as! String,
                    cvvCard: creditCardData.value(forKey: "cvvCard") as! String,
                    expMonthCard: creditCardData.value(forKey: "expMonthCard") as! String,
                    expYearCard: creditCardData.value(forKey: "expYearCard") as! String)
                )
                completion(creditCard)
                print("Success")
            }
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
              presentAlertSucces?()
              navigateToBack?()
              print("Data updated successfully")
            } catch{
              presentAlertFailed?()
              print("Failed to update data: (error), (error.userInfo)", error)
            }
          
        } catch {
          print("Fetch error: (error), (error.userInfo)", error)
        }
      }
    
    

}
