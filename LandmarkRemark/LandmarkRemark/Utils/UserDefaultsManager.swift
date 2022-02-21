//
//  UserDefaultsManager.swift
//  LandmarkRemark
//
//  Created by Sanduni Perera on 20/2/22.
//  Copyright © 2022 Sanduni Perera. All rights reserved.
//

import Foundation

struct UserDefaultsKey {
    static let userName = "userName"
}

class UserDefaultsManager{
    
    static func set(value val:Any?, for key:String){
        guard let val = val else {return}
        UserDefaults.standard.set(val, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getValue(forKey key:String) -> Any?{
        return UserDefaults.standard.value(forKey:key)
    }
    
    static func setUserName(userName:String){
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: userName, requiringSecureCoding: false) as Data else { fatalError("Can't encode data") }
        set(value: data, for: UserDefaultsKey.userName)
    }
    
    static func getUserName() -> String{
        let value = UserDefaultsManager.getValue(forKey: UserDefaultsKey.userName)
        let data = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(value as? Data ?? Data()) as! String
        return data!
    }
}
