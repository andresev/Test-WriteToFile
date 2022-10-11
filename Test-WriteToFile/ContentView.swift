//
//  ContentView.swift
//  Test-WriteToFile
//
//  Created by Andres Valdez on 10/5/22.
//

import SwiftUI

var fileNum = 0

class LogFileView: ObservableObject {
    @Published var logArr: [Int] = []
    
    func getFileNum() -> Int {
        return fileNum
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return paths
    }
    
    func createAndWriteToFile() -> Void {
        logArr.append(logArr.count)

        let str = "ID: 12345-\(fileNum)"
        let url = self.getDocumentsDirectory().appendingPathComponent("log-\(fileNum).txt") // File to be created and written

        do {
            print("Write to new File:")
            try str.write(to: url, atomically: true, encoding: .utf8)
            let input = try String(contentsOf: url)
            print(input)
            fileNum += 1

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readFile() -> Void {
        print("Reading File:")
        let url = self.getDocumentsDirectory().appendingPathComponent("log-1.txt") // File to read

        do {
            // Get the saved data
            let savedData = try Data(contentsOf: url)
            // Convert the data back into a string
            if let savedString = String(data: savedData, encoding: .utf8) {
                print(savedString)
            }
        } catch {
            // Catch any errors
            print(error, "Unable to read file")
        }
    }
    
    func writeToExistingFile() -> Void {
        let fileURL = getDocumentsDirectory().appendingPathComponent("log-1.txt") // File to be written with new text/string
        let str = "\nID: New Line Created."
        
        do {
            let handle = try FileHandle(forWritingTo: fileURL)
            //Writes to end of file.
            handle.seekToEndOfFile()
            //Writes content to file.
            handle.write(str.data(using: .utf8)!)
            //close file.
            handle.closeFile()
            print("New content added to file.")
        } catch {
            print(error)
        }
    }
    
    func ReadAllFiles() -> Void {
        do {
            let items = try FileManager.default.contentsOfDirectory(at: self.getDocumentsDirectory(), includingPropertiesForKeys: nil) // Read files in documents directory
            print(items.count)
            for item in items {
                print("Found \(item.lastPathComponent)")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllFiles() -> Void {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: self.getDocumentsDirectory(), includingPropertiesForKeys: nil) // All files to be deleted in folder
            
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
            logArr.removeAll()
            fileNum = 0
            print("All files have been deleted.")
            print(logArr.count)
            print("FileNum: \(fileNum)")
            
        } catch {
            print(error)
        }
    }
    
    func deleteFile() -> Void {
        let file = self.getDocumentsDirectory().appendingPathComponent("log-1.txt") // Single file to be deleted
        
        do {
            try FileManager.default.removeItem(at: file)
            logArr.remove(at: 1)
            print("File 'log-1' has been deleted.")
        } catch {
            print(error)
        }
    }

}

struct ContentView: View {
    @ObservedObject var logView = LogFileView()
    
    var body: some View {
        
        Text("Tap me to Write to File")
            .onTapGesture {
                logView.createAndWriteToFile()
            }
            .frame(width: 200, height: 40)
            .padding(10)
        Text("Read all Files")
            .onTapGesture {
                logView.ReadAllFiles()
            }
            .frame(height: 40)
        Text("Read file")
            .onTapGesture {
                logView.readFile()
            }
            .frame(height: 40)
        
        Text("Delete All Files")
            .onTapGesture {
                logView.deleteAllFiles()
            }
            .frame(height: 40)
        Text("Delete Single File")
            .onTapGesture {
                logView.deleteFile()
            }
        Text("Add text to File")
            .onTapGesture {
                logView.writeToExistingFile()
            }
            .frame(height: 40)
        HStack {
            VStack(alignment: .leading) {
                List {
 
                    ForEach(0..<logView.logArr.count , id: \.self) { log in
                        Text("\(logView.getDocumentsDirectory().appendingPathComponent("log-\(logView.logArr[log])").lastPathComponent)")
                    }
                }
            }
        }
    }
}
