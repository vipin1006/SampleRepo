//
//  Technology+CoreDataProperties.swift
//  EHire
//
//  Created by Vipin Nambiar on 27/11/15.
//  Copyright © 2015 Pavithra G. Jayanna. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Technology {

    @NSManaged var technologyId: NSNumber?
    @NSManaged var technologyName: String?
    @NSManaged var interviewDate: NSMutableSet?

}
