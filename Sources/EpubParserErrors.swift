//
//  EpubParserErrors.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/01/18.
//

import Foundation

public enum EpubParserErrors: Error {
    case bookNotFound
    case invalidContainer
    case invalidOpf
    case invalidMimeType

    public var errorDescription: String? {
        switch self {
        case .bookNotFound:
            return "Book Not Found"
        case .invalidContainer:
            return "Invalid Container"
        case .invalidOpf:
            return "Invalid Opf"
        case .invalidMimeType:
            return "Invalid mimetype file"
        }
    }
}
