//
//  Spine.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/07/18.
//

import AEXML

struct SpineItem {
    var linear: Bool
    var resource: EpubResource

    init(resource: EpubResource, linear: Bool = true) {
        self.linear = linear
        self.resource = resource
    }
    // TODO: Decide on an api to provide layout information.
}

class Spine {
    var id: String?
    // TODO: Make an enum
    var pageProgressionDirection: String?
    var itemRefs = [SpineItem]()

}
