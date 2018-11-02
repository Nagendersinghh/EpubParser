//
//  Rendition.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 31/07/18.
//
import AEXML

public class Rendition: NSObject {
    var baseUrl: URL?
    var version: Double? = nil
    // This is not the unique identifier for the epub. This is the *id* for the element that
    // contains the unique identifier
    private var uniqueId: String? = nil
    // TODO: Make a struct later
    var direction: String? = nil
    var packageId: String? = nil
    var language: String? = nil
    
    // MetaData
    var metaData: MetaData?
    // Manifest
    public var manifest: Manifest?
    
    // Navigation Doc
    var navigationDoc: EpubResource? = nil
    
    // Spine
    var spine: Spine? = nil
    
    init(rootDirectory: URL, fullPath: String) {
        super.init()
        do {
            let packageUrl = URL(fileURLWithPath: fullPath, relativeTo: rootDirectory)
            self.baseUrl = packageUrl.deletingLastPathComponent()
            var options = AEXMLOptions()
            options.parserSettings.shouldTrimWhitespace = true
            let packageXml = try AEXMLDocument(xml: Data(contentsOf: packageUrl), options: options)
            
            guard packageXml.root.name == "package" else {
                throw EpubParserErrors.invalidOpf
            }
            
            // Fetch all the attributes of the 'package' element
            if let version = packageXml.root.attributes["version"] {
                self.version = Double(version)
            }
            if let uniqueId = packageXml.root.attributes["unique-identifier"] {
                self.uniqueId = uniqueId
            }
            if let dir = packageXml.root.attributes["dir"] {
                self.direction = dir
            }
            if let id = packageXml.root.attributes["id"] {
                self.packageId = id
            }
            if let lang = packageXml.root.attributes["xml:lang"] {
                self.language = lang
            }
            
            // Process MetaData
            // First child MUST be metadata
            let metaData = packageXml.root.children.first
            guard metaData?.name == "metadata" else {
                throw EpubParserErrors.invalidOpf
            }
            self.metaData = parseMetaData(element: metaData!)
            
            // Process manifest, the required second child of package
            let manifest = packageXml.root.children[1]
            
            // We should have a manifest and atleast one item in it.
            guard manifest.name == "manifest" && manifest["item"].count >= 1 else {
                throw EpubParserErrors.invalidOpf
            }
            self.manifest = Manifest(element: manifest, baseUrl: self.baseUrl!)
            
            // Process spine, the required third child of package
            let spine = packageXml.root.children[2]
            
            // At least one item is necessary
            guard spine.name == "spine" && spine["itemref"].count >= 1 else {
                throw EpubParserErrors.invalidOpf
            }
            self.spine = parseSpine(element: spine)
            self.navigationDoc = self.manifest?.navigationDoc
        } catch {
            print("\(error)")
        }
    }
    
    func parseMetaData(element: AEXMLElement) -> MetaData {
        let metaData = MetaData()
        // Get the unique identifier
        if let uniqueIds = element["dc:identifier"].all {
            for uniqueId in uniqueIds {
                if let value = uniqueId.value {
                    metaData.uniqueIds.append(value)
                }
            }
        }
        
        if let titles = element["dc:title"].all {
            for title in titles {
                if let value = title.value {
                    metaData.titles.append(value)
                }
            }
        }
        
        if let languages = element["dc:language"].all {
            for lang in languages {
                if let value = lang.value {
                    metaData.languages.append(value)
                }
            }
        }
        
        if let creators = element["dc:creator"].all {
            for creator in creators {
                if let value = creator.value {
                    metaData.creators?.append(value)
                }
            }
        }
        
        if let contributors = element["dc:contributor"].all {
            for contributor in contributors {
                if let value = contributor.value {
                    metaData.contributors?.append(value)
                }
            }
        }
        
        if let subjects = element["dc:subject"].all {
            for subject in subjects {
                if let value = subject.value {
                    metaData.subjects?.append(value)
                }
            }
        }
        
        if let description = element["dc:description"].value {
            metaData.description = description
        }
        
        
        // Meta elements
        if let metaElements = element["meta"].all {
            for meta in metaElements {
                if let property = meta.attributes["property"] {
                    metaData.meta[property] = meta.value
                }
            }
        }
        return metaData
    }
    
    func parseSpine(element: AEXMLElement) -> Spine {
        let spine = Spine()
        spine.id = element.attributes["id"]
        spine.pageProgressionDirection = element.attributes["page-progression-element"]
        
        if let itemRefs = element["itemref"].all {
            for itemRef in itemRefs {
                guard let idRef = itemRef.attributes["idref"] else { continue }
                var linear = true
                if let _linear = itemRef.attributes["linear"] {
                    linear = _linear == "yes" ? true : false
                }
                
                if let resource = self.manifest!.find(byId: idRef) {
                    spine.itemRefs.append(SpineItem(resource: resource, linear: linear))
                }
            }
        }
        return spine
    }
    
    // Manifest fallback chains
    // Collections
}
