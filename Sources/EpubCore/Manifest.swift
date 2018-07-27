//
//  Manifest.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/07/18.
//

import AEXML

public class Manifest {
    public var items = [EpubResource]()
    var coverImage: EpubResource?
    var navigationDoc: EpubResource?
    
    init(element manifest: AEXMLElement, baseUrl: URL) {
        if let items = manifest["item"].all {
            for item in items {
                let attributes = item.attributes
                
                let resource = EpubResource()
                resource.id = attributes["id"]
                resource.href = attributes["href"]
                resource.baseUrl = baseUrl
                if let duration = attributes["duration"] {
                    resource.duration = Double(duration)
                }
                resource.fallback = attributes["fallback"]
                resource.mediaType = attributes["media-type"]
                resource.mediaOverlay = attributes["media-overlay"]
                
                if let properties = attributes["properties"] {
                    // properties is a space separated list of values
                    let vocab = properties.components(separatedBy: .whitespaces)
                    resource.properties = vocab
                }
                
                // Check if the current resource is a navigation document or the cover image
                if self.coverImage == nil, let properties = resource.properties, properties.contains("cover-image") {
                    self.coverImage = resource
                }
                
                if self.navigationDoc == nil, let properties = resource.properties, properties.contains("nav") {
                    self.navigationDoc = resource
                }
                self.items.append(resource)
            }
        }
    }
    
    func find(byId: String) -> EpubResource? {
        return items.first { $0.id == byId }
    }
}
