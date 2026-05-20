const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp();

exports.setUserRole = functions.https.onCall(async (request) => {
  const auth = request.auth;
  if (!auth || auth.token.admin !== true) {
    throw new functions.https.HttpsError('permission-denied', 'Admin only.');
  }

  const targetUid = request.data && request.data.targetUid;
  const role = request.data && request.data.role;

  if (!targetUid || (role !== 'user' && role !== 'admin')) {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid role payload.');
  }

  await admin.auth().setCustomUserClaims(targetUid, { admin: role === 'admin' });
  await admin.firestore().collection('users').doc(targetUid).set(
    { role },
    { merge: true },
  );

  return { ok: true };
});

exports.sendCampaignNotification = functions.https.onCall(async (request) => {
  const auth = request.auth;
  if (!auth || auth.token.admin !== true) {
    throw new functions.https.HttpsError('permission-denied', 'Admin only.');
  }

  const title = request.data && request.data.title;
  const body = request.data && request.data.body;

  if (!title || !body) {
    throw new functions.https.HttpsError('invalid-argument', 'Title and body are required.');
  }

  const usersSnapshot = await admin.firestore().collection('users').get();
  const tokens = [];

  usersSnapshot.forEach((doc) => {
    const token = doc.get('fcmToken');
    if (typeof token === 'string' && token.length > 20) {
      tokens.push(token);
    }
  });

  if (tokens.length === 0) {
    return { ok: true, sentCount: 0 };
  }

  const message = {
    notification: { title, body },
    tokens,
  };

  const result = await admin.messaging().sendEachForMulticast(message);
  return { ok: true, sentCount: result.successCount, failedCount: result.failureCount };
});
