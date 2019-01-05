///**
/**
FMDB_Example
ViewController.swift
Created by: KOMAL BADHE on 04/01/19
Copyright (c) 2019 KOMAL BADHE
*/

import UIKit

class ViewController: UIViewController,UITableViewDataSource , UITableViewDelegate{

    @IBOutlet var popupView: UIView!
    var popup_view = UIView();
    var arr_employees = NSMutableArray();
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var tableViewObj: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        arr_employees =  DBManager.shared.fetchAllEmployees();
      
        popup_view.frame = self.view.frame;
        popup_view.backgroundColor = UIColor.black.withAlphaComponent(0.7);
        loadExternalXib();
    }
    @objc func btn_add_new_action() {
        
        dismissKeyBoardAction();
        if validateData() {
            let response_dict =  DBManager.shared.insertData(employee_name:txtName.text ?? "", employee_code:txtCode.text!);
            print(response_dict);
            
            showAlert(message: response_dict.value(forKey: "message") as! String,viewController: self);
            popupView.removeFromSuperview();
            popup_view.removeFromSuperview();
        }
  
    }
    
    @IBAction func btn_cancel_action(_ sender: Any) {
        popupView.removeFromSuperview();
        popup_view.removeFromSuperview();
    }
    
    func loadExternalXib()  {
        tableViewObj.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "employee_cell_id");
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_employees.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let EmployeeTableViewCellObj = tableView.dequeueReusableCell(withIdentifier: "employee_cell_id") as! EmployeeTableViewCell;
        
        EmployeeTableViewCellObj.btn_edit.tag = indexPath.row;
        EmployeeTableViewCellObj.btn_delete.tag = indexPath.row;
        
        EmployeeTableViewCellObj.btn_delete.addTarget(self, action: #selector(action_delete_employee(sender:)), for: .touchUpInside);
        
        EmployeeTableViewCellObj.btn_edit.addTarget(self, action: #selector(btn_edit_employee(sender:)), for: .touchUpInside);
        
        EmployeeTableViewCellObj.intialize_cell(emp_details: arr_employees.object(at: indexPath.row) as! NSDictionary);
        return EmployeeTableViewCellObj;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 125;
    }
    
    @IBAction func btn_add_new(_ sender: Any) {
        txtName.text = "";
        txtCode.text = "";
        
        btn_save.addTarget(self, action: #selector(btn_add_new_action), for: .touchUpInside);
        popupView.frame = CGRect(x: (self.view.frame.size.width/2)-150  , y: (self.view.frame.size.height/2)-75, width: 300, height: 150)
        popup_view.addSubview(popupView);
        self.view.addSubview(popup_view);
        
    }
    
    @objc func dismissKeyBoardAction() {
        self.view.endEditing(true);
    }
    
    // MARK: - textfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtName {
            txtName.resignFirstResponder();
            txtCode.becomeFirstResponder()
        }
        else if textField == txtCode{
            txtCode.resignFirstResponder();
        }
        return true;
    }

    
    
    func validateData() -> Bool {
        
        if txtName.text?.trimmingCharacters(in: .whitespaces).count != 0 {
            
            if txtCode.text?.trimmingCharacters(in: .whitespaces).count != 0 {
                
                return true;
            }
            else{
                showAlert(message: "Please enter  employee code.",viewController: self);
                return false
            }
            
        }
        else{
            showAlert(message: "Please enter employee name.",viewController: self);
            return false
        }
        
    }
    
    @IBAction func btn_edit_employee(sender: UIButton) {
        var response_dict  = NSDictionary();
        response_dict = DBManager.shared.get_employee_details(id: (arr_employees.object(at: sender.tag) as! NSDictionary).value(forKey: "employee_id") as! String );

        txtName.text = response_dict.value(forKey: "employee_name") as? String;
        txtCode.text = response_dict.value(forKey: "employee_code") as? String;
        txtCode.isUserInteractionEnabled = false;
        btn_save.tag = sender.tag;
        btn_save.addTarget(self, action: #selector(edit_employee(sender:)), for: .touchUpInside);
        popupView.frame = CGRect(x: (self.view.frame.size.width/2)-150  , y: (self.view.frame.size.height/2)-75, width: 300, height: 150)
        popup_view.addSubview(popupView);
        self.view.addSubview(popup_view);
    }
    
    @IBAction func edit_employee(sender: UIButton)  {
        
        let id =  (arr_employees.object(at: sender.tag) as! NSDictionary).value(forKey: "employee_id") as! String ;
        
        dismissKeyBoardAction();
        if validateData() {
            let response_dict =  DBManager.shared.update_employee(emp_details: ["employee_name":txtName.text ?? "" , "employee_code":txtCode.text!,"employee_id":id]);
            showAlert(message: response_dict.value(forKey: "message") as! String, viewController: self);
            arr_employees =  DBManager.shared.fetchAllEmployees();
            tableViewObj.reloadData();
            popupView.removeFromSuperview();
            popup_view.removeFromSuperview();
        }
        
        
        
        
    }
    @IBAction func action_delete_employee(sender: UIButton) {
      
        var response_dict  = NSDictionary();
        response_dict = DBManager.shared.deleteRecord(id: (arr_employees.object(at: sender.tag) as! NSDictionary).value(forKey: "employee_id") as! String );
        showAlert(message: response_dict.value(forKey: "message") as! String, viewController: self);
       arr_employees =  DBManager.shared.fetchAllEmployees();
        tableViewObj.reloadData();
        
    }
}

