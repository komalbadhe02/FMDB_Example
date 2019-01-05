///**
/**
FMDB_Example
EmployeeTableViewCell.swift
Created by: KOMAL BADHE on 04/01/19
Copyright (c) 2019 KOMAL BADHE
*/

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var lbl_empId: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_code: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func intialize_cell(emp_details : NSDictionary)  {
        
        
        let emp_id =  "\(emp_details.value(forKey: "employee_id") as! String)";
        lbl_empId.text = "ID : \(emp_id)" ;
        lbl_name.text = emp_details.value(forKey: "employee_name") as? String;
        lbl_code.text = emp_details.value(forKey: "employee_code") as? String;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
