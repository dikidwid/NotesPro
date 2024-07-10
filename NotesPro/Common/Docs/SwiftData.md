# SwiftData

SwiftData is Apple's modern framework for data persistence in Swift, designed to work seamlessly with SwiftUI. This documentation covers all aspects of SwiftData, providing detailed explanations and examples for each topic.

## Table of Contents

1. [@Model](#model)
2. [Create, Read, Update, Delete (CRUD)](#crud)
3. [@Query](#query)
4. [Relationships](#relationships)
5. [Attribute Modifiers](#attribute-modifiers)
6. [Using SwiftData in ViewModel](#swiftdata-in-viewmodel)
7. [Using SwiftData in Previews](#swiftdata-in-previews)
8. [Injecting Model Context](#injecting-model-context)
9. [Schema Migrations](#schema-migrations)
10. [Sorting and Filtering Data](#sorting-and-filtering)
11. [Transformable Properties](#transformable-properties)
12. [Persistent History Tracking](#persistent-history-tracking)
13. [Implementing Undo and Redo](#undo-and-redo)
14. [Performance Optimization](#performance-optimization)
15. [Error Handling](#error-handling)
16. [Data Encryption](#data-encryption)
17. [Syncing with iCloud](#icloud-sync)
18. [Using SwiftData with Combine](#swiftdata-with-combine)

## 1. @Model

The `@Model` macro is used to define persistent types in SwiftData. It automatically generates the necessary code for persistence, including encoding and decoding.

### Example:

```swift
import SwiftData

@Model
class Person {
    var name: String
    var age: Int
    var birthDate: Date
    
    init(name: String, age: Int, birthDate: Date) {
        self.name = name
        self.age = age
        self.birthDate = birthDate
    }
}
```

In this example, `Person` is defined as a SwiftData model. SwiftData will automatically handle the persistence of its properties.

## 2. Create, Read, Update, Delete (CRUD)

SwiftData provides straightforward methods for performing CRUD operations.

### Create

To create a new instance and save it to the database:

```swift
@Environment(\.modelContext) private var context

func addPerson() {
    let newPerson = Person(name: "John Doe", age: 30, birthDate: Date())
    context.insert(newPerson)
    try? context.save()
}
```

### Read

To fetch data from the database:

```swift
@Query private var people: [Person]

// The @Query property wrapper automatically fetches all Person instances
```

### Update

To update an existing instance:

```swift
func updatePerson(_ person: Person) {
    person.age += 1
    try? context.save()
}
```

### Delete

To delete an instance from the database:

```swift
func deletePerson(_ person: Person) {
    context.delete(person)
    try? context.save()
}
```

## 3. @Query

The `@Query` property wrapper is used to fetch and observe data from SwiftData.

### Basic Usage:

```swift
@Query private var people: [Person]
```

This fetches all `Person` instances from the database.

### Filtering:

```swift
@Query(filter: #Predicate<Person> { $0.age > 18 })
private var adults: [Person]
```

This fetches only `Person` instances where the age is greater than 18.

### Sorting:

```swift
@Query(sort: \Person.name)
private var peopleSortedByName: [Person]
```

This fetches all `Person` instances, sorted by name.

### Combining Filtering and Sorting:

```swift
@Query(filter: #Predicate<Person> { $0.age > 18 }, sort: \Person.name)
private var adultsSortedByName: [Person]
```

This fetches `Person` instances where age is greater than 18, sorted by name.

## 4. Relationships

SwiftData supports various types of relationships between models.

### One-to-Many Relationship:

```swift
@Model
class Department {
    var name: String
    @Relationship(deleteRule: .cascade) var employees: [Employee]
}

@Model
class Employee {
    var name: String
    @Relationship(inverse: \Department.employees) var department: Department?
}
```

In this example, a `Department` can have many `Employee`s, and an `Employee` belongs to one `Department`.

### Many-to-Many Relationship:

```swift
@Model
class Student {
    var name: String
    @Relationship(inverse: \Course.students) var courses: [Course]
}

@Model
class Course {
    var name: String
    @Relationship(inverse: \Student.courses) var students: [Student]
}
```

Here, a `Student` can be enrolled in many `Course`s, and a `Course` can have many `Student`s.

## 5. Attribute Modifiers

SwiftData provides attribute modifiers to customize how properties are persisted.

### @Attribute

The `@Attribute` macro allows you to customize the storage of a property.

```swift
@Model
class Product {
    @Attribute(.unique) var sku: String
    @Attribute(.externalStorage) var image: Data
    @Attribute(.transform(KeyPathTransformer(\Date.timeIntervalSince1970))) var createdAt: Date
}
```

In this example:
- `sku` is marked as unique
- `image` is stored externally (useful for large binary data)
- `createdAt` is transformed to a `TimeInterval` for storage

## 6. Using SwiftData in ViewModel

SwiftData can be used effectively in a ViewModel to separate business logic from views.

```swift
class PersonViewModel: ObservableObject {
    @Published var people: [Person] = []
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        fetchPeople()
    }
    
    func fetchPeople() {
        let descriptor = FetchDescriptor<Person>(sortBy: [SortDescriptor(\.name)])
        people = (try? context.fetch(descriptor)) ?? []
    }
    
    func addPerson(name: String, age: Int) {
        let newPerson = Person(name: name, age: age, birthDate: Date())
        context.insert(newPerson)
        try? context.save()
        fetchPeople()
    }
    
    func deletePerson(_ person: Person) {
        context.delete(person)
        try? context.save()
        fetchPeople()
    }
}
```

## 7. Using SwiftData in Previews

To use SwiftData in SwiftUI previews, you need to create a test configuration:

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Person.self, configurations: config)
        
        let context = container.mainContext
        let testPerson = Person(name: "Test User", age: 25, birthDate: Date())
        context.insert(testPerson)
        
        return ContentView()
            .modelContainer(container)
    }
}
```

This creates an in-memory container for previews and inserts a test person.

## 8. Injecting Model Context

To make the `ModelContext` available throughout your app, you can inject it at the root level:

```swift
@main
struct MyApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Person.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
```

This makes the `ModelContext` available to all views in the app hierarchy.

## 9. Schema Migrations

SwiftData handles most schema changes automatically, but for complex migrations, you can define custom migration steps:

```swift
let schemaV1 = Schema([
    Person.self
])

let schemaV2 = Schema([
    Person.self,
    Department.self
])

let migrationPlan = SchemaMigrationPlan(
    from: schemaV1,
    to: schemaV2,
    migration: { context in
        // Perform custom migration logic here
    }
)

let container = try ModelContainer(
    for: schemaV2,
    migrationPlan: migrationPlan
)
```

## 10. Sorting and Filtering Data

SwiftData provides powerful sorting and filtering capabilities:

```swift
@Query(
    filter: #Predicate<Person> { person in
        person.age > 18 && person.name.contains("John")
    },
    sort: [
        SortDescriptor(\Person.name),
        SortDescriptor(\Person.age, order: .reverse)
    ]
)
private var filteredAndSortedPeople: [Person]
```

This example filters for people over 18 with "John" in their name, sorted by name (ascending) and then by age (descending).

## 11. Transformable Properties

For properties that aren't natively supported by SwiftData, you can use transformable properties:

```swift
struct ComplexData: Codable {
    var value1: Int
    var value2: String
}

@Model
class MyModel {
    @Attribute(.transformable(by: JSONTransformer<ComplexData>())) var complexData: ComplexData
}

struct JSONTransformer<T: Codable>: AttributeTransformer {
    func transform(value: T) throws -> Data {
        try JSONEncoder().encode(value)
    }
    
    func transform(value: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: value)
    }
}
```

This allows you to store complex types by transforming them to and from `Data`.

## 12. Persistent History Tracking

SwiftData supports persistent history tracking, which is useful for syncing or auditing:

```swift
let container = try ModelContainer(
    for: Person.self,
    configurations: ModelConfiguration(historyTracking: .enabled)
)

func fetchHistory() {
    let request = PersistentHistoryTransaction.fetchRequest
    request.predicate = NSPredicate(format: "author == %@", "YourAppName")
    
    let transactions = try? container.mainContext.fetch(request)
    // Process transactions...
}
```

## 13. Implementing Undo and Redo

SwiftData integrates with `UndoManager` to provide undo and redo functionality:

```swift
class UndoableViewModel: ObservableObject {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        context.undoManager = UndoManager()
    }
    
    func addPerson(name: String, age: Int) {
        context.undoManager?.beginUndoGrouping()
        let person = Person(name: name, age: age, birthDate: Date())
        context.insert(person)
        context.undoManager?.endUndoGrouping()
    }
    
    func undo() {
        context.undoManager?.undo()
    }
    
    func redo() {
        context.undoManager?.redo()
    }
}
```

## 14. Performance Optimization

To optimize performance when working with large datasets:

```swift
// Use batch updates
try context.execute(BatchUpdate<Person>(
    predicate: #Predicate { $0.age < 18 },
    properties: [\Person.category: "Minor"]
))

// Use prefetching for relationships
let descriptor = FetchDescriptor<Department>(
    predicate: #Predicate { $0.name == "Engineering" },
    relationshipKeyPathsForPrefetching: [\Department.employees]
)
let departments = try context.fetch(descriptor)
```

## 15. Error Handling

Proper error handling is crucial when working with SwiftData:

```swift
do {
    try context.save()
} catch let error as NSValidationError {
    print("Validation error: \(error.localizedDescription)")
} catch let error as NSManagedObjectConstraintMergeError {
    print("Constraint error: \(error.localizedDescription)")
} catch {
    print("Unexpected error: \(error)")
}
```

## 16. Data Encryption

While SwiftData doesn't provide built-in encryption, you can encrypt sensitive data before storing:

```swift
import CryptoKit

@Model
class SecureNote {
    var title: String
    @Attribute(.transformable(by: EncryptionTransformer())) var encryptedContent: Data
}

struct EncryptionTransformer: AttributeTransformer {
    func transform(value: String) throws -> Data {
        let key = SymmetricKey(size: .bits256)
        return try AES.GCM.seal(value.data(using: .utf8)!, using: key).combined!
    }
    
    func transform(value: Data) throws -> String {
        let key = SymmetricKey(size: .bits256)
        let sealedBox = try AES.GCM.SealedBox(combined: value)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(data: decryptedData, encoding: .utf8)!
    }
}
```

## 17. Syncing with iCloud

To sync SwiftData with iCloud:

```swift
let container = try ModelContainer(
    for: Person.self,
    configurations: ModelConfiguration(cloudKitDatabase: .private)
)
```

This sets up the container to sync with the user's private CloudKit database.

## 18. Using SwiftData with Combine

SwiftData can be used effectively with Combine for reactive programming:

```swift
class PersonViewModel: ObservableObject {
    @Published var people: [Person] = []
    private var context: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(context: ModelContext) {
        self.context = context
        
        let descriptor = FetchDescriptor<Person>()
        context.fetchPublisher(descriptor)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Fetch error: \(error)")
                }
            } receiveValue: { [weak self] fetchedPeople in
                self?.people = fetchedPeople
            }
            .store(in: &cancellables)
    }
}
```

This example uses Combine to reactively update the `people` array whenever the data in SwiftData changes.

# Example SwiftData App

## Version A: No MVVM

```swift
import SwiftUI
import SwiftData

@Model
class Project {
    var name: String
    @Relationship(deleteRule: .cascade) var tasks: [Task] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model
class Task {
    var title: String
    var isCompleted: Bool = false
    var priority: Int
    @Relationship(inverse: \Project.tasks) var project: Project?
    
    init(title: String, priority: Int, project: Project? = nil) {
        self.title = title
        self.priority = priority
        self.project = project
    }
}

@main
struct TaskManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Project.self, Task.self])
    }
}

struct ContentView: View {
    @Query private var projects: [Project]
    @Environment(\.modelContext) private var context
    @State private var showingAddProject = false
    @State private var newProjectName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        Text(project.name)
                    }
                }
                .onDelete(perform: deleteProjects)
            }
            .navigationTitle("Projects")
            .toolbar {
                Button("Add Project") {
                    showingAddProject = true
                }
            }
        }
        .sheet(isPresented: $showingAddProject) {
            VStack {
                TextField("Project Name", text: $newProjectName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add") {
                    addProject()
                    showingAddProject = false
                }
            }
            .padding()
        }
    }
    
    private func addProject() {
        let project = Project(name: newProjectName)
        context.insert(project)
        newProjectName = ""
    }
    
    private func deleteProjects(at offsets: IndexSet) {
        for index in offsets {
            context.delete(projects[index])
        }
    }
}

struct ProjectDetailView: View {
    @Bindable var project: Project
    @Query private var tasks: [Task]
    @Environment(\.modelContext) private var context
    @State private var showingAddTask = false
    @State private var newTaskTitle = ""
    @State private var newTaskPriority = 1
    @State private var sortOrder = [SortDescriptor(\Task.priority, order: .reverse)]
    @State private var filterCompleted = false
    
    var body: some View {
        List {
            Section(header: Text("Tasks")) {
                ForEach(filteredTasks) { task in
                    TaskRow(task: task)
                }
                .onDelete(perform: deleteTasks)
            }
        }
        .navigationTitle(project.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Task") {
                    showingAddTask = true
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Filter & Sort") {
                    Picker("Sort by", selection: $sortOrder) {
                        Text("Priority (High to Low)").tag([SortDescriptor(\Task.priority, order: .reverse)])
                        Text("Priority (Low to High)").tag([SortDescriptor(\Task.priority, order: .forward)])
                    }
                    Toggle("Show Completed", isOn: $filterCompleted)
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            VStack {
                TextField("Task Title", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Stepper("Priority: \(newTaskPriority)", value: $newTaskPriority, in: 1...5)
                Button("Add") {
                    addTask()
                    showingAddTask = false
                }
            }
            .padding()
        }
    }
    
    private var filteredTasks: [Task] {
        tasks
            .filter { $0.project == project }
            .filter { filterCompleted ? true : !$0.isCompleted }
            .sorted(using: sortOrder)
    }
    
    private func addTask() {
        let task = Task(title: newTaskTitle, priority: newTaskPriority, project: project)
        context.insert(task)
        newTaskTitle = ""
        newTaskPriority = 1
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            context.delete(filteredTasks[index])
        }
    }
}

struct TaskRow: View {
    @Bindable var task: Task
    
    var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            Text("Priority: \(task.priority)")
            Toggle("", isOn: $task.isCompleted)
        }
    }
}
```

## Version B: MVVM

```swift
import SwiftUI
import SwiftData
import Combine

