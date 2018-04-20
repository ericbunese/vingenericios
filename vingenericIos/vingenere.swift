//
//  vingenere.swift
//  vingeneric
//
//  Created by Eric Bunese on 18/04/2018.
//  Copyright © 2018 Eric Bunese. All rights reserved.
//

import Foundation

class Vingenere {
  var text: String = ""
  var key: String = ""
  var cypher: String = ""
  
  let const = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2, 3, 8, 4, 6, 2, 6, 4, 3, 3, 8, 3, 2, 7, 9, 5, 0, 2, 8, 8, 4, 1, 9, 7, 1, 6, 9, 3, 9, 9, 3, 7, 5, 1, 0, 5, 8, 2, 0, 9, 7, 4, 9, 4, 4, 5, 9, 2, 3, 0, 7, 8, 1, 6, 4, 0, 6, 2, 8, 6, 2, 0, 8, 9, 9, 8, 6, 2, 8, 0, 3, 4, 8, 2, 5, 3, 4, 2, 1, 1, 7, 0, 6, 7, 9, 8, 2, 1, 4, 8, 0, 8, 6, 5, 1, 3, 2, 8, 2, 3, 0, 6, 6, 4, 7, 0, 9, 3, 8, 4, 4, 6, 0, 9, 5, 5, 0, 5, 8, 2, 2, 3, 1, 7, 2, 5, 3, 5, 9, 4, 0, 8, 1, 2, 8, 4, 8, 1, 1, 1, 7, 4, 5, 0, 2, 8, 4, 1, 0, 2, 7, 0, 1, 9, 3, 8, 5, 2, 1, 1, 0, 5, 5, 5, 9, 6, 4, 4, 6, 2, 2, 9, 4, 8, 9, 5, 4, 9, 3, 0, 3, 8, 1, 9, 6, 4, 4, 2, 8, 8, 1, 0, 9, 7, 5, 6, 6, 5, 9, 3, 3, 4, 4, 6, 1, 2, 8, 4, 7, 5, 6, 4, 8, 2, 3, 3, 7, 8, 6, 7, 8, 3, 1, 6, 5, 2, 7, 1, 2, 0, 1, 9, 0, 9, 1]
  private var alphabet: [String: [String]] = [:]
  
  init(){
    self.initAlphabet()
  }
  
  func encode(prod: Int) -> String{
    var str: String = ""
    var pos: Int = 0
    let igl = self.alphabet[""]
    
    for c in self.text {
      let k = self.key[self.key.index(self.key.startIndex, offsetBy: (pos % self.key.count))]
      if let alf = self.alphabet["\(k)"]{
        let off = self.const[(prod+pos) % self.const.count]
        if let chr = alf.index(of: "\(c)"){
          str += igl![(chr+off) % (igl?.count)!]
        }
      }
      pos = pos+1
    }
    
    self.cypher = str
    return str
  }
  
  func decode(prod: Int) -> String {
    var str: String = ""
    var pos: Int = 0
    let igl = self.alphabet[""]
    
    for c in self.cypher{
      let k = self.key[self.key.index(self.key.startIndex, offsetBy: (pos % self.key.count))]
      if let alf = self.alphabet["\(k)"]{
        let off = self.const[(prod+pos) % self.const.count]
        let chr = igl?.index(of: "\(c)")
        str += alf[self.modulo(val: (chr!-off), low: 0, upp: alf.count)]
      }
      pos = pos+1
    }
    
    return str
  }
  
  private func modulo(val: Int, low: Int, upp: Int) -> Int{
    var v: Double = 0.0
    let o = Double(low)
    let d = Double(val)-Double(o)
    let w = Double(upp)-Double(o)
  
    v = d-floor(d/w)*w+o
  
    return Int(v)
  }
  
  private func initAlphabet(){
    var alf = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", " ", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "Ã", "Â", "Á", "À", "Ê", "É", "È", "Î", "Í", "Ì", "Õ", "Ô", "Ó", "Ò", "Û", "Ú", "Ù", ".", ",", ":", ";", "!", "?", "@", "#", "$", "%", "&", "*", "(", ")", "-", "+", "=", "_", "/", "\\", "\"", "´", "`", "ˆ", "~", "[", "{", "]", "}", "<", ">", "ã", "â", "á", "à", "ê", "é", "è", "î", "í", "ì", "õ", "ô", "ó", "ò", "û", "ú", "ù", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "ç", "Ç"]
    let emojiRanges = [
      0x1F601...0x1F64F,
      0x2702...0x27B0,
      0x1F680...0x1F6C0,
      0x1F170...0x1F251
    ]

    for range in emojiRanges {
        for i in range {
          let c = String(UnicodeScalar(i)!)
            alf.append(c)
        }
    }
    let igl = alf
    self.alphabet[""] = igl
    
    for c in igl{
      let pop = alf.remove(at: 0)
      alf.append(pop)
      self.alphabet["\(c)"] = alf
    }
  }
}
