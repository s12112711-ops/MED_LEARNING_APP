const mongoose = require("mongoose");

const clinicalResultSchema = new mongoose.Schema(
  {
    studentName: { type: String, required: true, trim: true },
    caseTitle: { type: String, required: true, trim: true },
    diagnosisSelected: { type: String, required: true },
    firstActionSelected: { type: String, required: true },
    selectedInvestigations: { type: [String], default: [] },
    score: { type: Number, required: true },
    performanceLabel: { type: String, required: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model("ClinicalResult", clinicalResultSchema);
