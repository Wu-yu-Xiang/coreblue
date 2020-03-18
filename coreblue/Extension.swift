//
//  Extension.swift
//  coreblue
//
//  Created by chang on 2020/3/11.
//  Copyright © 2020 chang. All rights reserved.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic {
    
    func getPropertyContent() -> String {
        var propertiesReturn : String = ""
        
        if  (properties.rawValue & CBCharacteristicProperties.broadcast.rawValue) != 0 {
            propertiesReturn += "broadcast|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.read.rawValue) != 0 {
            propertiesReturn += "read|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.writeWithoutResponse.rawValue) != 0 {
            propertiesReturn += "write without response|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.write.rawValue) != 0 {
            propertiesReturn += "write|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.notify.rawValue) != 0 {
            propertiesReturn += "notify|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.indicate.rawValue) != 0 {
            propertiesReturn += "indicate|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.authenticatedSignedWrites.rawValue) != 0 {
                   propertiesReturn += "authenticated signed write|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.extendedProperties.rawValue) != 0 {
            propertiesReturn += "extended properties|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.notifyEncryptionRequired.rawValue) != 0 {
                   propertiesReturn += "notify encryption required|"
        }
        if  (properties.rawValue & CBCharacteristicProperties.indicateEncryptionRequired.rawValue) != 0 {
                   propertiesReturn += "indicate encryption required|"
        }
        return propertiesReturn
    }
}



extension NSData {
    func getByteArray() -> [UInt8]? {
        var byteArray: [UInt8] = [UInt8]()
        for i in 0..<self.length {
            var temp: UInt8 = 0
            self.getBytes(&temp, range: NSRange(location: i, length: 1))
            byteArray.append(temp)
        }
        return byteArray
    }
}

extension Array
where Element: Equatable{
    func intersect(_ other: Array) -> Bool{
        for e in other {
            if contains(where: {$0 == e}){
                return true
            }
        }
        return false
    }
}
