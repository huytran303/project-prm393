const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();
const REGION = "asia-southeast1";

async function tokensOf(roles) {
  const snap = await getFirestore()
    .collection("users")
    .where("role", "in", roles)
    .where("isActive", "==", true)
    .get();
  return snap.docs.flatMap((d) => d.get("fcmTokens") || []);
}

// Sends a push and removes tokens FCM reports as unregistered (SRS 3.1.4 #2).
async function push(tokens, title, body, data) {
  if (tokens.length === 0) return;
  const res = await getMessaging().sendEachForMulticast({
    tokens,
    notification: { title, body },
    data,
  });
  const dead = tokens.filter(
    (_, i) => res.responses[i].error?.code === "messaging/registration-token-not-registered",
  );
  if (dead.length === 0) return;
  const db = getFirestore();
  const owners = await db.collection("users").where("fcmTokens", "array-contains-any", dead.slice(0, 30)).get();
  await Promise.all(
    owners.docs.map((d) => d.ref.update({ fcmTokens: d.get("fcmTokens").filter((t) => !dead.includes(t)) })),
  );
}

// UC31: fires only on the edge into "ready", so a retry never changes data.
exports.onOrderReady = onDocumentUpdated({ document: "orders/{orderId}", region: REGION }, async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (before.status === "ready" || after.status !== "ready") return;
  let table = "Mang đi";
  if (after.tableId) {
    const doc = await getFirestore().doc(`tables/${after.tableId}`).get();
    table = doc.get("name") || table;
  }
  const tokens = await tokensOf(["cashier", "supervisor", "manager"]);
  await push(tokens, "BrewBoss", `Đơn ${after.shortId} — ${table} đã sẵn sàng`, {
    type: "orderReady",
    orderId: event.params.orderId,
  });
});

// UC16: fires only when stock crosses from above the minimum to at or below it.
exports.onIngredientWrite = onDocumentUpdated({ document: "ingredients/{ingredientId}", region: REGION }, async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (!(before.stock > after.minStock && after.stock <= after.minStock)) return;
  const tokens = await tokensOf(["manager"]);
  await push(tokens, "BrewBoss", `Sắp hết ${after.name}: còn ${after.stock} ${after.unit}`, {
    type: "lowStock",
    ingredientId: event.params.ingredientId,
  });
});
