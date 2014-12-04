//
//  NoteRepository.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-12-02.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation

class NoteRepository {
    
    var notes: [Note] = []
    
    init() {
        notes.append(Note(text: "Buy milk", key: NSUUID().UUIDString))
        notes.append(Note(text: "Call Mike", key: NSUUID().UUIDString))
        notes.append(Note(text: "Walk the dog", key: NSUUID().UUIDString))
        notes.append(Note(text: "Push the code", key: NSUUID().UUIDString))
        notes.append(Note(text: "Make coffee", key: NSUUID().UUIDString))
        notes.append(Note(text: "Cut the lawn", key: NSUUID().UUIDString))
        notes.append(Note(text: "Paint the living room", key: NSUUID().UUIDString))
    }

    func findAll() -> [Note] {
        return notes
    }
    
    func getNoteByKey(key: String) -> Note? {
        for n: Note in notes {
            if n.key == key {
                return n
            }
        }
        return nil
    }
    
    func save(note: Note) {
        log.debug("Saving note " + note.description)
        if note.key == nil {
            // New note
            note.key = NSUUID().UUIDString
            notes.append(note)
        } else {
            // Update note
            
        }
    }
    
    func delete(note: Note) {
        for (index, n) in enumerate(notes) {
            if n.key == note.key {
                notes.removeAtIndex(index)
            }
        }
    }

}
