// Security Rules tests of the permission matrix (SDS 5.1). Run: npm run test:rules
const { test, before, beforeEach, after } = require("node:test");
const fs = require("node:fs");
const path = require("node:path");
const {
  initializeTestEnvironment, assertSucceeds, assertFails,
} = require("@firebase/rules-unit-testing");
const {
  doc, getDoc, setDoc, updateDoc, deleteDoc, collection, query, where, getDocs, writeBatch, runTransaction,
  serverTimestamp, arrayUnion,
} = require("firebase/firestore");

let env;
const db = (uid) => env.authenticatedContext(uid).firestore();
const anon = () => env.authenticatedContext("anon1", { firebase: { sign_in_provider: "anonymous" } }).firestore();

const staffOrder = (over = {}) => ({
  source: "staff", status: "pending", createdBy: "lan", items: [], subtotal: 0, discount: 0, total: 0,
  pointsRedeemed: 0, cashAmount: 0, qrAmount: 0, ...over,
});
const qrOrder = (over = {}) => ({
  source: "customer", status: "awaiting", createdBy: "anon1", tableId: "t1", items: [], subtotal: 0,
  discount: 0, total: 0, pointsRedeemed: 0, cashAmount: 0, qrAmount: 0, ...over,
});

before(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-brewboss-rules",
    firestore: { rules: fs.readFileSync(path.join(__dirname, "../../firestore.rules"), "utf8") },
  });
});
after(() => env.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const d = ctx.firestore();
    const users = { quan: "manager", ha: "supervisor", lan: "cashier", minh: "barista" };
    for (const [id, role] of Object.entries(users)) {
      await setDoc(doc(d, `users/${id}`), { name: id, role, isActive: true, fcmTokens: [] });
    }
    await setDoc(doc(d, "users/off"), { name: "off", role: "cashier", isActive: false, fcmTokens: [] });
    await setDoc(doc(d, "tables/t1"), { name: "T1", area: "A", capacity: 2, currentOrderId: null });
    await setDoc(doc(d, "products/p1"), { name: "X", isAvailable: true, basePrice: 1 });
    await setDoc(doc(d, "ingredients/i1"), { name: "I", unit: "g", stock: 100, minStock: 1 });
    await setDoc(doc(d, "customers/0912345678"), { phone: "0912345678", points: 10, visitCount: 1 });
    await setDoc(doc(d, "vouchers/V1"), { usedCount: 0, usageLimit: 5 });
    await setDoc(doc(d, "settings/shop"), { name: "S", bankAccountNo: "1" });
    await setDoc(doc(d, "settings/public"), { name: "S" });
    await setDoc(doc(d, "orders/served"), staffOrder({ status: "served", total: 100, subtotal: 100, tableId: "t1" }));
    await setDoc(doc(d, "orders/pending"), staffOrder());
    await setDoc(doc(d, "orders/preparing"), staffOrder({ status: "preparing" }));
    await setDoc(doc(d, "shifts/s1"), { userId: "lan", checkOut: null, openingCash: 500, cashSales: 0, qrSales: 0 });
    await setDoc(doc(d, "shiftLocks/lan"), { shiftId: "s1" });
  });
});

test("users: read self only, fcmTokens only", async () => {
  await assertSucceeds(getDoc(doc(db("lan"), "users/lan")));
  await assertFails(getDoc(doc(db("lan"), "users/quan")));
  await assertSucceeds(getDoc(doc(db("quan"), "users/lan")));
  await assertSucceeds(updateDoc(doc(db("lan"), "users/lan"), { fcmTokens: arrayUnion("x") }));
  await assertFails(updateDoc(doc(db("lan"), "users/lan"), { role: "manager" }));
});

test("deactivated staff lose access", async () => {
  await assertFails(getDoc(doc(db("off"), "settings/shop")));
  await assertSucceeds(getDoc(doc(db("off"), "users/off"))); // Needed to show MSG03.
});

test("anonymous: reads public menu but not staff data", async () => {
  await assertSucceeds(getDoc(doc(anon(), "products/p1")));
  await assertSucceeds(getDoc(doc(anon(), "tables/t1")));
  await assertSucceeds(getDoc(doc(anon(), "settings/public")));
  await assertFails(getDoc(doc(anon(), "settings/shop")));
  await assertFails(getDocs(collection(anon(), "tables")));
  await assertFails(getDoc(doc(anon(), "ingredients/i1")));
  await assertFails(getDoc(doc(anon(), "customers/0912345678")));
  await assertFails(getDoc(doc(env.unauthenticatedContext().firestore(), "products/p1")));
});

