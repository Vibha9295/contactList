//
//  ViewController.swift
//  DemoContactDB
//
//  Created by vibha on 28/11/18.
//  Copyright © 2018 vibha. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var objects  = [CNContact]()

    @IBOutlet var tblContact: UITableView!
    lazy var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return results
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getContacts()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getContacts() {
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            self.retrieveContactsWithStore(store: store)
            
        // This is the method we will create
        case .notDetermined:
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                    return
                }
                self.retrieveContactsWithStore(store: store)
                
            }
        default:
            print("Not handled")
        }
        
    }
    func retrieveContactsWithStore(store: CNContactStore)
    {
        
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey,CNContactImageDataKey, CNContactEmailAddressesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        var cnContacts = [CNContact]()
        do {
            try store.enumerateContacts(with: request){
                (contact, cursor) -> Void in
                if (!contact.phoneNumbers.isEmpty) {
                }
                
                if contact.isKeyAvailable(CNContactImageDataKey) {
                    if let contactImageData = contact.imageData {
                        print(UIImage(data: contactImageData)) // Print the image set on the contact
                    }
                } else {
                    // No Image available
                    
                }
                if (!contact.emailAddresses.isEmpty) {
                }
                cnContacts.append(contact)
                self.objects = cnContacts
            }
        } catch let error {
            NSLog("Fetch contact error: \(error)")
        }
        
        NSLog(">>>> Contact list:")
        for contact in cnContacts {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            NSLog("\(fullName): \(contact.phoneNumbers.description)")
        }
        DispatchQueue.main.async {
             self.tblContact.reloadData()
        }
       
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getDateStringFromComponents(dateComponents: NSDateComponents) -> String! {
        if let date = NSCalendar.current.date(from: dateComponents as DateComponents) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let dateString = dateFormatter.string(from: date)
            
            return dateString
        }
        
        return nil
    }
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath as IndexPath) as! contactCell
        let contact = self.objects[indexPath.row]
        print("theis my contact arrau \(self.objects.count)")
        let formatter = CNContactFormatter()
        cell.lblname.text = formatter.string(from: contact )
        if let actualNumber = contact.phoneNumbers.first?.value {
            //Get the label of the phone number
            
            //Strip out the stuff you don't need
            print(actualNumber.stringValue)
            cell.lblNumber.text = actualNumber.stringValue
        }
        else{
            cell.lblNumber.text = "N.A "
        }
        if let actualEmail = (contact as AnyObject).emailAddresses?.first?.value as String? {
            print(actualEmail)
            cell.lblDate.text = actualEmail
        }
        else{
            cell.lblDate.text = "N.A "
        }
        if let imageData = contact.imageData {
            //If so create the image
            let userImage = UIImage(data: imageData)
            cell.imgContcat.image = userImage;
        }
            
        else{
            cell.imgContcat.image = UIImage (named: "N.A")
        }
        return cell
    }
    
 
}

