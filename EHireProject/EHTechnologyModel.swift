//
//  EHTechnologyModel.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 10/12/15.
//  Copyright © 2015 Pavithra G. Jayanna. All rights reserved.
//

import Cocoa

class EHTechnologyModel: NSObject {

   
        var techName : String?
//        var technologyId : UInt32?
        var interviewDates : [EHDateModel] = []
        
        var sourceListContent : [EHTechnologyModel] = []
        
        
        //PRAGMAMARK : - Method to get technology and date from core data
        func getSourceListContent() -> Array <EHTechnologyModel>{
            
            
            if let appDel = NSApplication.sharedApplication().delegate as? AppDelegate {
                let moc = appDel.managedObjectContext as NSManagedObjectContext
                let entity1 = EHCoreDataHelper.createEntity("Technology", moc: moc)
                
                let records = EHCoreDataHelper.fetchRecords(nil, sortDes: nil, entity: entity1!, moc: moc)
                if records?.count > 0{
                    
                    for aRec in records!{
                        
                        let aTechnology = aRec as! Technology
                        
                        let childrens = aTechnology.interviewDate
                        let arr = childrens!.allObjects
                        
                        
                        
                        
                        
                        let technologyObject = EHTechnologyModel()
                        technologyObject.techName = aTechnology.technologyName
                        
                        for object in arr{
                            let dateObject = EHDateModel()
                            dateObject.interviewDate = object.interviewDate
                            technologyObject.interviewDates.append(dateObject)
                        }
                        sourceListContent.append(technologyObject)
                        
                        
                    }
                }
                
            }
            return sourceListContent
        }
  
}
