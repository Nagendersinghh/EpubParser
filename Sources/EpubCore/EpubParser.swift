//
//  EpubParser.swift
//  EpubParser
//
//  Created by nagender singh shekhawat on 26/01/18.
//

import Foundation
import Zip
import SWXMLHash

public class EpubParser {
    var tempDir = NSTemporaryDirectory()
    public typealias completion = (Epub?, Error?) -> Void
    let atCompletion: completion

    public init(source: URL, atCompletion: @escaping completion) {
        self.atCompletion = atCompletion
        Zip.addCustomFileExtension("epub")
        parseEpub(atPath: source, to: URL(string: tempDir)!)
    }

    private func parseEpub(atPath: URL, to: URL) {
        let rootDirectory = to
        let fileName = atPath.lastPathComponent
        // let shouldUnzip = !FileManager.default.isDirectory(atPath: atPath)
        
        do {
            try Zip.unzipFile(atPath, destination: rootDirectory, overwrite: true, password: nil)
        } catch {
            // Could not unzip the file, send invalid book error
            print("Invalid epub")
            return
        }
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
