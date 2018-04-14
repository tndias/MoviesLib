//
//  UIViewController+CoreData.swift
//  MoviesLib
//
//  Created by Eric Brito.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
