//
//  Message.swift
//  PetMate
//
//  Created by Jacobo Tapia on 25/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import Firebase

class Message : NSObject {
    
    var id : String?
    var fromId : String?
    var toId : String?
    var text : String?
    var timestamp : NSNumber?
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
}
