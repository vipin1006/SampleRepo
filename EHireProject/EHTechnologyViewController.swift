 //
//  EHTechnologyViewController.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 26/11/15.
//  Copyright © 2015 Pavithra G. Jayanna. All rights reserved.
//

import Cocoa

class EHTechnologyViewController: NSWindowController,NSOutlineViewDataSource,NSOutlineViewDelegate,EHCustomAdditionProtocol {
    var ehCustomAdditionViewController =  EHCustomAdditionViewController(inNibname: "EHCustomAdditionViewController", isTechnologySelected : true,title:"")
    
    var ehCandidateViewController =  EHCandidateViewController(nibName:"EHCandidateViewController", bundle: nil)

    var sourceListContent : [EHTechnologyModel] = []

    @IBOutlet weak var imageWelcome: NSImageView!
    @IBOutlet weak var outlineview: NSOutlineView!
    @IBOutlet weak var ehCustomAdditionParentView: NSView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override func windowWillLoad() {
        getSourceListContent()
    }
    
    // PRAGMAMARK: - Fetching saved data from coredata

    func getSourceListContent() {
        
        if let appDel = NSApplication.sharedApplication().delegate as? AppDelegate {
            let context = appDel.managedObjectContext as NSManagedObjectContext
            let technologyEntity = EHCoreDataHelper.createEntity("Technology", moc: context)
            
            let records = EHCoreDataHelper.fetchRecords(nil, sortDes: nil, entity: technologyEntity!, moc: context)
            if records?.count > 0{
                
                for aRec in records!{
                    
                    let aTechnologyEntity = aRec as! Technology
                    
                    let childrens = aTechnologyEntity.interviewDate
                    let arr = childrens!.allObjects
                    
                    //  mapping coredata content to our custom model
                    let technologyModel = EHTechnologyModel()
                    technologyModel.techName = aTechnologyEntity.technologyName
                    
                    for object in arr{
                        let dateObject = EHDateModel()
                        dateObject.interviewDate = object.interviewDate
                        technologyModel.interviewDates.append(dateObject)
                    }
                    sourceListContent.append(technologyModel)
                }
            }
        }
    }

    // PRAGMAMARK: - Outline View DataSource Methods
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        switch item
        {
        case let item as EHTechnologyModel :
            return item.interviewDates.count // return children(interview date)count
        default :
            return self.sourceListContent.count
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        switch item
        {
        case let item as EHTechnologyModel : //
                return (item.interviewDates.count > 0 ) ? true :false
        default :
            return false
        }
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        
        if let item: AnyObject = item
        {
            switch item
            {
            case let tech as EHTechnologyModel:
                return tech.interviewDates[index]
            default:
                return self
            }
        }
        else
        {
            return sourceListContent[index]
        }

    }
    
    // PRAGMAMARK: - Outline View Delegate Methods
    func outlineView(outlineView: NSOutlineView, viewForTableColumn: NSTableColumn?, item: AnyObject) -> NSView?
    {
        switch item
        {
        case let tech as EHTechnologyModel:
            let view = outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as! NSTableCellView
            if let textField = view.textField
            {
                
                textField.stringValue = tech.techName!
            }
            return view
        case let interView as EHDateModel:
            let view = outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView
            if let textField = view.textField
            {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yy" //format style. Browse online to get a format that fits your needs.
                let dateString = dateFormatter.stringFromDate(interView.interviewDate!)
                textField.stringValue = dateString
            }
            return view
        default:
            return nil
        }
        
    }
    func outlineViewSelectionDidChange(notification: NSNotification){
        print(notification)
        var selectedIndex = notification.object?.selectedRow
        var object:AnyObject? = notification.object?.itemAtRow(selectedIndex!)
        print(object)
        if (object is EHDateModel){
            
            imageWelcome.hidden = true
             let ehCandidateViewController =  EHCandidateViewController(nibName:"EHCandidateViewController", bundle: nil)
           
            
            ehCandidateViewController?.view.wantsLayer = true
            ehCandidateViewController?.view.layer?.backgroundColor = NSColor.yellowColor().CGColor

             self.ehCustomAdditionParentView.addSubview(ehCandidateViewController!.view)
            ehCandidateViewController?.view.frame = self.ehCustomAdditionParentView.bounds
            
                       self.createConstraintsForEhCandidateView(0.0, trailing: 0.0, top: 0.0, bottom: 0.0)
        }
        
        
    }

    // PRAGMAMARK: - Method to show add technology and date view
    
