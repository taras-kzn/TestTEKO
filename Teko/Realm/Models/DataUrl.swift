//
//  DataUrl.swift
//  Teko
//
//  Created by admin on 25.08.2021.
//

import Foundation
import RealmSwift
import UIKit

public class DataUrl: Decodable {
    let data: [Gifs]
}

public class Gifs: Object, Decodable {

//MARK: - Propeties
    @objc dynamic var urlGifs = ""
    @objc dynamic var webpGifs = ""
    @objc dynamic var widthGifs = ""
    @objc dynamic var heightGifs = ""
    
    public override class func primaryKey() -> String? {
        return "urlGifs"
    }
    
//MARK: - Enum
    private enum CodingKeys: String, CodingKey {
        case images
    }

    private enum ImagesKey: String, CodingKey {
        case fixed_width
    }

    private enum NamfixedWidtheKey: String, CodingKey {
        case height
        case width
        case url
        case webp
    }
//MARK: - init
    convenience required public init(from decoder: Decoder) throws {
        self.init()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        let imageValue = try values.nestedContainer(keyedBy: ImagesKey.self, forKey: .images)
        let fixedWidthValue = try imageValue.nestedContainer(keyedBy: NamfixedWidtheKey.self, forKey: .fixed_width)
        self.urlGifs = try fixedWidthValue.decode(String.self, forKey: .url)
        self.webpGifs = try fixedWidthValue.decode(String.self, forKey: .webp)
        self.widthGifs = try fixedWidthValue.decode(String.self, forKey: .width)
        self.heightGifs = try fixedWidthValue.decode(String.self, forKey: .height)
    }
    
}
//MARK: Extension and functions
extension Gifs {

    static func all(in realm: Realm = try! Realm()) -> Results<Gifs> {
      return realm.objects(Gifs.self)
    }
    
    @discardableResult
    static func add(gifs: [Gifs], in realm: Realm = try! Realm())
      -> [Gifs] {
        try! realm.write {
          realm.add(gifs)
        }
        return gifs
    }
    
    func delete() {
      guard let realm = realm else { return }
      try! realm.write {
        realm.delete(self)
      }
    }
}