test("SEC-ANON: customer may only create awaiting orders of their own", async () => {
  const a = anon();
  await assertSucceeds(setDoc(doc(a, "orders/q1"), qrOrder()));
  await assertFails(setDoc(doc(a, "orders/q2"), qrOrder({ status: "pending" })));
  await assertFails(setDoc(doc(a, "orders/q3"), qrOrder({ createdBy: "someone" })));
  await assertFails(setDoc(doc(a, "orders/q4"), qrOrder({ shortId: "A0001" })));
  await assertFails(setDoc(doc(a, "orders/q5"), qrOrder({ confirmedBy: "anon1" })));
  await assertFails(setDoc(doc(a, "orders/q6"), qrOrder({ discount: 5000 })));
  await assertFails(setDoc(doc(a, "orders/q7"), staffOrder({ createdBy: "anon1" })));
  await assertFails(updateDoc(doc(a, "orders/q1"), { status: "pending" }));
});

test("customer reads own order and followed order only", async () => {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), "orders/mine"), qrOrder());
    await setDoc(doc(ctx.firestore(), "orders/followed"), staffOrder({ followerUids: ["anon1"] }));
  });
  await assertSucceeds(getDoc(doc(anon(), "orders/mine")));
  await assertSucceeds(getDoc(doc(anon(), "orders/followed")));
  await assertFails(getDoc(doc(anon(), "orders/pending")));
  await assertSucceeds(getDocs(query(collection(anon(), "orders"), where("createdBy", "==", "anon1"))));
  await assertFails(getDocs(collection(anon(), "orders")));
});

test("barista: status transitions only", async () => {
  const b = db("minh");
  const status = (s) => ({ status: s, updatedAt: serverTimestamp(), updatedBy: "minh" });
  await assertSucceeds(updateDoc(doc(b, "orders/pending"), status("preparing")));
  await assertSucceeds(updateDoc(doc(b, "orders/preparing"), status("ready")));
  await assertFails(updateDoc(doc(b, "orders/served"), status("paid")));
  await assertFails(updateDoc(doc(b, "orders/served"), { total: 0, updatedBy: "minh" }));
});

test("cancel: cashier only before preparation (BR-ORD-05)", async () => {
  await assertSucceeds(updateDoc(doc(db("lan"), "orders/pending"), { status: "cancelled", cancelReason: "x" }));
  await assertFails(updateDoc(doc(db("lan"), "orders/preparing"), { status: "cancelled", cancelReason: "x" }));
  await assertSucceeds(updateDoc(doc(db("ha"), "orders/preparing"), { status: "cancelled", cancelReason: "x" }));
  await assertSucceeds(updateDoc(doc(db("lan"), "orders/served"), { status: "cancelled", mergedIntoId: "t", cancelReason: "Gộp vào A" }));
});

test("paid and cancelled orders are terminal for staff", async () => {
  await env.withSecurityRulesDisabled((ctx) => setDoc(doc(ctx.firestore(), "orders/done"), staffOrder({ status: "paid" })));
  await assertFails(updateDoc(doc(db("lan"), "orders/done"), { total: 1 }));
  await assertFails(updateDoc(doc(db("ha"), "orders/done"), { status: "pending" }));
});

function payBatch(d, cash = 100, qr = 0, shiftId = "s1") {
  const b = writeBatch(d);
  b.update(doc(d, "orders/served"), { status: "paid", paidBy: "lan", cashAmount: cash, qrAmount: qr, shiftId });
  return b;
}

test("payment commits stock, points, voucher and shift together", async () => {
  const d = db("lan");
  const b = payBatch(d);
  b.update(doc(d, "shifts/s1"), { cashSales: 100, qrSales: 0, lastPaidOrderId: "served" });
  b.update(doc(d, "ingredients/i1"), { stock: 80, lastOrderId: "served" });
  b.set(doc(d, "ingredients/i1/movements/m1"), { type: "sale", qty: -20, orderId: "served", byUserId: "lan" });
  b.update(doc(d, "customers/0912345678"), { points: 20, visitCount: 2, lastOrderId: "served" });
  b.update(doc(d, "vouchers/V1"), { usedCount: 1, lastOrderId: "served" });
  b.update(doc(d, "tables/t1"), { currentOrderId: null });
  await assertSucceeds(b.commit());
});

test("BR-PAY: amounts must equal total and the payer needs an open shift", async () => {
  await assertFails(payBatch(db("lan"), 50, 0).commit());
  await assertFails(payBatch(db("lan"), 100, 0, "other").commit());
  await assertFails(payBatch(db("ha")).commit());
});

