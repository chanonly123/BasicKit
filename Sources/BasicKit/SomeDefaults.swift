import Foundation

fileprivate let encoder = JSONEncoder()
fileprivate let decoder = JSONDecoder()

@propertyWrapper
public struct SomeDefault<Value: Codable> {
    let key: String
    let defaultValue: Value?
    let container: UserDefaults
    
    public init(_ key: String, defaultValue: Value? = nil, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
    
    public var wrappedValue: Value? {
        get {
            if let data = container.data(forKey: key) {
                do {
                    return try decoder.decode(Value.self, from: data)
                } catch {
                    print("SomeDefault:", error)
                }
            }
            return nil
        }
        set {
            do {
                let data = try encoder.encode(newValue)
                container.set(data, forKey: key)
            } catch {
                print("SomeDefault:", error)
            }
        }
    }
}
