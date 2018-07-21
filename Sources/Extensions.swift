//
//  Extensions.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/01/18.
//

import Foundation

extension FileManager {
    func isDirectory(atPath: URL) -> Bool {
        var objcIsDir: ObjCBool = ObjCBool(false)
        fileExists(atPath: atPath.absoluteString, isDirectory: &objcIsDir)
        return objcIsDir.boolValue
    }
}
