//
//  MetaData.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/07/18.
//

import Foundation

class MetaData {
    var uniqueIds: [String] = []
    // There can be more than one titles, with the first one to be
    // considered as the primary title.
    var titles: [String] = []
    var languages: [String] = []
    
    // Optional elements
    var creators: [String]? = []
    var contributors: [String]? = []
    var date: String? = nil
    var subjects: [String]? = []
    var types: [String]? = []
    var description: String = ""
    // TODO: Description
    
    // Meta
    var meta: [String: String] = [:]
    
    // The release identifier can uniquely identify any
    // EPUB pulication (if it exists, that is)
    var releaseIdentifier: String? {
        get {
                if let uId = uniqueIds.first, let lastModified = meta["dc:modified"] {
                // The standard mandates that we use @ as the separator, however,
                // uId itself may contain @. So, to parse the identifier, split on
                // the last @.
                return "\(uId)@\(lastModified)"
            }
            return nil
        }
    }
    
    var isFixedLayout: Bool {
        get { return self.meta["rendition:layout"] == "pre-paginated" }
    }

    func find(byId: String) -> EpubResource? {
        return nil
    }
}
