---
name: gt-http-mocking
description: Build HTTP services, map API data via models, and implement Mock Interceptors to enable local UI development without backend dependencies.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Tue, 14 Jul 2026 10:05:00 GMT
---

# HTTP Services & Mock Interceptors

## Contents

- [Structuring Service Implementations](#structuring-service-implementations)
- [Writing Data Contracts](#writing-data-contracts)
- [Executing Mock Interceptors](#executing-mock-interceptors)
- [Implementation Workflow](#implementation-workflow)
- [Examples](#examples)

## Structuring Service Implementations

Standardize all network interactions using the foundation HTTP abstractions.

- Extend the abstract domain interface and mix in `AppHttpMixin`.
- Inject `AppHttpService` into the service implementation constructor.
- Ensure all endpoint methods return a `TaskCallResponse<T>`.
- Wrap all HTTP interactions entirely within the `requestHandler()` execution closure.

## Writing Data Contracts

Enforce rigorous boundaries between network payloads and presentation logic.

- **Request Payloads:** All request parameters MUST implement the `Codable` interface from `gt_mobile_foundation`.
- **Response Objects:** All API response objects MUST implement a `factory ClassName.fromJson(Map<String, dynamic> json)` constructor.
- **Clean UI Layer Boundaries:** To ensure proper separation of concerns, presentation layer widgets must NEVER access mock JSON maps directly or reference `MockData` classes. All mock responses must be parsed into their corresponding Response Objects in the service layer, exposed through States, and consumed as typed properties. (See presentation boundary rules in `gt-utilities-extensions` / `app-style-guide/SKILL.md`).

## Executing Mock Interceptors

Bypass real network transmissions natively during development to build UI without a functioning backend.

- Create a dedicated mock interceptor extending `Interceptor` for the feature module.
- Pass a boolean flag (e.g., `isMock = false`) into the module's HTTP service constructor to conditionally attach the mock interceptor to `AppHttpService`.
- In the interceptor, override `onRequest` and use Dart 3's `switch` syntax on `options.path` to match API endpoints.
- Resolve the request immediately using `handler.resolve(Response(requestOptions: options, data: responseData, statusCode: 200))` to return static JSON representations.

## Implementation Workflow

- [ ] 1. Create request payloads extending `Codable` and response objects with `fromJson`.
- [ ] 2. Create a MockData file holding static JSON maps/lists.
- [ ] 3. Implement the `[Feature]MockInterceptor` matching endpoint paths via a `switch` statement.
- [ ] 4. Create the service implementation extending `AppHttpMixin` with an `isMock` constructor flag.
- [ ] 5. Conditionally attach the interceptor and wrap API endpoints in `requestHandler()`.

## Examples

### 1. Mock Data & Interceptor Implementation

```dart
import 'package:dio/dio.dart';
import 'package:onebank_pro/core/presentation/l10n/localization.dart';

class AuthMockData {
  final List<Map<String, dynamic>> industries = [
    {"industry": LocaleKeys.industryOptionAircraft, "industry_T24Code": ""},
    {"industry": LocaleKeys.industryOptionDesign, "industry_T24Code": ""},
    {"industry": LocaleKeys.industryOptionEducation, "industry_T24Code": ""},
    {"industry": LocaleKeys.industryOptionFinancial, "industry_T24Code": ""},
    {"industry": LocaleKeys.industryOptionFood, "industry_T24Code": ""},
    {"industry": LocaleKeys.industryOptionHealth, "industry_T24Code": ""},
  ];

  final List<Map<String, dynamic>> customers = [
    {"customer": LocaleKeys.customersOptionGeneralPublic, "customer_code": ""},
    {"customer": LocaleKeys.customersOptionOtherBusinesses, "customer_code": ""},
    {"customer": LocaleKeys.customersOptionEqualSplit, "customer_code": ""},
    {"customer": LocaleKeys.customersOptionNotSure, "customer_code": ""},
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {"method": LocaleKeys.paymentOptionLocalBank, "method_code": ""},
    {"method": LocaleKeys.paymentOptionInternational, "method_code": ""},
    {"method": LocaleKeys.paymentOptionCardInPerson, "method_code": ""},
    {"method": LocaleKeys.paymentOptionCardOnline, "method_code": ""},
    {"method": LocaleKeys.paymentOptionThirdParty, "method_code": ""},
    {"method": LocaleKeys.paymentOptionCash, "method_code": ""},
    {"method": LocaleKeys.paymentOptionCheques, "method_code": ""},
  ];

  final Map<String, dynamic> acctValidationResponse = {
    "accountName": 'John Alex',
    "phoneNumber": '07012345678',
    "accountNumber": '0123456789',
    "username": 'Johnlex',
    "firstName": 'John',
    "lastName": 'Alex',
    "status": 'in-active',
    "email": 'alexlobaba@gmail.com',
    "isVerified": false,
    "isExists": true,
    "isProfileExists": true,
    "isProfileExistsForBvn": true,
    "noMatchingAccount": false,
    "hasPassCode": true,
  };
}

class AuthMockInterceptor extends Interceptor {
  final _mock = AuthMockData();

  AuthMockInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dynamic responseData = switch (options.path) {
      '/auth/industries' => _mock.industries,
      '/auth/customers' => _mock.customers,
      '/auth/payment-methods' => _mock.paymentMethods,
      '/auth/validate-account' => _mock.acctValidationResponse,
      _ => null,
    };

    if (responseData != null) {
      return handler.resolve(
        Response(requestOptions: options, data: responseData, statusCode: 200),
      );
    }

    super.onRequest(options, handler);
  }
}
```

### 2. HTTP Service with Conditionally Attached Mocks

```dart
class AuthHttpService with AppHttpMixin implements AuthService {
  final AppHttpService _http;

  AuthHttpService(this._http, {bool isMock = false}) {
    if (!isMock) return;
    // Attach Mocks natively
    _http.attachInterceptor(AuthMockInterceptor());
  }

  @override
  TaskCallResponse<List<Industry>> getIndustries() {
    return requestHandler(() async {
      final response = await _http.get('/auth/industries');
      if (response.data is! Iterable) return [];

      return [for (final it in response.data) Industry.fromJson(it)];
    });
  }

  @override
  TaskCallResponse<AccountValidationResponse> validateAccount(ValidateAccountParams params) {
    return requestHandler(() async {
      // params strictly implements Codable
      final response = await _http.post('/auth/validate-account', data: params);
      return AccountValidationResponse.fromJson(response.data);
    });
  }
}
```
