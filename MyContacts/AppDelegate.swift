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
    let splitViewController = UISplitViewController()
//    var masterNav: UINavigationController?
    
    // MARK: - UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let peoplePicker = ABPeoplePickerNavigationController()
        peoplePicker.peoplePickerDelegate = self
        splitViewController.viewControllers = [peoplePicker]
        self.window?.rootViewController = splitViewController
        self.window?.makeKeyAndVisible()
        return true
    }
    
//    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
//        return true
//    }
    
    // MARK: - ABPeoplePickerNavigationControllerDelegate
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        let personVC = ABPersonViewController()
        personVC.personViewDelegate = self
        personVC.allowsEditing = true
        personVC.allowsActions = true
        personVC.displayedPerson = person

        splitViewController.showDetailViewController(personVC, sender: nil)
        
//        splitViewController.viewControllers = [splitViewController.viewControllers[0], personVC]
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