@Model
class Project {
    var name: String
    @Relationship(deleteRule: .cascade) var tasks: [Task] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model
class Task {
    var title: String
    var isCompleted: Bool = false
    var priority: Int
    @Relationship(inverse: \Project.tasks) var project: Project?
    
    init(title: String, priority: Int, project: Project? = nil) {
        self.title = title
        self.priority = priority
        self.project = project
    }
}

@main
struct TaskManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Project.self, Task.self])
    }
}

class ProjectListViewModel: ObservableObject {
    @Published var projects: [Project] = []
    private var context: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(context: ModelContext) {
        self.context = context
        fetchProjects()
    }
    
    func fetchProjects() {
        let descriptor = FetchDescriptor<Project>()
        context.fetchPublisher(descriptor)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Fetch error: \(error)")
                }
            } receiveValue: { [weak self] fetchedProjects in
                self?.projects = fetchedProjects
            }
            .store(in: &cancellables)
    }
    
    func addProject(name: String) {
        let project = Project(name: name)
        context.insert(project)
        try? context.save()
    }
    
    func deleteProjects(at offsets: IndexSet) {
        for index in offsets {
            context.delete(projects[index])
        }
        try? context.save()
    }
}

class ProjectDetailViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var sortOrder = [SortDescriptor(\Task.priority, order: .reverse)]
    @Published var filterCompleted = false
    
    private var context: ModelContext
    private var project: Project
    private var cancellables = Set<AnyCancellable>()
    
    init(context: ModelContext, project: Project) {
        self.context = context
        self.project = project
        fetchTasks()
    }
    
    func fetchTasks() {
        let descriptor = FetchDescriptor<Task>(predicate: #Predicate { $0.project == self.project })
        context.fetchPublisher(descriptor)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Fetch error: \(error)")
                }
            } receiveValue: { [weak self] fetchedTasks in
                self?.tasks = fetchedTasks
            }
            .store(in: &cancellables)
    }
    
    var filteredAndSortedTasks: [Task] {
        tasks
            .filter { filterCompleted ? true : !$0.isCompleted }
            .sorted(using: sortOrder)
    }
    
    func addTask(title: String, priority: Int) {
        let task = Task(title: title, priority: priority, project: project)
        context.insert(task)
        try? context.save()
    }
    
    func deleteTask(_ task: Task) {
        context.delete(task)
        try? context.save()
    }
    
    func updateTask(_ task: Task) {
        try? context.save()
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: ProjectListViewModel
    @State private var showingAddProject = false
    @State private var newProjectName = ""
    
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: ProjectListViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.projects) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        Text(project.name)
                    }
                }
                .onDelete(perform: viewModel.deleteProjects)
            }
            .navigationTitle("Projects")
            .toolbar {
                Button("Add Project") {
                    showingAddProject = true
                }
            }
        }
        .sheet(isPresented: $showingAddProject) {
            VStack {
                TextField("Project Name", text: $newProjectName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add") {
                    viewModel.addProject(name: newProjectName)
                    newProjectName = ""
                    showingAddProject = false
                }
            }
            .padding()
        }
    }
}

