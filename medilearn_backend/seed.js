const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
require("dotenv").config();

const User = require("./models/User");
const ApprovedStudent = require("./models/ApprovedStudent");

async function seed() {
  await mongoose.connect(process.env.MONGO_URI);
  console.log("MongoDB connected");

  const pass = await bcrypt.hash("123456", 10);

  // Admin
  const existingAdmin = await User.findOne({ role: "admin" });
  if (!existingAdmin) {
    await User.create({
      fullName: "Admin",
      email: "admin@medilearn.com",
      password: pass,
      role: "admin",
      studentId: "",
      doctorId: "",
    });
    console.log("✅ Admin created: admin@medilearn.com / 123456");
  } else {
    console.log("ℹ️  Admin already exists");
  }

  // Approved student
  const existingApproved = await ApprovedStudent.findOne({ studentId: "2021001" });
  if (!existingApproved) {
    await ApprovedStudent.create({
      studentId: "2021001",
      fullName: "Test Student",
      email: "student@test.com",
      yearLevel: "Year 1",
      isRegistered: false,
    });
    console.log("✅ ApprovedStudent 2021001 added");
  } else {
    console.log("ℹ️  ApprovedStudent 2021001 already exists");
  }

  // Student user (so they can login directly without Sign Up)
  const existingStudent = await User.findOne({ studentId: "2021001", role: "student" });
  if (!existingStudent) {
    await User.create({
      fullName: "Test Student",
      email: "student@test.com",
      password: pass,
      role: "student",
      studentId: "2021001",
      doctorId: "",
      yearLevel: "Year 1",
    });
    // Mark as registered
    await ApprovedStudent.updateOne({ studentId: "2021001" }, { isRegistered: true });
    console.log("✅ Student user created: ID=2021001 / password=123456");
  } else {
    console.log("ℹ️  Student 2021001 already exists");
  }

  console.log("\n🎉 Done! Login with:");
  console.log("   Student  → ID: 2021001      | Password: 123456");
  console.log("   Admin    → Email: admin@medilearn.com | Password: 123456");

  await mongoose.disconnect();
}

seed().catch((e) => { console.error(e); process.exit(1); });
