//
//  ViewController.swift
//  provamapsextension
//
//  Created by Francesco Mattiussi on 04/04/2019.
//  Copyright © 2019 Francesco Mattiussi. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sezioni: [String] = ["Indirizzo","Altro"]
    var indirizzo: [String] = []
    var altro: [String] = []
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sezioni[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sezioni.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var elementi: [[String]] = []
        elementi.append(indirizzo)
        elementi.append(altro)
        return elementi[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cella", for: indexPath) as! Cella
        cell.testo.text = indirizzo[indexPath.row]
        if indexPath.section == 1 {
            cell.testo.text = altro[indexPath.row]
        }
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ricarica(notifica:)), name: NSNotification.Name(rawValue: "ricarica"), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func ricarica(notifica: Notification) {
        ricevielementi()
    }
    
    @IBOutlet weak var titolo: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    func ricevielementi() {
        indirizzo = []
        altro = []
        let defaults = UserDefaults.init(suiteName: "group.mapsext")
        let dati = defaults?.object(forKey: "info")
        if dati != nil {
            do {
                let contatti = try CNContactVCardSerialization.contacts(with: dati as! Data)
                let contatto = contatti.first
                print(contatto!)
                titolo.text = contatto?.organizationName
                let datistrada = contatto?.postalAddresses.first?.value
                let generali = contatto?.phoneNumbers.first?.value
                indirizzo.append((datistrada?.street)!)
                indirizzo.append((datistrada?.city)!)
                indirizzo.append((datistrada?.subAdministrativeArea)!)
                indirizzo.append((datistrada?.state)!)
                indirizzo.append((datistrada?.postalCode)!)
                indirizzo.append((datistrada?.country)!)
                if generali?.stringValue != nil {
                    altro.append((generali?.stringValue)!)
                }
                tableview.reloadData()
            } catch {
                
            }
        }
    }
}
