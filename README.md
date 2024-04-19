# BasicKit for iOS projects


## PagedCollectionView

<img style="width:50%;" src="https://github.com/chanonly123/BasicKit/blob/main/Demo/PagedCollectionView.gif" />

```
    PagedCollectionView(items: items, selected: $val, { val in
            Text("\(val.title)")
                .font(.system(size: 30))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.blue)
        })
        .itemSize(width: 200, height: 200)
        .insets(50)
        .scroll(.vertical)
        .frame(width: 300, height: 300)
```

## SomeDefaults

```
// CustomType must conform to Codable

struct YourStruct {
    @SomeDefault("username", defaultValue: nil, container: UserDefaults.standard)
    var username: String?

    @SomeDefault("user")
    var user: User?
}

let def = YourStruct()

def.username = "abcde"
def.user = // some object

```

## SomeURLRequest

```
public struct LoginRepoService: AuthRepo {
    let api = SomeURLRequest(interceptor: nil)
        
    public func login(token: String) async throws -> LoginData {
        let (obj, res): (LoginResponseRoot, HTTPURLResponse) = try await api.send(url: Endpoints.login, body: ["token": token], method: .post)
        return obj.data
    }
}

// optional interceptor
class URLRequestInterceptorImpl: SomeURLRequestInterceptor {
    private let local: MeloDefaults = injector.inject()
    
    func updateResponse(_ args: (data: Data, response: HTTPURLResponse)) async throws -> (data: Data, response: HTTPURLResponse) {
        // copy, modify and return the modified response
    }
    
    func onRequest(_ request: inout URLRequest) async throws {
        // update the request just before the api call 
        guard let accessToken = local.accessToken else {
            throw MeloError.authMissing
        }
        request.setValue(accessToken, forHTTPHeaderField: "x-auth-token")
    }
}
```
