//
//  StorageManager.swift
//  TaskToDo
//
//  Created by Елисей Мищенко on 27.01.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskToDo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    //MARK: - Public Methods
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        }
        catch let error {
            completion(.failure(error))
        }
    }
    
    //Сохранение данных
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    //Редактирование
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    //Удаление
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