test("cashier cannot touch stock, points, voucher or cash totals directly", async () => {
  const d = db("lan");
  await assertFails(updateDoc(doc(d, "ingredients/i1"), { stock: 0, lastOrderId: "pending" }));
  await assertFails(updateDoc(doc(d, "customers/0912345678"), { points: 999, lastOrderId: "pending" }));
  await assertFails(updateDoc(doc(d, "vouchers/V1"), { usedCount: 1, lastOrderId: "pending" }));
  await assertFails(updateDoc(doc(d, "shifts/s1"), { cashSales: 999, lastPaidOrderId: "pending" }));
  await assertFails(setDoc(doc(d, "ingredients/i1/movements/x"), { type: "sale", qty: -1, orderId: "pending", byUserId: "lan" }));
});

test("shift totals must grow by exactly the paid amounts", async () => {
  const d = db("lan");
  const b = payBatch(d);
  b.update(doc(d, "shifts/s1"), { cashSales: 999, qrSales: 0, lastPaidOrderId: "served" });
  await assertFails(b.commit());
});

test("check-in needs the lock; a second check-in fails (BR-STAFF-01)", async () => {
  const d = db("minh");
  const shift = { userId: "minh", checkOut: null, cashSales: 0, qrSales: 0, openingCash: null };
  const first = writeBatch(d);
  first.set(doc(d, "shifts/new1"), shift);
  first.set(doc(d, "shiftLocks/minh"), { shiftId: "new1" });
  await assertSucceeds(first.commit());
  const second = writeBatch(d);
  second.set(doc(d, "shifts/new2"), shift);
  await assertFails(second.commit());
});

test("check-out recomputes cash and locks the fields (BR-STAFF-05)", async () => {
  const d = db("lan");
  await assertFails(updateDoc(doc(d, "shifts/s1"), {
    checkOut: serverTimestamp(), closingCash: 500, expectedCash: 400, cashDiff: 100,
  }));
  await assertSucceeds(updateDoc(doc(d, "shifts/s1"), {
    checkOut: serverTimestamp(), closingCash: 480, expectedCash: 500, cashDiff: -20, handoverNote: "x",
  }));
  await assertFails(updateDoc(doc(d, "shifts/s1"), { handoverNote: "edited" }));
  await assertFails(updateDoc(doc(db("ha"), "shifts/s1"), { closingCash: 500 }));
});

test("own shifts only, except supervisors and managers can read all", async () => {
  await assertFails(getDoc(doc(db("minh"), "shifts/s1")));
  await assertSucceeds(getDoc(doc(db("lan"), "shifts/s1")));
  await assertSucceeds(getDoc(doc(db("ha"), "shifts/s1")));
});

test("supervisor stocktake needs an adjust movement in the same commit", async () => {
  const d = db("ha");
  await assertFails(updateDoc(doc(d, "ingredients/i1"), { stock: 5, lastMovementId: "none" }));
  const b = writeBatch(d);
  b.update(doc(d, "ingredients/i1"), { stock: 90, lastMovementId: "m9" });
  b.set(doc(d, "ingredients/i1/movements/m9"), { type: "adjust", qty: -10, reason: "Kiểm kho", byUserId: "ha" });
  await assertSucceeds(b.commit());
  await assertFails(updateDoc(doc(d, "ingredients/i1/movements/m9"), { qty: 0 }));
  await assertFails(deleteDoc(doc(d, "ingredients/i1/movements/m9")));
});

test("availability toggle is the only product write for cashiers", async () => {
  await assertSucceeds(updateDoc(doc(db("lan"), "products/p1"), { isAvailable: false }));
  await assertFails(updateDoc(doc(db("lan"), "products/p1"), { basePrice: 0 }));
  await assertFails(updateDoc(doc(db("minh"), "products/p1"), { isAvailable: false }));
  await assertSucceeds(updateDoc(doc(db("quan"), "products/p1"), { basePrice: 2 }));
});

test("tables: cashier writes currentOrderId only", async () => {
  await assertSucceeds(updateDoc(doc(db("lan"), "tables/t1"), { currentOrderId: "x" }));
  await assertFails(updateDoc(doc(db("lan"), "tables/t1"), { name: "hack" }));
});

test("counter only grows by one", async () => {
  const d = db("lan");
  await assertSucceeds(setDoc(doc(d, "counters/20260101"), { next: 2 }));
  await assertSucceeds(updateDoc(doc(d, "counters/20260101"), { next: 3 }));
  await assertFails(updateDoc(doc(d, "counters/20260101"), { next: 9 }));
});

test("staff transaction: create order with counter and table", async () => {
  const d = db("lan");
  await assertSucceeds(runTransaction(d, async (txn) => {
    await txn.get(doc(d, "tables/t1"));
    txn.set(doc(d, "counters/20260102"), { next: 2 });
    txn.set(doc(d, "orders/new"), staffOrder({ shortId: "A0001", tableId: "t1" }));
    txn.update(doc(d, "tables/t1"), { currentOrderId: "new" });
  }));
});
