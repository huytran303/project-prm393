// Fills the local Emulator Suite with demo data matching the SRS mock-ups.
// Usage (emulators running): npm run seed. Refuses to touch a real project.
process.env.FIRESTORE_EMULATOR_HOST ||= "localhost:8080";
process.env.FIREBASE_AUTH_EMULATOR_HOST ||= "localhost:9099";

const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore, Timestamp, FieldValue } = require("firebase-admin/firestore");

initializeApp({ projectId: "demo-brewboss" });
const db = getFirestore();
const auth = getAuth();
const PASSWORD = "123456";

const staff = [
  ["quan@brewboss.vn", "Nguyễn Văn Quân", "0901000001", "manager"],
  ["ha@brewboss.vn", "Phạm Thu Hà", "0901000002", "supervisor"],
  ["lan@brewboss.vn", "Trần Thị Lan", "0901234567", "cashier"],
  ["minh@brewboss.vn", "Lê Minh", "0901000003", "barista"],
  ["thanh@brewboss.vn", "Võ Thành", "0901000004", "cashier", false],
];

const categories = ["Cà phê", "Trà", "Đá xay", "Bánh"];

const ingredients = [
  ["coffee", "Cà phê hạt", "g", 190, 200],
  ["condensed", "Sữa đặc", "ml", 800, 1000],
  ["pearl", "Trân châu", "g", 350, 500],
  ["peach", "Đào ngâm", "pcs", 64, 20],
  ["tea", "Trà đen", "g", 2000, 300],
  ["matcha", "Bột matcha", "g", 900, 200],
];

const sizes = [
  { code: "S", priceDelta: 0 },
  { code: "M", priceDelta: 5000 },
  { code: "L", priceDelta: 10000 },
];
const toppings = [
  { id: "t1", name: "Trân châu", price: 5000 },
  { id: "t2", name: "Kem cheese", price: 10000 },
];
const recipe = (...items) => {
  const out = {};
  sizes.forEach((s, i) => {
    out[s.code] = items.map(([ingredientId, qty]) => ({ ingredientId, qty: qty + i * Math.ceil(qty / 4) }));
  });
  return out;
};

const products = [
  ["Cà phê sữa đá", 0, "Robusta, sữa đặc", 29000, true, recipe(["coffee", 20], ["condensed", 30])],
  ["Bạc xỉu", 0, "Nhiều sữa, ít cà phê", 32000, true, recipe(["coffee", 10], ["condensed", 40])],
  ["Americano", 0, "Espresso pha nước nóng", 35000, true, recipe(["coffee", 18])],
  ["Trà đào cam sả", 1, "Đào ngâm, cam, sả", 45000, true, recipe(["tea", 10], ["peach", 2])],
  ["Matcha đá xay", 2, "Matcha Uji", 55000, false, recipe(["matcha", 15])],
  ["Croissant", 3, "Bơ Pháp", 35000, true, {}],
];

const tables = [
  ["T1", "Trong nhà", 4], ["T2", "Trong nhà", 2], ["T3", "Trong nhà", 4],
  ["T4", "Trong nhà", 4], ["T5", "Trong nhà", 4], ["T6", "Trong nhà", 2],
  ["T7", "Trong nhà", 4], ["T8", "Trong nhà", 4], ["T9", "Trong nhà", 6],
  ["Sân vườn 1", "Sân vườn", 6], ["Sân vườn 2", "Sân vườn", 6],
];

const inDays = (n) => Timestamp.fromDate(new Date(Date.now() + n * 86400000));

async function main() {
  // Re-seeding starts clean, so demo data never duplicates.
  await fetch(`http://${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/demo-brewboss/databases/(default)/documents`, { method: "DELETE" });
  for (const [email, name, phone, role, active = true] of staff) {
    let user;
    try {
      user = await auth.getUserByEmail(email);
    } catch {
      user = await auth.createUser({ email, password: PASSWORD, displayName: name });
    }
    await db.doc(`users/${user.uid}`).set({
      name, email, phone, role, isActive: active, fcmTokens: [], createdAt: FieldValue.serverTimestamp(),
    });
  }

  const batch = db.batch();
  batch.set(db.doc("settings/shop"), {
    name: "BrewBoss", address: "12 Nguyễn Huệ, Q1",
    bankBin: "970436", bankAccountNo: "0123456789", bankAccountName: "NGUYEN VAN QUAN",
    lateOrderMinutes: 10, pointsPerVnd: 10000, vndPerPoint: 1000,
  });
  batch.set(db.doc("settings/public"), { name: "BrewBoss" });
  const categoryIds = categories.map((name, sortOrder) => {
    const ref = db.collection("categories").doc();
    batch.set(ref, { name, sortOrder });
    return ref.id;
  });
  for (const [id, name, unit, stock, minStock] of ingredients) {
    batch.set(db.doc(`ingredients/${id}`), { name, unit, stock, minStock });
  }
  for (const [name, category, description, basePrice, isAvailable, rec] of products) {
    batch.set(db.collection("products").doc(), {
      categoryId: categoryIds[category], name, description, basePrice, imageUrl: null, isAvailable,
      sizes: category === 3 ? [{ code: "S", priceDelta: 0 }] : sizes,
      toppings: category === 3 ? [] : toppings,
      recipe: rec,
    });
  }
  for (const [name, area, capacity] of tables) {
    batch.set(db.collection("tables").doc(), { name, area, capacity, currentOrderId: null });
  }
  batch.set(db.doc("vouchers/GIAM10"), {
    type: "percent", value: 10, maxDiscount: 20000, minOrder: 100000,
    expiresAt: inDays(60), usageLimit: 100, usedCount: 42, isActive: true,
  });
  batch.set(db.doc("vouchers/CHAOBAN"), {
    type: "fixed", value: 15000, maxDiscount: null, minOrder: 50000,
    expiresAt: inDays(30), usageLimit: 200, usedCount: 88, isActive: true,
  });
  batch.set(db.doc("vouchers/TET2026"), {
    type: "percent", value: 20, maxDiscount: null, minOrder: 0,
    expiresAt: inDays(-30), usageLimit: 50, usedCount: 50, isActive: false,
  });
  batch.set(db.doc("customers/0912345678"), { name: "Anh Tuấn", phone: "0912345678", points: 120, visitCount: 24 });
  batch.set(db.doc("customers/0987111222"), { name: "Chị Ngọc", phone: "0987111222", points: 86, visitCount: 17 });
  batch.set(db.doc("customers/0909555444"), { name: null, phone: "0909555444", points: 12, visitCount: 3 });
  await batch.commit();
  console.log(`Seeded. Log in with ${staff.map((s) => s[0]).join(", ")} / password ${PASSWORD}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
