require("dotenv").config();
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const User = require("./models/User");

async function verifyAdmin() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("Connected to MongoDB");

    // Check current admin
    const admin = await User.findOne({ role: "admin", email: "admin@medilearn.com" });
    
    if (!admin) {
      console.log("No admin found! Creating one...");
      const hashedPassword = await bcrypt.hash("admin123", 10);
      const newAdmin = new User({
        fullName: "Admin",
        email: "admin@medilearn.com",
        password: hashedPassword,
        role: "admin"
      });
      await newAdmin.save();
      console.log("✓ Admin created");
    } else {
      console.log("Admin found. Current info:");
      console.log("- ID:", admin._id);
      console.log("- Email:", admin.email);
      console.log("- Full Name:", admin.fullName);
      
      // Reset password
      const hashedPassword = await bcrypt.hash("admin123", 10);
      admin.password = hashedPassword;
      await admin.save();
      console.log("✓ Password reset to: admin123");
    }

    console.log("\n✓ Admin is ready!");
    console.log("Email: admin@medilearn.com");
    console.log("Password: admin123");
    
    process.exit(0);
  } catch (error) {
    console.error("Error:", error.message);
    process.exit(1);
  }
}

verifyAdmin();