    @IBAction func btnActionAdd(sender: AnyObject) {
        // Adding EHCustomAdditionView to EHCustomAdditionParentView
        if  ((outlineview.itemAtRow(outlineview.selectedRow) as? EHTechnologyModel) != nil){
            let selectedTechnology = outlineview.itemAtRow(outlineview.selectedRow) as? EHTechnologyModel
            let selectedTechnologyName = NSString(format: EH_ADD_DATE, selectedTechnology!)
            ehCustomAdditionViewController  = EHCustomAdditionViewController(inNibname: "EHCustomAdditionViewController", isTechnologySelected: true,title: selectedTechnologyName as String)
        }
        else{
            ehCustomAdditionViewController  = EHCustomAdditionViewController(inNibname: "EHCustomAdditionViewController", isTechnologySelected: false,title: EH_ADD_TECHNOLOGY)
        }

        imageWelcome.hidden = true
        ehCustomAdditionViewController.delegate = self
        ehCustomAdditionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        
          self.ehCustomAdditionParentView.addSubview((ehCustomAdditionViewController.view))
        
        let xCenterConstraint = NSLayoutConstraint(item: ehCustomAdditionViewController.view, attribute: .CenterX, relatedBy: .Equal, toItem: self.ehCustomAdditionParentView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let yCenterConstraint = NSLayoutConstraint(item: ehCustomAdditionViewController.view, attribute: .CenterY, relatedBy: .Equal, toItem: self.ehCustomAdditionParentView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        let fixedWidthConstraint = NSLayoutConstraint(item: ehCustomAdditionViewController.view, attribute:  .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
        
        let fixedHeightContraint = NSLayoutConstraint(item: ehCustomAdditionViewController.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 150)
    
        self.ehCustomAdditionViewController.view.addConstraints([fixedWidthConstraint,fixedHeightContraint])
        
        self.ehCustomAdditionParentView.addConstraints([xCenterConstraint,yCenterConstraint])

    }
    
   // PRAGMAMARK: - Delegate method of EHCustomeAdditionProtocol for cancelling technology and date, addition option
    func cancelBtnClicked(){
        imageWelcome.hidden = false
        self.ehCustomAdditionParentView.subviews.removeAll()
    }
    
    
    // PRAGMAMARK: - Delegate method of EHCustomeAdditionProtocol for adding technology and date
    func addBtnClicked(addedContent : AnyObject){
        print("Content Added is \(addedContent)")
        imageWelcome.hidden = false
        // adding interviewdate to sourceList
        if let selectedItem = outlineview.itemAtRow(outlineview.selectedRow) as? EHTechnologyModel {
            let aString = addedContent as! NSDate
            print(aString)
            
            
            let dateObject = EHDateModel()
            
            dateObject.interviewDate = aString
            selectedItem.interviewDates.append(dateObject)
            addTechnologyAndInterviewDateTocoreData(selectedItem,content:addedContent)
        }
            
        else   // adding new technology to sourcelist
            
        {
            let technologyObject = EHTechnologyModel()
            technologyObject.techName = addedContent as? String
            sourceListContent.append(technologyObject)
            addTechnologyAndInterviewDateTocoreData(nil,content:addedContent)
            self.ehCustomAdditionParentView.subviews.removeAll()
        }
        
        
        outlineview.reloadData()
        self.ehCustomAdditionParentView.subviews.removeAll()
    }
    //PRAGMAMARK: - CoreData Methods

    // PRAGMAMARK: - Method to add technology and date to core data
    func addTechnologyAndInterviewDateTocoreData(sender : AnyObject?,content:AnyObject)
    {
        
        //        fetchRecUsingPredicate()
        
        print (content)
        print(sender?.techName)
        if sender == nil{
            // Adding technology in to coredata
            if let appDel = NSApplication.sharedApplication().delegate as? AppDelegate {
                let moc = appDel.managedObjectContext as NSManagedObjectContext
                let entity1 = EHCoreDataHelper.createEntity("Technology", moc: moc)
                let newTechnology:Technology = Technology(entity:entity1!, insertIntoManagedObjectContext:moc) as Technology
                newTechnology.technologyName = content as? String
                EHCoreDataHelper.saveToCoreData(newTechnology)
                
            }
        }else{
            // Adding Interview Date into core data
            if let appDel = NSApplication.sharedApplication().delegate as? AppDelegate {
                let moc = appDel.managedObjectContext as NSManagedObjectContext
                let selectedTechnology = outlineview.itemAtRow(outlineview.selectedRow) as? EHTechnologyModel
                let name:String = selectedTechnology!.valueForKey("techName") as! String
                let predi = NSPredicate(format: "technologyName = %@",name)
                let technologyRecords = EHCoreDataHelper.fetchRecordsWithPredicate(predi, sortDes: nil, entityName: "Technology", moc: moc)
                
                let entity2 = EHCoreDataHelper.createEntity("Date", moc: moc)
                for aTechnology in technologyRecords!{
                    
                    
                    let dateEntity:Date = Date(entity:entity2!, insertIntoManagedObjectContext:moc) as Date
                    
                    dateEntity.interviewDate = content as? NSDate
                    let technology = aTechnology as! Technology
                    
                    
                    let newSet = NSMutableSet(set: technology.interviewDate!)
                    newSet.addObject(dateEntity)
                    technology.interviewDate = newSet
                    EHCoreDataHelper.saveToCoreData(technology)
                    
                }
                
            }
        }
        
    }
    
    // PRAGMAMARK: - Method to delete technology and date from core data
    
    @IBAction func btnActionDelete(sender: AnyObject) {
        
        if outlineview.selectedRow == -1{
            return
        }
        // deleting technology from sourcelist
        if let selectedItem = outlineview.itemAtRow(outlineview.selectedRow) as? EHTechnologyModel
        {
            var count = 0
            for checkElement in sourceListContent
            {
                if checkElement == selectedItem
                {
                    sourceListContent.removeAtIndex(count)
                }
                count++
            }
            
            let appDel = NSApplication.sharedApplication().delegate as? AppDelegate
            let moc = appDel!.managedObjectContext as NSManagedObjectContext
            
            // deleting technology from coredata
            
            let name:String = selectedItem.valueForKey("techName") as! String
            let predi = NSPredicate(format: "technologyName = %@",name)
            let records = EHCoreDataHelper.fetchRecordsWithPredicate(predi, sortDes: nil, entityName: "Technology", moc: moc)
            
            for aRec in records!{
                let aTechnology = aRec as! Technology
                moc.deleteObject(aTechnology)
                EHCoreDataHelper.saveToCoreData(aTechnology)
            }
        }

            
      else { // deleting interview date
            // deleting from sourcelist content
           

            let selectedInterviewDate = outlineview.itemAtRow(outlineview.selectedRow) as? EHDateModel
            for aTechnology in sourceListContent{
                var count = 0
                for aInterviewDate in aTechnology.interviewDates{

                    if selectedInterviewDate == aInterviewDate{
                        aTechnology.interviewDates.removeAtIndex(count)
                    }
                    count++
                }
            }
            
            // deleting interviewDate from coredata
            let appDel = NSApplication.sharedApplication().delegate as? AppDelegate
            let moc = appDel!.managedObjectContext as NSManagedObjectContext
            let predi = NSPredicate(format: "interviewDate = %@",(selectedInterviewDate?.interviewDate)!)

            let fetchResults =  EHCoreDataHelper.fetchRecordsWithPredicate(predi, sortDes: nil, entityName: "Date", moc: moc)
            
            if let managedObjects = fetchResults as? [NSManagedObject] {
                for aInterviewDate in managedObjects {
                    moc.deleteObject(aInterviewDate)
                    EHCoreDataHelper.saveToCoreData(aInterviewDate)
                }
            }
        }
        outlineview.reloadData()
    }
    
    // PRAGMAMARK: - Constraints for ehCandidateView
    func createConstraintsForEhCandidateView(leading:CGFloat,trailing:CGFloat,top:CGFloat,bottom:CGFloat){
       ehCustomAdditionParentView.wantsLayer = true
        ehCustomAdditionParentView.layer?.backgroundColor = NSColor.blueColor().CGColor
        
       
       
        ehCandidateViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        let xLeadingSpace = NSLayoutConstraint(item: ehCandidateViewController!.view, attribute: NSLayoutAttribute.Leading, relatedBy: .Equal, toItem: self.ehCustomAdditionParentView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 100)
        
        let xTrailingSpace = NSLayoutConstraint(item: ehCandidateViewController!.view, attribute:NSLayoutAttribute.Trailing, relatedBy: .Equal, toItem:self.ehCustomAdditionParentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let yTopSpace = NSLayoutConstraint(item: ehCandidateViewController!.view, attribute:NSLayoutAttribute.Top, relatedBy: .Equal, toItem: self.ehCustomAdditionParentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let yBottomSpace = NSLayoutConstraint(item:ehCandidateViewController!.view, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.ehCustomAdditionParentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.window?.contentView!.addConstraints([xLeadingSpace,xTrailingSpace,yTopSpace,yBottomSpace])
      self.window?.contentView!.needsLayout=true
       self.window?.contentView!.needsUpdateConstraints=true
        // self.window?.contentView!.layoutSubtreeIfNeeded()
        
        self.ehCustomAdditionParentView.needsLayout=true
        
    }
 }