struct ProjectDetailView: View {
    @StateObject private var viewModel: ProjectDetailViewModel
    @State private var showingAddTask = false
    @State private var newTaskTitle = ""
    @State private var newTaskPriority = 1
    
    init(project: Project) {
        _viewModel = StateObject(wrappedValue: ProjectDetailViewModel(context: project.modelContext!, project: project))
    }
    
    var body: some View {
        List {
            Section(header: Text("Tasks")) {
                ForEach(viewModel.filteredAndSortedTasks) { task in
                    TaskRow(task: task, updateTask: viewModel.updateTask)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.deleteTask(viewModel.filteredAndSortedTasks[index])
                    }
                }
            }
        }
        .navigationTitle(viewModel.project.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Task") {
                    showingAddTask = true
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Filter & Sort") {
                    Picker("Sort by", selection: $viewModel.sortOrder) {
                        Text("Priority (High to Low)").tag([SortDescriptor(\Task.priority, order: .reverse)])
                        Text("Priority (Low to High)").tag([SortDescriptor(\Task.priority, order: .forward)])
                    }
                    Toggle("Show Completed", isOn: $viewModel.filterCompleted)
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            VStack {
                TextField("Task Title", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Stepper("Priority: \(newTaskPriority)", value: $newTaskPriority, in: 1...5)
                Button("Add") {
                    viewModel.addTask(title: newTaskTitle, priority: newTaskPriority)
                    newTaskTitle = ""
                    newTaskPriority = 1
                    showingAddTask = false
                }
            }
            .padding()
        }
    }
}

