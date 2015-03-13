//
//  AppDelegate.swift
//  MyContacts
//
//  Created by Benjamin King on 3/12/15.
//  Copyright (c) 2015 Benjamin King. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate, ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate {

    var window: UIWindow?
    var addressBook: ABAddressBook!
    var masterNav: UINavigationController?
    
    // MARK: - UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.masterNav = UINavigationController.init()
        self.masterNav?.delegate = self
        self.window?.rootViewController = self.masterNav?
        self.window?.makeKeyAndVisible()
        self.checkAddressBookAccess()
        return true
    }
 
    func checkAddressBookAccess() {
        switch(ABAddressBookGetAuthorizationStatus()) {
        case .Authorized: self.accessGrantedForAddressBook()
        case .NotDetermined: self.requestAddressBookAccess()
        case .Denied: fallthrough
        case .Restricted:
            println("Address Book access either Denied or Restricted")
        }
    }
    
    func requestAddressBookAccess() {
        ABAddressBookRequestAccessWithCompletion(addressBook) {
            (granted: Bool, err: CFError!) in
            if(granted) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.accessGrantedForAddressBook()
                }
            } else {
                println("ABAddressBookRequestAccessWithCompletion handler got denied!")
            }
        }
    }
    
    func accessGrantedForAddressBook() {
        println("accessGrantedForAddressBook")
        var err: Unmanaged<CFError>? = nil
        let ab = ABAddressBookCreateWithOptions(nil, &err)
        if err == nil {
            self.addressBook = ab.takeRetainedValue()
        } else {
            assertionFailure("Could not create Address Book!")
            // Tell the user to go to Settings.app -> Privacy -> Contacts -> Enable ABC
        }
        
        showPeoplePickerController()
    }
    
    func showPeoplePickerController() {
        println("showPeoplePickerController")
        
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        
        // This is nil.... apparently this started in iOS 8
        //println("ABPeoplePickerNavigationController.topViewController = \(picker.topViewController?)")
        
        // This crashes!
        //self.masterNav?.setViewControllers([picker.topViewController], animated: true)
        
        // This the only way I was able to add ABPeoplePicker to my root UINavigationController
        self.masterNav?.view.addSubview(picker.view)       // This must come before addChildViewController!!!
        self.masterNav?.addChildViewController(picker)
        picker.didMoveToParentViewController(self.masterNav?)
    }
    
    // MARK: - ABPeoplePickerNavigationControllerDelegate
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        let personVC = ABPersonViewController()
        personVC.personViewDelegate = self
        personVC.allowsEditing = true
        personVC.allowsActions = true
        personVC.displayedPerson = person
        
        // This appears to do nothing :(
        self.masterNav?.setNavigationBarHidden(false, animated: false)
        
        // This works but there is no navigation bar!? WHY?  Please help me :|
        self.masterNav?.showViewController(personVC, sender: nil)
        
        // Does not work!
        //self.masterNav?.view.addSubview(personVC.view)
        //self.masterNav?.addChildViewController(personVC)
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        println("peoplePickerNavigationControllerDidCancel")
    }

    // MARK: - ABPersonViewControllerDelegate
    
    func personViewController(personViewController: ABPersonViewController!, shouldPerformDefaultActionForPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        println("personViewController - shouldPerformDefaultActionForPerson - property - identifier")
        return true
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        println("navigationController: \(navigationController) didShowViewController: \(viewController)")
        println("navigationBar: \(navigationController.navigationBar)")
    }


}

