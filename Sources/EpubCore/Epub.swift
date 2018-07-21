//
//  Epub.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/01/18.
//

import Foundation

public class Epub {
    public var name: String?
    public var container: Container?
    fileprivate var signatures: Signatures?
    fileprivate var encryption: Encryption?
    fileprivate var packageMetaData: PackageMetaData?
    fileprivate var rights: Rights?
    fileprivate var packageManifest: PackageManifest?
    fileprivate let renditions: [Rendition]? = nil
    
    init(rootDirectory: URL) {
        // container.xml [required]: Contains the package documents
        self.container = Container(rootDirectory: rootDirectory)

        // signatures.xml [optional]
        self.signatures = Signatures(rootDirectory: rootDirectory)
        // encryption.xml [optional]
        self.encryption = Encryption(rootDirectory: rootDirectory)
        // metadata.xml [optional]
        self.packageMetaData = PackageMetaData(rootDirectory: rootDirectory)
        // right.xml [optional]
        self.rights = Rights(rootDirectory: rootDirectory)
        // manifest.xml [optional]
        self.packageManifest = PackageManifest(rootDirectory: rootDirectory)
    }
}

private class Rendition: NSObject, XMLParserDelegate {
    var packageParser: XMLParser? = nil

    init(path: String) {
        super.init()
        if let packageUrl = URL(string: path) {
            if let packageParser = XMLParser(contentsOf: packageUrl) {
                self.packageParser = packageParser
                self.packageParser?.delegate = self
                self.packageParser?.shouldProcessNamespaces = true
                self.packageParser?.shouldReportNamespacePrefixes = true
                self.packageParser?.shouldResolveExternalEntities = true
                self.packageParser?.parse()
            }
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {

    }

    func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {

    }

    func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String) {

    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {

    }
    // Metadata
    // Manifest
    // Spine
    // Navigation Document
    // Manifest fallback chains
}

public class Container: NSObject, XMLParserDelegate {
    var version: Int?
    var rootFile: String?
    var rootFiles: [String]?
    
    init(rootDirectory: URL) {
        super.init()
        if let containerParser = XMLParser(contentsOf: URL(fileURLWithPath: "/META-INF/container.xml", relativeTo: rootDirectory)) {
             containerParser.delegate = self
             containerParser.parse()
        }
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("container", elementName, namespaceURI, qName, attributeDict)
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("container", elementName, namespaceURI, qName)
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
    
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("error", parseError)
    }
}

private class Signatures: NSObject, XMLParserDelegate {
    init(rootDirectory: URL) {
        super.init()
        if let signatureParser = XMLParser(contentsOf: URL(fileURLWithPath: "/META-INF/signatures.xml", relativeTo: rootDirectory)) {
            signatureParser.delegate = self
            signatureParser.parse()
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print(elementName, namespaceURI, qName, attributeDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName, namespaceURI, qName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
}

private class Encryption: NSObject, XMLParserDelegate {
    init(rootDirectory: URL) {
        super.init()
        if let encryptionParser = XMLParser(contentsOf: URL(fileURLWithPath: "/META-INF/encryption.xml", relativeTo: rootDirectory)) {
            encryptionParser.delegate = self
            encryptionParser.parse()
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print(elementName, namespaceURI, qName, attributeDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName, namespaceURI, qName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
}

private class PackageMetaData: NSObject, XMLParserDelegate {
    init(rootDirectory: URL) {
        super.init()
        if let packageMetaDataParser = XMLParser(contentsOf: URL(fileURLWithPath: "/META-INF/metadata.xml", relativeTo: rootDirectory)) {
            packageMetaDataParser.delegate = self
            packageMetaDataParser.parse()
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print(elementName, namespaceURI, qName, attributeDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName, namespaceURI, qName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
}

private class Rights: NSObject, XMLParserDelegate {
    init(rootDirectory: URL) {
        super.init()
        if let rightsParser = XMLParser(contentsOf: URL(fileURLWithPath: "/META-INF/rights.xml", relativeTo: rootDirectory)) {
            rightsParser.delegate = self
            rightsParser.parse()
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print(elementName, namespaceURI, qName, attributeDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName, namespaceURI, qName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
}

private class PackageManifest: NSObject, XMLParserDelegate {
    init(rootDirectory: URL) {
        super.init()
        if let packageManifestParser = XMLParser(contentsOf: URL(fileURLWithPath: "/META-INF/manifest.xml", relativeTo: rootDirectory)) {
            packageManifestParser.delegate = self
            packageManifestParser.parse()
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print(elementName, namespaceURI, qName, attributeDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName, namespaceURI, qName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
}
