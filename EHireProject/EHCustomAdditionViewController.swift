//
//  EHCustomAdditionViewController.swift
//  EHire
//
//  Created by Vipin Nambiar on 27/11/15.
//  Copyright © 2015 Pavithra G. Jayanna. All rights reserved.
//

import Cocoa

protocol EHCustomAdditionProtocol {
    func cancelBtnClicked()
    func addBtnClicked(addedContent : AnyObject)
}
class EHCustomAdditionViewController: NSViewController {

    @IBOutlet weak var datePickerBox: NSBox?
    @IBOutlet weak var addTechnologyBox: NSBox?
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var textFeildContent: NSTextField!
   
    var isTechnologySelected = Bool()
    @IBOutlet var boxDatePicker: NSBox!
    
    var selectedDate = String()
    var headerTitle = String()
    var delegate: EHCustomAdditionProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
         datePicker.minDate = NSDate()
        
        
       
        if isTechnologySelected
        {
            if addTechnologyBox != nil{
                addTechnologyBox!.hidden = true
               
                self.view.addSubview(datePickerBox!)
                createConstraints(0, trailing: 0, top: 0, bottom: 0)
                
            }
        }
        else
        {
            if addTechnologyBox != nil{
                addTechnologyBox!.hidden = false
                datePickerBox!.hidden = true
                
                
                
            }
        }

        // Do view setup here.
    }
    
    
    // PRAGMAMARK: - Initialization Methods
    init(inNibname:String ,isTechnologySelected:Bool, title:String )
   {
    super.init(nibName:inNibname, bundle:nil)!

    self.isTechnologySelected = isTechnologySelected
    self.headerTitle = title
    
    }

    func createConstraints(leading:CGFloat,trailing:CGFloat,top:CGFloat,bottom:CGFloat){
        let xLeadingSpace = NSLayoutConstraint(item: datePickerBox!, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: leading)
        
        let xTrailingSpace = NSLayoutConstraint(item: datePickerBox!, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: trailing)
        
        let yTopSpace = NSLayoutConstraint(item: datePickerBox!, attribute:  .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: top)
        
        let yBottomSpace = NSLayoutConstraint(item: datePickerBox!, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: bottom)
        self.view .addConstraints([xLeadingSpace,xTrailingSpace,yTopSpace,yBottomSpace])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // PRAGMAMARK: - Method to cancel technology and date addition
    @IBAction func btnActionCancel(sender: AnyObject) {
        
        delegate?.cancelBtnClicked()
    }
    
    // PRAGMAMARK: - Method to add technology
    @IBAction func btnActionAddTechnology(sender: AnyObject) {
         delegate?.addBtnClicked(textFeildContent.stringValue)
    }
    
    // PRAGMAMARK: - Method to select date
    @IBAction func btnActionSelectDate(sender: AnyObject) {
              delegate?.addBtnClicked(datePicker.dateValue)
    }
    

}
