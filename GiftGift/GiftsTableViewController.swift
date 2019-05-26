//
//  GiftsTableViewController.swift
//  GiftGift
//
//  Created by Caio Cesar on 24/04/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import Firebase

class GiftsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    //tableview methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "giftCell", for: indexPath) as! GiftTableViewCell
        let gift = self.gifts[indexPath.row]
        cell.setupCell(gift: gift)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = gifts[indexPath.row]
        performSegue(withIdentifier: "GiftsSingle", sender: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = gifts[indexPath.row]
            firestore.collection("presentes").document(item.id ?? "").delete()
        }
    }
    
    let collection = "presentes"
    var firestoreListener: ListenerRegistration!
    var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        var firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    var gifts: [Gift] = []
    
    func listItems() {
        
        firestoreListener = firestore.collection(collection).order(by: "name", descending: false).addSnapshotListener(includeMetadataChanges: true){ (snapshot, error) in
            
            if error != nil {
                print(error!)
            }
            
            guard let snapshot = snapshot else {return}
            if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                self.showItems(snapshot: snapshot)
            }
            
        }
    }
 
    
    func showItems(snapshot: QuerySnapshot) {
        gifts.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let name = data["name"] as? String,
                let place = data["place"] as? String,
                let value = data["value"] as? Float {
                let giftItem = Gift(id: document.documentID, name: name, place: place, value: value)
                gifts.append(giftItem)
            }
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GiftsSingle" {
            if let gift = sender as? Gift {
                if let vc = segue.destination as? GiftViewController {
                    vc.giftItem = gift
                }
            }
        }
    }
    

}
