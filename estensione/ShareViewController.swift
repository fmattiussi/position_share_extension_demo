//
//  ShareViewController.swift
//  estensione
//
//  Created by Francesco Mattiussi on 04/04/2019.
//  Copyright © 2019 Francesco Mattiussi. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Contacts

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        stampadatimappe()
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    func stampadatimappe() {
        if let elementi = self.extensionContext?.inputItems[0] as? NSExtensionItem{
            for elemento in elementi.attachments!{
                let itemProvider = elemento
                if itemProvider.hasItemConformingToTypeIdentifier("public.vcard"){
                    itemProvider.loadItem(forTypeIdentifier: "public.vcard", options: nil, completionHandler: { (item, error) in
                        
                        do {
                            let defaults = UserDefaults.init(suiteName: "group.mapsext")
                            let estratto = try CNContactVCardSerialization.contacts(with: item as! Data)
                            defaults?.set(item, forKey: "info")
                            print("estratto \(estratto)") //
                        }catch let err{
                            print(err)
                        }
                    })
                }
            }
        }

    }

}
