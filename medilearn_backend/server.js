const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

const authRoutes = require("./routes/auth");
const announcementRoutes = require("./routes/announcements");
const materialRoutes = require("./routes/materials");
const questionRoutes = require("./routes/questions");
const quizRoutes = require("./routes/quizzes");
const quizResultRoutes = require("./routes/quizResults");
const messageRoutes = require("./routes/messages");
const notificationRoutes = require("./routes/notificationRoutes");
const aiReportRoutes = require("./routes/aiReportRoutes");
const registerRoutes = require("./routes/register");
const offeringRoutes = require("./routes/CourseOffering");
const subjectRoutes  = require("./routes/subjects");
const clinicalResultRoutes = require("./routes/clinicalResults");
const app = express();

// CORS Configuration
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'x-admin-id', 'x-doctor-id', 'x-user-id'],
}));

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

app.use("/api/auth", authRoutes);
app.use("/api/announcements", announcementRoutes);
app.use("/api/materials", materialRoutes);
app.use("/api/questions", questionRoutes);
app.use("/api/quizzes", quizRoutes);
app.use("/api/quiz-results", quizResultRoutes);
app.use("/api/messages", messageRoutes);
app.use("/api/notifications", notificationRoutes);

app.use("/api/leaderboard", require("./routes/leaderboard"));
app.use("/api/profile", require("./routes/profile"));
app.use("/api/ai", require("./routes/ai"));
app.use("/api/ai", aiReportRoutes);

// Admin system (pre-approve students, send emails)
app.use("/api/admin", require("./routes/admin"));

// Student subject registration system
app.use("/api/register", registerRoutes);
app.use("/api/offerings", offeringRoutes);
app.use("/api/subjects",  subjectRoutes);
app.use("/api/clinical-results", clinicalResultRoutes);

app.get("/", (req, res) => {
  res.send("MediLearn Backend API is running");
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error("Server Error:", err);
  res.status(err.status || 500).json({
    message: err.message || "Server error",
    error: process.env.NODE_ENV === "development" ? err : {}
  });
});

const PORT = process.env.PORT || 5000;

mongoose
  .connect(process.env.MONGO_URI)
  .then(() => {
    console.log("MongoDB connected");
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((error) => {
    console.error("✗ MongoDB connection error:", error.message);
    process.exit(1);
  });