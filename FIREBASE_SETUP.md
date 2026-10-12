# EcoSwap - Firebase Setup Guide

This guide outlines the Firebase project configuration, Firestore Security Rules, Storage Rules, and Database Indexes required for the **EcoSwap** application.

---

## 1. Firebase Project Initial Setup

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project named **EcoSwap**.
3. Enable **Google Analytics** (optional).
4. Add an **Android App** with application ID `com.ecoswap.app` (or your project bundle ID).
   - Download `google-services.json` and place it in `android/app/`.
5. Add an **iOS App** with bundle ID `com.ecoswap.app`.
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/`.
6. Enable the following Firebase Services:
   - **Authentication**: Email/Password and Google Sign-In.
   - **Cloud Firestore**: Production Mode.
   - **Firebase Storage**: For item photos & profile pictures.
   - **Firebase Cloud Messaging (FCM)**: For push notifications.

---

## 2. Cloud Firestore Security Rules

Copy and paste these rules into the **Firestore Database Rules** tab:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create, update: if isOwner(userId);
      allow delete: if false;
    }

    // Listings collection
    match /listings/{listingId} {
      allow read: if true; // Publicly readable for marketplace browsing
      allow create: if isAuthenticated() && request.resource.data.ownerId == request.auth.uid;
      allow update, delete: if isAuthenticated() && (resource.data.ownerId == request.auth.uid || request.resource.data.claimedByUserId == request.auth.uid);
    }

    // Chats collection
    match /chats/{chatId} {
      allow read, update: if isAuthenticated() && request.auth.uid in resource.data.participants;
      allow create: if isAuthenticated() && request.auth.uid in request.resource.data.participants;
    }

    // Messages collection
    match /chats/{chatId}/messages/{messageId} {
      allow read: if isAuthenticated() && request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
      allow create: if isAuthenticated() && request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants && request.resource.data.senderId == request.auth.uid;
    }

    // Favorites collection
    match /favorites/{userId}/listings/{listingId} {
      allow read, write: if isOwner(userId);
    }

    // Reviews collection
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if isAuthenticated() && request.resource.data.fromUserId == request.auth.uid;
    }

    // Challenges collection
    match /challenges/{challengeId} {
      allow read: if true;
      allow write: if false; // Admin created only
    }

    // User Challenges collection
    match /user_challenges/{docId} {
      allow read: if isAuthenticated();
      allow create, update: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
    }
  }
}
```

---

## 3. Firebase Storage Security Rules

Copy and paste these rules into the **Firebase Storage Rules** tab:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_photos/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /listing_images/{listingId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 4. Required Composite Indexes

Create the following composite indexes in Firestore under **Indexes**:

1. **listings**: `status` ASC, `location.geohash` ASC
2. **listings**: `category` ASC, `createdAt` DESC
3. **listings**: `ownerId` ASC, `createdAt` DESC
4. **chats**: `participants` ARRAY_CONTAINS, `lastMessageAt` DESC
