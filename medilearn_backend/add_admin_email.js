require("dotenv").config();
const mongoose = require("mongoose");
const User = require("./models/User");

async function main() {
  await mongoose.connect(process.env.MONGO_URI);
  const result = await User.updateOne(
    { role: "admin" },
    { $set: { email: "admin@medilearn.com" } }
  );
  console.log("Done:", result.modifiedCount ? "Email added ✓" : "No change (already set?)");
  process.exit(0);
}

main().catch((e) => { console.error(e); process.exit(1); });
