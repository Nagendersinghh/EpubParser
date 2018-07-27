//
//  EpubParser.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/01/18.
//

import Foundation
import Zip

public class EpubParser {
    public typealias completion = (Epub?, Error?) -> Void
    let atCompletion: completion
    let rootDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
    let source: URL

    public init(source: URL, atCompletion: @escaping completion) {
        self.atCompletion = atCompletion
        self.source = source
        Zip.addCustomFileExtension("epub")
        self.unzipEpub(atPath: source, to: rootDirectory)
    }
    
    private func unzipEpub(atPath: URL, to: URL) {
        do {
            try Zip.unzipFile(atPath, destination: rootDirectory, overwrite: true, password: nil)
        } catch {
            // Could not unzip the file, send invalid book error
            print("Invalid epub")
            return
        }
    }

    public func parseEpub() {
        // Check the contents of the `mimetype` file.
        if let mimeType = try? String(contentsOf: rootDirectory.appendingPathComponent("mimetype"), encoding: String.Encoding.ascii) {
            guard mimeType == "application/epub+zip" else {
                self.atCompletion(nil, EpubParserErrors.invalidMimeType)
                return
            }
        }

        let book = Epub(rootDirectory: rootDirectory)
        self.atCompletion(book, nil)
    }
}
