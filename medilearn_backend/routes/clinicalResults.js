const express = require("express");
const router = express.Router();
const ClinicalResult = require("../models/ClinicalResult");

// POST /api/clinical-results/save
router.post("/save", async (req, res) => {
  try {
    const {
      studentName,
      caseTitle,
      diagnosisSelected,
      firstActionSelected,
      selectedInvestigations,
      score,
      performanceLabel,
    } = req.body;

    if (!studentName || !caseTitle || !diagnosisSelected || !firstActionSelected || score === undefined || !performanceLabel) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const result = new ClinicalResult({
      studentName,
      caseTitle,
      diagnosisSelected,
      firstActionSelected,
      selectedInvestigations: selectedInvestigations || [],
      score,
      performanceLabel,
    });

    await result.save();

    res.status(201).json({ message: "Clinical result saved successfully", data: result });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET /api/clinical-results/student/:studentName
router.get("/student/:studentName", async (req, res) => {
  try {
    const results = await ClinicalResult.find({
      studentName: req.params.studentName,
    }).sort({ createdAt: -1 });

    res.status(200).json({ data: results });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
