//
//  Extensions.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 22/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    // MARK: - Keyboard Helpers
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Alert View Helpers
    func showAlert(title: String, message: String, actions: [String]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if(actions.count > 1) {
            for action in actions {
                if(action == "OK") {
                    alert.addAction(UIAlertAction(title: action, style: .default, handler: dismissHandler(alert:)))
                } else {
                    alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
                }
            }
        } else {
            alert.addAction(UIAlertAction(title: actions[0], style: .default, handler: nil))
        }
        
        present(alert, animated: true)
    }
    
    func dismissHandler(alert: UIAlertAction!) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Core Data Helpers
    func fetchMembers() -> [Member]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Member>(entityName: "Member")
        do {
            let members = try managedObjectContext.fetch(fetchRequest)
            return members
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func fetchNewCustomers() -> [NewCustomer]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NewCustomer>(entityName: "NewCustomer")
        do {
            let newCustomers = try managedObjectContext.fetch(fetchRequest)
            return newCustomers
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func getMemberEntity(_ member: Member) -> Member {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Member", in: context)
        let member = NSManagedObject(entity: entity!, insertInto: context)
        return member as! Member
    }
    
    func getNewCustomerEntity(_ newCustomer: NewCustomer) -> NewCustomer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NewCustomer", in: context)
        let newCustomer = NSManagedObject(entity: entity!, insertInto: context)
        return newCustomer as! NewCustomer
    }
    
    func saveData() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try context.save()
            return true
            
        } catch {
            return false
        }
    }
    
    func deleteNewCustomer (_ newCustomer: NewCustomer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(newCustomer)
    }
    
    func deleteNewMember (_ newMember: Member) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(newMember)
    }
    
}

extension Array where Element == UITextField {
    
    // MARK: - Text Field Helpers
    var fieldsEmpty: Bool {
        return contains(where: { $0.text!.trimmingCharacters(in: .whitespaces).isEmpty })
    }
    
    var fieldsWithContent: Bool {
        return !contains(where: { $0.text!.trimmingCharacters(in: .whitespaces).count > 0 })
    }
    
}

extension String {
    
    // MARK: - Regex Helpers
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPhoneNumber() -> Bool {
        let regex = try! NSRegularExpression(pattern: "((\\+[0-9]{2})|0)[.\\- ]?9[0-9]{2}[.\\- ]?[0-9]{3}[.\\- ]?[0-9]{4}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
}
