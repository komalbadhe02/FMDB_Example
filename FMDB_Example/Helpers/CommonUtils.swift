///**
/**
FMDB_Example
CommonUtils.swift
Created by: KOMAL BADHE on 04/01/19
Copyright (c) 2019 KOMAL BADHE
*/

import Foundation
import UIKit
func showAlert(message : String,viewController : UIViewController) {
    let alert = UIAlertController(title: "",
                                  message: message,
                                  preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    viewController.present(alert, animated: true, completion: nil)
}
