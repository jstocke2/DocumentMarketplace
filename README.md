# DocumentMarketplace

> Archived portfolio project. This repository contains the original 2020 native iOS prototype that preceded [DocumentXchange](https://documentxchange.app). The current production application has been rebuilt and its source repository is private.

## See the current product

- [DocumentXchange website](https://documentxchange.app)
- [Download for iPhone and iPad](https://apps.apple.com/us/app/documentxchange/id6798885846)
- [Get the Android app](https://play.google.com/store/apps/details?id=com.jstocke2.documentxchange)

## What this prototype demonstrates

DocumentMarketplace explored a two-sided marketplace for requesting, finding, uploading, and purchasing public-record documents. The prototype includes:

- Native iOS screens written in Swift and UIKit
- Email/password authentication with Firebase Authentication
- Document-request and listing workflows backed by Cloud Firestore
- Document upload and download flows using Firebase Storage
- Firebase Cloud Functions for server-side payment events
- Stripe customer, payment-method, PaymentIntent, and cleanup workflows
- County and document metadata entry, validation, and browsing

## Architecture

```text
iOS app (Swift/UIKit)
├── Firebase Authentication
├── Cloud Firestore
├── Firebase Storage
└── Firebase Cloud Functions (Node.js)
    └── Stripe payment APIs
```

The Swift client contains the user-facing marketplace flows. Firebase provides identity, document metadata, file storage, and event-driven backend functions. Stripe logic is kept in Cloud Functions so the secret key is not embedded in the iOS client.

## Repository map

- `DocumentMarketplace/ViewControllers/` — authentication, requests, listings, uploads, downloads, and checkout screens
- `DocumentMarketplace/TableViews/` — reusable table-view cells and data presentation
- `DocumentMarketplace/Helpers/` — shared UI and storyboard helpers
- `functions/index.js` — Firebase triggers and Stripe payment workflows
- `Podfile` — historical iOS dependencies

## Historical setup

This code is preserved as a portfolio artifact and is not maintained for current SDKs. The original project used CocoaPods, Xcode, Firebase, Node.js 10, and older Stripe/Firebase APIs. It should be treated as a code sample rather than a production-ready application.

To examine the historical project locally:

1. Install the dependencies listed in `Podfile` with CocoaPods.
2. Create your own Firebase iOS project and add your own `GoogleService-Info.plist`.
3. Configure the required Firebase services and your own Stripe test credentials.
4. Open `DocumentMarketplace.xcworkspace` in a compatible version of Xcode.

Do not use production credentials with this archived prototype.

## Evolution into DocumentXchange

The current DocumentXchange product expands the original idea into a cross-platform application and web experience. The production implementation is intentionally private, while this repository remains public to show the earlier native-iOS architecture and the evolution of the product.

## Status

Archived / portfolio use only. No production support or security guarantees are provided for this historical code.
