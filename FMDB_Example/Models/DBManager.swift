///**
/**
FMDB_Example
DBManager.swift
Created by: KOMAL BADHE on 04/01/19
Copyright (c) 2019 KOMAL BADHE
*/

import Foundation

import UIKit
class DBManager: NSObject {
    static let shared: DBManager  = DBManager()
    let databaseFileName = "database.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    override init() {
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    func createDatabase() -> Bool {
        var created = false
        
        print(FileManager.default.fileExists(atPath: pathToDatabase))
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    let createEntityTableQuery = "create table employees (employee_id integer primary key  autoincrement not null, employee_name text not null, employee_code text not null)"
                    do {
                        try database.executeUpdate(createEntityTableQuery, values: nil)
                        created = true
                        
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        return created
    }
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    
    
    func fetchAllEmployees() -> NSMutableArray {
        
        let arr_employees = NSMutableArray();
        if openDatabase() {
             let query = "select * from employees";
            
            do{
                
                let results = try database.executeQuery(query, values: nil)
                var employee_details = NSDictionary();
                while results.next(){
                    
                    employee_details = ["employee_id" : results.string(forColumn: "employee_id"),"employee_name" : results.string(forColumn: "employee_name"),"employee_code" : results.string(forColumn: "employee_code") ];
                    
                    arr_employees.add(employee_details);
                    
                }
               
                
            }
            catch{
                print(error.localizedDescription)
            }
            
            database.close();
        }
        return arr_employees;
    }

    
    func insertData(employee_name : String , employee_code : String )->NSDictionary {
        var response_dict = NSDictionary();
        
        if openDatabase() {
            let entityTableQuery = "insert into employees (employee_id,employee_name,employee_code) values (null,'\(employee_name)','\(employee_code)')"
            
                if !database.executeStatements(entityTableQuery) {
                    response_dict = ["status_code": "400","message":"Failed to insert initial data into the database."];
                }
                else{
                     response_dict = ["status_code": "200","message":"Query executed successfully"];
                    print("Query executed successfully");
                }
                database.close()
        }
        
        return response_dict;
    }
    
    func deleteRecord(id : String)-> NSDictionary{
        var response_dict = NSDictionary();
        
             if openDatabase() {
                let deleteEntityQuery = "delete from employees where employee_id = \(id)";
    
                do {
                    try database.executeUpdate(deleteEntityQuery, values: nil)
                    response_dict = ["status_code": "200","message":"deleted successfully"];
                }
                catch{
                     response_dict = ["status_code": "400","message":error.localizedDescription];
                   
                }
    
                database.close();
            }
    
    
        return response_dict;
        }

    func get_employee_details(id : String) -> NSDictionary {
        var employee_details = NSDictionary();

        if openDatabase() {
            let query = "select * from employees where employee_id = \(id)";
            
            do{
                
                let results = try database.executeQuery(query, values: nil)
                while results.next(){
                    
                    employee_details = ["employee_id" : results.string(forColumn: "employee_id"),"employee_name" : results.string(forColumn: "employee_name"),"employee_code" : results.string(forColumn: "employee_code") ];
                    
                }
                
            }
            catch{
                print(error.localizedDescription)
               
            }
            
            database.close();
        }
        return employee_details;
    }
    
    
    func update_employee(emp_details : NSDictionary) -> NSDictionary {
        var response_dict = NSDictionary();
        let emp_name  = emp_details.value(forKey: "employee_name") as! String;
        let emp_id  = emp_details.value(forKey: "employee_id")as! String;
        
        if openDatabase() {
            
           
            let updateEntityQuery = "update employees set employee_name=? where employee_id=?";
            
            do {
                try database.executeUpdate(updateEntityQuery, values: [emp_name, emp_id]);
                response_dict = ["status_code": "200","message":"Updated successfully"];
            }
            catch{
                response_dict = ["status_code": "400","message":error.localizedDescription];
                
            }
            
            database.close();
        }
        return response_dict;
    }
    
    
}




