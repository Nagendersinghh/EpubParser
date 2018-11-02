//
//  Epub.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/01/18.
//

import Foundation
import AEXML

public class Epub {
    public var name: String?
    public var container: Container?
    fileprivate var signatures: Signatures?
    fileprivate var encryption: Encryption?
    fileprivate var packageMetaData: PackageMetaData?
    fileprivate var rights: Rights?
    fileprivate var packageManifest: PackageManifest?
    public var renditions: [Rendition] = []
    
    init(rootDirectory: URL) {
        // container.xml [required]: Contains the package documents
        self.container = Container(rootDirectory: rootDirectory)
        for rootFile in (self.container?.rootFiles)! {
            self.renditions.append(Rendition(rootDirectory: rootDirectory, fullPath: rootFile))
        }

        // signatures.xml [optional]
//        self.signatures = Signatures(rootDirectory: rootDirectory)
        // encryption.xml [optional]
//        self.encryption = Encryption(rootDirectory: rootDirectory)
        // metadata.xml [optional]
//        self.packageMetaData = PackageMetaData(rootDirectory: rootDirectory)
        // right.xml [optional]
//        self.rights = Rights(rootDirectory: rootDirectory)
        // manifest.xml [optional]
//        self.packageManifest = PackageManifest(rootDirectory: rootDirectory)
    }
}


public class Container: NSObject {
    var version: Double?
    var rootFiles: [String] = []
    
    init(rootDirectory: URL) {
        super.init()

        let containerUrl = rootDirectory.appendingPathComponent("META-INF/container.xml")

        do {
            let containerXml = try AEXMLDocument(xml: Data(contentsOf: containerUrl))
            if let version = containerXml.root.attributes["version"] {
                self.version = Double(version)
            }
            if let rootFiles = containerXml.root["rootfiles"]["rootfile"].all {
                for rootFile in rootFiles {
                    if let fullPath = rootFile.attributes["full-path"] {
                        self.rootFiles.append(fullPath)
                    }
                }
            }

        } catch {
            print("\(error)")
        }
    }

}

private class Signatures: NSObject {
    init(rootDirectory: URL) {
        super.init()
    }
}

private class Encryption: NSObject {
    init(rootDirectory: URL) {
        super.init()
    }
}

private class PackageMetaData: NSObject {
    init(rootDirectory: URL) {
        super.init()
    }
}

private class Rights: NSObject {
    init(rootDirectory: URL) {
        super.init()
    }
}

private class PackageManifest: NSObject {
    init(rootDirectory: URL) {
        super.init()
    }
}
