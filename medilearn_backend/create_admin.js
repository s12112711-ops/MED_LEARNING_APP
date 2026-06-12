require("dotenv").config();
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const User = require("./models/User");

async function createAdmin() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("Connected to MongoDB");

    // Hash the password
    const hashedPassword = await bcrypt.hash("admin123", 10);

    // Try to update existing admin, or create new one
    const result = await User.findOneAndUpdate(
      { role: "admin", email: "admin@medilearn.com" },
      {
        fullName: "Admin",
        email: "admin@medilearn.com",
        password: hashedPassword,
        role: "admin",
        isActive: true
      },
      { upsert: true, new: true }
    );

    console.log("✓ Admin user ready");
    console.log("Email: admin@medilearn.com");
    console.log("Password: admin123");
    console.log("\n⚠️ Please change this password after first login!");
    
    process.exit(0);
  } catch (error) {
    console.error("Error creating admin:", error);
    process.exit(1);
  }
}

createAdmin();
