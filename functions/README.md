# Firebase Functions (Admin Actions)

This folder contains callable cloud functions used to harden privileged operations:

- `setUserRole`: Assigns `user` or `admin` role and updates custom claims.
- `sendCampaignNotification`: Broadcasts campaign notifications to stored FCM tokens.

## Deploy

1. Install Firebase CLI and login.
2. Set project: `firebase use <project-id>`
3. Install deps: `cd functions && npm install`
4. Deploy functions: `firebase deploy --only functions`

## Important

Only users with custom claim `admin: true` can call these functions.
Set an initial bootstrap admin manually once using Admin SDK or Firebase Console tooling.