struct TaskRow: View {
    @Bindable var task: Task
    var updateTask: (Task) -> Void
    
    var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            Text("Priority: \(task.priority)")
            Toggle("", isOn: $task.isCompleted)
                .onChange(of: task.isCompleted) { _, _ in
                    updateTask(task)
                }
        }
    }
}
```

Both versions of the app demonstrate the following:

1. @Model: Used for Project and Task classes.
2. Create, Read, Update, Delete (CRUD): 
   - Create: Adding new projects and tasks
   - Read: Displaying projects and tasks
   - Update: Toggling task completion status
   - Delete: Deleting projects and tasks

3. Relationships: Project has a one-to-many relationship with Task.
4. Sorting and Filtering Data: Tasks can be sorted by priority and filtered by completion status.

The main differences between the two versions are:

1. Version A (No MVVM) has all the logic directly in the views.
2. Version B (MVVM) separates the business logic into ViewModels (ProjectListViewModel and ProjectDetailViewModel), which handle data operations and state management.

Both versions provide the same functionality, but Version B with MVVM offers better separation of concerns and improved testability.

# SwiftData Official Documentation by Apple

SwiftData allows you to persist model data across app launches using macros and property wrappers, integrating seamlessly with SwiftUI.

## Overview

SwiftData helps you persist custom data models (e.g., trips, flights) efficiently. It supplements your existing model classes by providing tools to describe your app’s schema in Swift code.

## Turn Classes into Models

To persist model instances, annotate classes with the `@Model` macro:

```swift
import SwiftData

