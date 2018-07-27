//
//  EpubResource.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 25/07/18.
//

public class EpubResource: NSObject {
    public var href: String?
    public var baseUrl: URL?
    var id: String?
    // TODO: Make this an enum
    var mediaType: String?
    // This takes a SIMIL clock value which is more involved than double. FIX THIS
    var duration: Double?
    var fallback: String?
    var mediaOverlay: String?
    var properties: [String]?
    
    public var fullHref: URL? {
        get {
            if href != nil {
                if href!.starts(with: "/") {
                    return URL(fileURLWithPath: href!)
                }
                return baseUrl!.appendingPathComponent(href!)
            }
            return nil
        }
    }
}
