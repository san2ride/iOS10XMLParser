//
//  TableViewController.swift
//  XMLParser
//
//  Created by don't touch me on 10/25/16.
//  Copyright © 2016 trvl, LLC. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {
    
    var books: [Book] = []
    var eName: String = String()
    var bookTitle = String()
    var bookAuthor = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = Bundle.main.url(forResource: "books", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let book = books[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = book.bookTitle
        cell.detailTextLabel?.text = book.bookAuthor

        return cell
    }
    
    //1 this method is sent by the parser object when the start tag of "<book>" is encountered
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        eName = elementName
        if elementName == "book" {
            bookTitle = String()
            bookAuthor = String()
        }
    }
    //2 this method is sent by the parser object when the end tag of "</book>" is encountered
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "book" {
            
            let book = Book()
            book.bookTitle = bookTitle
            book.bookAuthor = bookAuthor
            
            books.append(book)
        }
    }
    //3 here the actual parsing is executed
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if(!data.isEmpty) {
            if eName == "title" {
                bookTitle += data
            } else if eName == "author" {
                bookAuthor += data
            }
        }
    }

}