@Model
class Trip {
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var accommodation: Accommodation?
}
```

SwiftData supports primitive types like `Bool`, `Int`, `String`, and complex types conforming to `Codable`.

## Customize Persistence Behavior

### Unique Attribute

Annotate properties to enforce unique constraints:

```swift
@Attribute(.unique) var name: String
```

### Relationships

Manage relationships between models with the `@Relationship` macro:

```swift
@Relationship(.cascade) var accommodation: Accommodation?
```

### Transient Attributes

Exclude properties from persistence:

```swift
@Transient var destinationWeather = Weather.current()
```

## Configure Model Storage

Set up the model container in your SwiftUI app:

```swift
import SwiftUI
import SwiftData

@main
struct TripsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Trip.self, Accommodation.self])
        }
    }
}
```

Or manually create a model container:

```swift
import SwiftData

let container = try ModelContainer([Trip.self, Accommodation.self])
```

### Custom Storage Configuration

Configure storage options using `ModelConfiguration`:

```swift
let configuration = ModelConfiguration(isStoredInMemoryOnly: true, allowsSave: false)
let container = try ModelContainer(for: Trip.self, Accommodation.self, configurations: configuration)
```

## Save Models

Use a model context to manage instances:

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
}
```

Insert and save model instances:

```swift
var trip = Trip(name: name, destination: destination, startDate: startDate, endDate: endDate)
context.insert(trip)
try? context.save()
```

