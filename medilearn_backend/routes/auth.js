const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const User = require("../models/User");
const ApprovedStudent = require("../models/ApprovedStudent");

// REGISTER
router.post("/register", async (req, res) => {
  try {
    const {
      fullName,
      email,
      password,
      role,
      studentId,
      doctorId,
      specialization,
      yearLevel,
    } = req.body;

    if (!fullName || !password || !role) {
      return res.status(400).json({
        message: "Full name, password and role are required",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    if (role === "student") {
      if (!studentId) {
        return res.status(400).json({
          message: "Student ID is required",
        });
      }

      // Check pre-approval by admin
      const approved = await ApprovedStudent.findOne({
        studentId: studentId.trim(),
      });
      if (!approved) {
        return res.status(403).json({
          message: "رقم الطالب غير مسجّل في النظام. راجع إدارة الكلية.",
        });
      }
      if (approved.isRegistered) {
        return res.status(409).json({
          message: "هذا الرقم مسجّل مسبقاً. حاول تسجيل الدخول.",
        });
      }

      const existingStudent = await User.findOne({
        studentId: studentId.trim(),
        role: "student",
      });
      if (existingStudent) {
        return res.status(400).json({ message: "Student ID already exists" });
      }

      const newUser = new User({
        fullName,
        password: hashedPassword,
        role: "student",
        studentId: studentId.trim(),
        email: approved.email,
        doctorId: "",
        specialization: specialization || "",
        yearLevel: approved.yearLevel || yearLevel || "",
      });
      await newUser.save();

      // Mark as registered
      approved.isRegistered = true;
      await approved.save();

      return res.status(201).json({
        message: "Student account created successfully",
        _id: newUser._id,
        fullName: newUser.fullName,
        studentId: newUser.studentId,
        role: newUser.role,
      });
    }

    if (role === "doctor") {
      // doctorId defaults to email if not explicitly provided
      const resolvedDoctorId = (doctorId || email || "").trim();
      if (!resolvedDoctorId) {
        return res.status(400).json({ message: "Email is required for doctor accounts" });
      }

      const existingDoctor = await User.findOne({
        doctorId: resolvedDoctorId,
        role: "doctor",
      });
      if (existingDoctor) {
        return res.status(400).json({ message: "Doctor account already exists" });
      }

      const newUser = new User({
        fullName,
        password: hashedPassword,
        role: "doctor",
        doctorId: resolvedDoctorId,
        email: resolvedDoctorId,
        studentId: "",
        specialization: specialization || "",
        yearLevel: "",
      });
      await newUser.save();

      return res.status(201).json({
        message: "Doctor account created successfully",
        _id: newUser._id,
        fullName: newUser.fullName,
        doctorId: newUser.doctorId,
        role: newUser.role,
      });
    }

    if (role === "admin") {
      if (!email || !email.includes("@")) {
        return res.status(400).json({ message: "Email is required for admin accounts" });
      }
      const existingAdmin = await User.findOne({ email: email.trim().toLowerCase(), role: "admin" });
      if (existingAdmin) {
        return res.status(409).json({ message: "Admin account with this email already exists" });
      }
      const newUser = new User({
        fullName,
        password: hashedPassword,
        role: "admin",
        email: email.trim().toLowerCase(),
        studentId: "",
        doctorId: "",
      });

      await newUser.save();

      return res.status(201).json({
        message: "Admin account created successfully",
        _id: newUser._id,
        fullName: newUser.fullName,
        role: newUser.role,
      });
    }

    return res.status(400).json({
      message: "Invalid role",
    });
  } catch (error) {
    console.error("REGISTER ERROR:", error);
    res.status(500).json({
      message: "Server error during registration",
      error: error.message,
    });
  }
});

// LOGIN
router.post("/login", async (req, res) => {
  try {
    const { password, role } = req.body;
    const identifier = (req.body.identifier || req.body.email || "").trim();

    console.log("Login Attempt:", { identifier, role });

    if (!identifier || !password || !role) {
      return res.status(400).json({
        message: "Email/ID, password and role are required",
      });
    }

    let user = null;

    if (role === "student") {
      user = await User.findOne({
        studentId: identifier,
        role: "student",
      });
    } else if (role === "doctor") {
      user = await User.findOne({
        doctorId: identifier,
        role: "doctor",
      });
    } else if (role === "admin") {
      user = await User.findOne({
        email: identifier,
        role: "admin",
      });
      console.log("Admin search result:", user ? "Found" : "Not found");
    } else {
      return res.status(400).json({
        message: "Invalid role",
      });
    }

    if (!user) {
      return res.status(404).json({
        message: role === "student" ? "Student not found" : role === "doctor" ? "Doctor not found" : "Admin not found",
      });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({
        message: "Invalid password",
      });
    }

    console.log("Login successful:", { userId: user._id, role: user.role });
    res.status(200).json({
      message: "Login successful",
      _id: user._id,
      fullName: user.fullName,
      role: user.role,
      email: user.email,
      studentId: user.studentId || "",
      doctorId: user.doctorId || "",
    });
  } catch (error) {
    console.error("LOGIN ERROR:", error);
    res.status(500).json({
      message: "Server error during login",
      error: error.message,
    });
  }
});

module.exports = router;
