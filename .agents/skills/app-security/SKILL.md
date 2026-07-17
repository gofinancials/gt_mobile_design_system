---
name: gt-networking-security
description: Implement API communication, interceptors, and cryptographic layers using `AppHttpService`. Use when building service integrations or handling secure payloads.
metadata:
  last_modified: Mon, 13 Jul 2026 18:39:23 GMT
---

# Networking, Cryptography & Interceptors

## Contents

- [Structuring Service Implementations](#structuring-service-implementations)
- [Writing HTTP Calls](#writing-http-calls)
- [Executing Cryptography](#executing-cryptography)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring Service Implementations

Standardize all network interactions using the foundation HTTP abstractions.

- Extend the abstract domain interface and mix in `AppHttpMixin`[cite: 2].
- Inject `AppHttpService` into the service implementation[cite: 2].
- Ensure all endpoint methods return a `TaskCallResponse<T>`[cite: 2].

## Writing HTTP Calls

- Wrap all HTTP interactions entirely within the `requestHandler()` execution block[cite: 2].
- Return the parsed object using its `.fromJson` constructor directly within the handler.

## Executing Cryptography

- Do NOT manually encrypt or decrypt payloads within the method body.
- Inject `AppCryptoService` into the constructor when securing traffic[cite: 2].
- Attach `EncryptInterceptor` (for outgoing requests) and `DecryptInterceptor` (for incoming responses) to the `AppHttpService` pipeline[cite: 2].

## Implementation Workflow

- [ ] 1. Create the abstract domain service class.
- [ ] 2. Create the implementation class mixing in `AppHttpMixin`[cite: 2].
- [ ] 3. Inject `AppHttpService` and `AppCryptoService`[cite: 2].
- [ ] 4. Attach `EncryptInterceptor` and `DecryptInterceptor` in the constructor[cite: 2].
- [ ] 5. Write methods returning `TaskCallResponse<T>` wrapped in `requestHandler()`[cite: 2].

## Examples

### Secure HTTP Service

```dart
class SecureBillsHttpService with AppHttpMixin implements BillsService {
  final AppHttpService _http;
  final AppCryptoService _crypto;

  SecureBillsHttpService(this._http, this._crypto) {
    _http.attachInterceptors([
        EncryptInterceptor(_crypto, mode: .base16),
        DecryptInterceptor(_crypto, mode: .base16)
    ]);
  }

  @override
  TaskCallResponse<BillResponse> buyAirtime(BillsParam params) {
    return requestHandler(() async {
      final response = await _http.post('/bills/airtime', data: params);
      return BillResponse.fromJson(response.data);
    });
  }
}
```