## Fetch Models

Fetch model instances with `@Query` in SwiftUI:

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \.startDate, order: .reverse) var allTrips: [Trip]
    
    var body: some View {
        List {
            ForEach(allTrips) {
                TripView(for: $0)
            }
        }
    }
}
```

Or use `ModelContext` outside SwiftUI:

```swift
let context = container.mainContext

let upcomingTrips = FetchDescriptor<Trip>(
    predicate: #Predicate { $0.startDate > Date.now },
    sortBy: [.init(\.startDate)]
)
upcomingTrips.fetchLimit = 50
upcomingTrips.includePendingChanges = true

let results = context.fetch(upcomingTrips)
```

## Define the Data Model

### Animal Model

```swift
import SwiftData

@Model
final class Animal {
    var name: String
    var diet: Diet
    var category: AnimalCategory?
    
    init(name: String, diet: Diet) {
        self.name = name
        self.diet = diet
    }
}
```

### AnimalCategory Model

```swift
import SwiftData

@Model
final class AnimalCategory {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade, inverse: \Animal.category)
    var animals = [Animal]()
    
    init(name: String) {
        self.name = name
    }
}
```

## Design the Data Editor

### AnimalEditor View

```swift
struct AnimalEditor: View {
    let animal: Animal?
    
    @State private var name = ""
    @State private var selectedDiet = Animal.Diet.herbivorous
    @State private var selectedCategory: AnimalCategory?
    
    @Environment(\.modelContext) private var modelContext
    
    private var editorTitle: String {
        animal == nil ? "Add Animal" : "Edit Animal"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Category", selection: $selectedCategory) {
                    Text("Select a category").tag(nil as AnimalCategory?)
                    ForEach(categories) { category in
                        Text(category.name).tag(category as AnimalCategory?)
                    }
                }
                
                Picker("Diet", selection: $selectedDiet) {
                    ForEach(Animal.Diet.allCases, id: \.self) { diet in
                        Text(diet.rawValue).tag(diet)
                    }
                }
            }
            .onAppear {
                if let animal {
                    name = animal.name
                    selectedDiet = animal.diet
                    selectedCategory = animal.category
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func save() {
        if let animal {
            animal.name = name
            animal.diet = selectedDiet
            animal.category = selectedCategory
        } else {
            let newAnimal = Animal(name: name, diet: selectedDiet)
            newAnimal.category = selectedCategory
            modelContext.insert(newAnimal)
        }
    }
}
```
