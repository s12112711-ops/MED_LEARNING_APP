const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
require("dotenv").config();

const User = require("./models/User");

async function fixUsers() {
  await mongoose.connect(process.env.MONGO_URI);
  console.log("MongoDB connected\n");

  const users = await User.find({});
  console.log(`Found ${users.length} users to fix...\n`);

  let fixed = 0;

  for (const user of users) {
    const updates = {};

    // Fix 1a: copy universityId → studentId if studentId is empty (students)
    if (user.role === "student" && (!user.studentId || user.studentId === "") && user.universityId) {
      updates.studentId = user.universityId;
      console.log(`  [${user.fullName}] studentId set to: ${user.universityId}`);
    }

    // Fix 1b: copy email → doctorId if doctorId is empty (doctors)
    if (user.role === "doctor" && (!user.doctorId || user.doctorId === "") && user.email) {
      updates.doctorId = user.email;
      console.log(`  [${user.fullName}] doctorId set to: ${user.email}`);
    }

    // Fix 2: hash plain text password (bcrypt hashes start with $2b$ or $2a$)
    const isAlreadyHashed = user.password && (user.password.startsWith("$2b$") || user.password.startsWith("$2a$"));
    if (!isAlreadyHashed && user.password) {
      updates.password = await bcrypt.hash(user.password, 10);
      console.log(`  [${user.fullName}] password hashed`);
    }

    if (Object.keys(updates).length > 0) {
      await User.updateOne({ _id: user._id }, { $set: updates });
      fixed++;
    } else {
      console.log(`  [${user.fullName}] already OK — skipped`);
    }
  }

  console.log(`\n✅ Done! Fixed ${fixed}/${users.length} users.`);
  console.log("\nLogin credentials:");
  console.log("  Student  → University ID from Compass  | Password: same as before (now hashed)");
  console.log("  Admin    → Email from Compass           | Password: same as before (now hashed)");
  console.log("  Doctor   → Doctor email from Compass   | Password: same as before (now hashed)");

  await mongoose.disconnect();
}

fixUsers().catch((e) => { console.error("Error:", e.message); process.exit(1); });
