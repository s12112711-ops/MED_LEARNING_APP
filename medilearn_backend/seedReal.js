/**
 * Real Seed Data — An-Najah National University
 * Faculty of Medicine and Health Sciences — Nablus, Palestine
 *
 * Run: node seedReal.js
 */

require("dotenv").config();
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const User               = require("./models/User");
const ApprovedStudent    = require("./models/ApprovedStudent");
const Subject            = require("./models/Subject");
const CourseOffering     = require("./models/CourseOffering");
const Register           = require("./models/Register");
const Question           = require("./models/Question");
const Quiz               = require("./models/Quiz");
const QuizResult         = require("./models/QuizResult");
const Material           = require("./models/Material");
const Announcement       = require("./models/Announcement");
const DoctorProfile      = require("./models/DoctorProfile");
const DoctorEvaluationCase = require("./models/DoctorEvaluationCase");
const ClinicalResult     = require("./models/ClinicalResult");
const Message            = require("./models/Message");

// ─── helpers ──────────────────────────────────────────────────────────────────
const hash = (p) => bcrypt.hash(p, 10);

async function clearAll() {
  await Promise.all([
    User.deleteMany({}),
    ApprovedStudent.deleteMany({}),
    Subject.deleteMany({}),
    CourseOffering.deleteMany({}),
    Register.deleteMany({}),
    Question.deleteMany({}),
    Quiz.deleteMany({}),
    QuizResult.deleteMany({}),
    Material.deleteMany({}),
    Announcement.deleteMany({}),
    DoctorProfile.deleteMany({}),
    DoctorEvaluationCase.deleteMany({}),
    ClinicalResult.deleteMany({}),
    Message.deleteMany({}),
  ]);
  console.log("🧹 All collections cleared");
}

// ─── MAIN ─────────────────────────────────────────────────────────────────────
async function seed() {
  await mongoose.connect(process.env.MONGO_URI);
  console.log("✅ MongoDB connected\n");

  await clearAll();

  const pass = await hash("123456");

  // ══════════════════════════════════════════════════════════════════════════
  // 1. ADMIN
  // ══════════════════════════════════════════════════════════════════════════
  const admin = await User.create({
    fullName: "Dr. Raed Awad",
    email: "admin@najah.edu",
    password: pass,
    role: "admin",
    studentId: "",
    doctorId: "",
  });
  console.log("✅ Admin created:  admin@najah.edu  /  123456");

  // ══════════════════════════════════════════════════════════════════════════
  // 2. DOCTORS
  // ══════════════════════════════════════════════════════════════════════════
  const doctorsData = [
    {
      fullName: "Dr. Abdel Fattah Tabash",
      email: "a.tabash@najah.edu",
      specialization: "Surgery",
      department: "Department of Surgery",
      title: "Associate Professor",
      licenseNumber: "PS-MED-0042",
      yearsOfExperience: 18,
      academicDegree: "MD, FRCS",
      hospitalAffiliation: "Rafidia Governmental Hospital",
      bio: "Specialist in general and laparoscopic surgery with extensive experience in the West Bank medical community.",
      priorityLevel: "senior",
    },
    {
      fullName: "Dr. Saed Zyoud",
      email: "s.zyoud@najah.edu",
      specialization: "Pharmacology",
      department: "Department of Pharmacy",
      title: "Professor",
      licenseNumber: "PS-MED-0091",
      yearsOfExperience: 22,
      academicDegree: "PhD, PharmD",
      hospitalAffiliation: "An-Najah University Hospital",
      bio: "Professor of Clinical Pharmacology and Toxicology. Research focus on drug utilization and pharmaceutical care.",
      priorityLevel: "senior",
    },
    {
      fullName: "Dr. Walid Sawalha",
      email: "w.sawalha@najah.edu",
      specialization: "Internal Medicine",
      department: "Department of Internal Medicine",
      title: "Assistant Professor",
      licenseNumber: "PS-MED-0133",
      yearsOfExperience: 14,
      academicDegree: "MD, MRCP",
      hospitalAffiliation: "An-Najah University Hospital",
      bio: "Internist with expertise in endocrinology and diabetes management in the Palestinian population.",
      priorityLevel: "mid",
    },
    {
      fullName: "Dr. Ramzi Abdel Fattah",
      email: "r.abdelfattah@najah.edu",
      specialization: "Cardiology",
      department: "Department of Medicine",
      title: "Associate Professor",
      licenseNumber: "PS-MED-0187",
      yearsOfExperience: 20,
      academicDegree: "MD, FACC",
      hospitalAffiliation: "Rafidia Governmental Hospital",
      bio: "Interventional cardiologist with special interest in echocardiography and cardiac rehabilitation.",
      priorityLevel: "senior",
    },
    {
      fullName: "Dr. Lina Mezyed",
      email: "l.mezyed@najah.edu",
      specialization: "Obstetrics & Gynecology",
      department: "Department of Obstetrics",
      title: "Assistant Professor",
      licenseNumber: "PS-MED-0210",
      yearsOfExperience: 12,
      academicDegree: "MD, MRCOG",
      hospitalAffiliation: "Watani Hospital Nablus",
      bio: "OB/GYN specialist focused on high-risk pregnancies and minimally invasive gynecological surgery.",
      priorityLevel: "mid",
    },
  ];

  const doctors = [];
  for (const d of doctorsData) {
    const user = await User.create({
      fullName: d.fullName,
      email: d.email,
      password: pass,
      role: "doctor",
      studentId: "",
      doctorId: d.email,
      specialization: d.specialization,
    });
    const profile = await DoctorProfile.create({
      userId: user._id,
      doctorName: d.fullName,
      specialization: d.specialization,
      department: d.department,
      title: d.title,
      licenseNumber: d.licenseNumber,
      yearsOfExperience: d.yearsOfExperience,
      academicDegree: d.academicDegree,
      hospitalAffiliation: d.hospitalAffiliation,
      bio: d.bio,
      availableForReview: true,
      priorityLevel: d.priorityLevel,
    });
    doctors.push({ user, profile });
    console.log(`✅ Doctor: ${d.fullName}  →  ${d.email}  /  123456`);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 3. APPROVED STUDENTS  (pre-registered by admin)
  // ══════════════════════════════════════════════════════════════════════════
  const approvedStudentsData = [
    { studentId: "2021001", fullName: "Mohammed Al-Masri",   email: "m.masri@student.najah.edu",   yearLevel: "Year 3" },
    { studentId: "2021002", fullName: "Lina Khalil",         email: "l.khalil@student.najah.edu",  yearLevel: "Year 3" },
    { studentId: "2021003", fullName: "Omar Barakat",        email: "o.barakat@student.najah.edu", yearLevel: "Year 3" },
    { studentId: "2021004", fullName: "Sara Nabulsi",        email: "s.nabulsi@student.najah.edu", yearLevel: "Year 3" },
    { studentId: "2021005", fullName: "Ahmad Haddad",        email: "a.haddad@student.najah.edu",  yearLevel: "Year 3" },
    { studentId: "2022001", fullName: "Rima Jaradat",        email: "r.jaradat@student.najah.edu", yearLevel: "Year 2" },
    { studentId: "2022002", fullName: "Khaled Mansour",      email: "k.mansour@student.najah.edu", yearLevel: "Year 2" },
    { studentId: "2022003", fullName: "Haya Samhan",         email: "h.samhan@student.najah.edu",  yearLevel: "Year 2" },
    { studentId: "2023001", fullName: "Yousef Qasim",        email: "y.qasim@student.najah.edu",   yearLevel: "Year 1" },
    { studentId: "2023002", fullName: "Nour Arafat",         email: "n.arafat@student.najah.edu",  yearLevel: "Year 1" },
  ];

  for (const s of approvedStudentsData) {
    await ApprovedStudent.create({ ...s, isRegistered: true });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 4. STUDENT USERS
  // ══════════════════════════════════════════════════════════════════════════
  const students = [];
  for (const s of approvedStudentsData) {
    const user = await User.create({
      fullName: s.fullName,
      email: s.email,
      password: pass,
      role: "student",
      studentId: s.studentId,
      yearLevel: s.yearLevel,
      universityId: `NAJAH-${s.studentId}`,
    });
    students.push(user);
  }
  console.log(`✅ ${students.length} student accounts created  (ID: 2021001–2023002  /  123456)`);

  // ══════════════════════════════════════════════════════════════════════════
  // 5. SUBJECTS  —  Faculty of Medicine & Health Sciences, An-Najah
  // ══════════════════════════════════════════════════════════════════════════
  const subjectsData = [
    {
      subjectCode: "MED101",
      subjectName: "Introduction to Medical Sciences",
      description: "Foundation course covering medical terminology, history of medicine, and the basic structure of the human body.",
      prerequisites: [],
    },
    {
      subjectCode: "ANAT201",
      subjectName: "Human Anatomy",
      description: "Systematic study of the structure of the human body including musculoskeletal, cardiovascular, and nervous systems.",
      prerequisites: ["MED101"],
    },
    {
      subjectCode: "PHYS202",
      subjectName: "Human Physiology",
      description: "Study of normal functions of organ systems including the cardiovascular, respiratory, renal, and endocrine systems.",
      prerequisites: ["MED101"],
    },
    {
      subjectCode: "BIOC203",
      subjectName: "Medical Biochemistry",
      description: "Chemistry of biological processes: metabolism, enzyme kinetics, molecular biology, and clinical biochemistry.",
      prerequisites: ["MED101"],
    },
    {
      subjectCode: "PATH301",
      subjectName: "General Pathology",
      description: "Study of disease mechanisms including cell injury, inflammation, neoplasia, and hemodynamic disorders.",
      prerequisites: ["ANAT201", "PHYS202"],
    },
    {
      subjectCode: "MICRO302",
      subjectName: "Medical Microbiology",
      description: "Bacteriology, virology, mycology, and parasitology with clinical correlations to infectious disease.",
      prerequisites: ["BIOC203"],
    },
    {
      subjectCode: "PHARM303",
      subjectName: "Pharmacology",
      description: "Mechanisms of drug action, pharmacokinetics, pharmacodynamics, and clinical applications of major drug classes.",
      prerequisites: ["PHYS202", "BIOC203"],
    },
    {
      subjectCode: "INTM401",
      subjectName: "Internal Medicine",
      description: "Diagnosis and management of adult diseases including cardiology, pulmonology, gastroenterology, and nephrology.",
      prerequisites: ["PATH301", "MICRO302", "PHARM303"],
    },
  ];

  const subjects = await Subject.insertMany(subjectsData.map(s => ({ ...s, isActive: true })));
  console.log(`✅ ${subjects.length} subjects created`);

  // ══════════════════════════════════════════════════════════════════════════
  // 6. COURSE OFFERINGS
  // ══════════════════════════════════════════════════════════════════════════
  const semester = "Spring 2025";
  const offeringsData = [
    { doctorIdx: 0, subjectCode: "ANAT201", subjectName: "Human Anatomy",           section: "A", sectionNo: 1, time: "Sun/Tue  08:00–09:30" },
    { doctorIdx: 0, subjectCode: "INTM401", subjectName: "Internal Medicine",        section: "A", sectionNo: 1, time: "Mon/Wed  10:00–11:30" },
    { doctorIdx: 1, subjectCode: "PHARM303", subjectName: "Pharmacology",            section: "A", sectionNo: 1, time: "Sun/Tue  10:00–11:30" },
    { doctorIdx: 1, subjectCode: "BIOC203", subjectName: "Medical Biochemistry",     section: "B", sectionNo: 2, time: "Mon/Thu  12:00–13:30" },
    { doctorIdx: 2, subjectCode: "INTM401", subjectName: "Internal Medicine",        section: "B", sectionNo: 2, time: "Tue/Thu  08:00–09:30" },
    { doctorIdx: 2, subjectCode: "PHYS202", subjectName: "Human Physiology",         section: "A", sectionNo: 1, time: "Mon/Wed  08:00–09:30" },
    { doctorIdx: 3, subjectCode: "PATH301", subjectName: "General Pathology",        section: "A", sectionNo: 1, time: "Sun/Wed  12:00–13:30" },
    { doctorIdx: 4, subjectCode: "MICRO302", subjectName: "Medical Microbiology",    section: "A", sectionNo: 1, time: "Tue/Thu  10:00–11:30" },
  ];

  const offerings = [];
  for (const o of offeringsData) {
    const doc = doctors[o.doctorIdx].user;
    const offering = await CourseOffering.create({
      doctorId: doc._id.toString(),
      doctorName: doc.fullName,
      subjectCode: o.subjectCode,
      subjectName: o.subjectName,
      sectionName: o.section,
      sectionNumber: o.sectionNo,
      time: o.time,
      semester,
      isOpen: true,
    });
    offerings.push(offering);
  }
  console.log(`✅ ${offerings.length} course offerings created`);

  // ══════════════════════════════════════════════════════════════════════════
  // 7. REGISTRATIONS
  // ══════════════════════════════════════════════════════════════════════════
  const regData = [
    // Year 3 students register for Path, Micro, Pharm, Internal Medicine
    { stuIdx: 0, offerIdx: 6 }, { stuIdx: 0, offerIdx: 7 }, { stuIdx: 0, offerIdx: 2 }, { stuIdx: 0, offerIdx: 4 },
    { stuIdx: 1, offerIdx: 6 }, { stuIdx: 1, offerIdx: 7 }, { stuIdx: 1, offerIdx: 2 }, { stuIdx: 1, offerIdx: 1 },
    { stuIdx: 2, offerIdx: 6 }, { stuIdx: 2, offerIdx: 7 }, { stuIdx: 2, offerIdx: 3 }, { stuIdx: 2, offerIdx: 4 },
    { stuIdx: 3, offerIdx: 6 }, { stuIdx: 3, offerIdx: 7 }, { stuIdx: 3, offerIdx: 2 }, { stuIdx: 3, offerIdx: 1 },
    { stuIdx: 4, offerIdx: 6 }, { stuIdx: 4, offerIdx: 7 }, { stuIdx: 4, offerIdx: 3 }, { stuIdx: 4, offerIdx: 4 },
    // Year 2 students register for Anatomy, Physiology, Biochemistry
    { stuIdx: 5, offerIdx: 0 }, { stuIdx: 5, offerIdx: 5 }, { stuIdx: 5, offerIdx: 3 },
    { stuIdx: 6, offerIdx: 0 }, { stuIdx: 6, offerIdx: 5 }, { stuIdx: 6, offerIdx: 3 },
    { stuIdx: 7, offerIdx: 0 }, { stuIdx: 7, offerIdx: 5 }, { stuIdx: 7, offerIdx: 3 },
  ];

  for (const r of regData) {
    const stu = students[r.stuIdx];
    const off = offerings[r.offerIdx];
    try {
      await Register.create({
        studentId: stu.studentId,
        studentName: stu.fullName,
        subjectCode: off.subjectCode,
        subjectName: off.subjectName,
        doctorId: off.doctorId,
        doctorName: off.doctorName,
        sectionName: off.sectionName,
        semester,
        isActive: true,
        status: "active",
      });
    } catch (_) {}
  }
  console.log("✅ Course registrations created");

  // ══════════════════════════════════════════════════════════════════════════
  // 8. QUESTIONS
  // ══════════════════════════════════════════════════════════════════════════
  const questionsData = [
    // ── ANATOMY ───────────────────────────────────────────────────────────
    { questionText: "Which nerve is most commonly injured in a humeral shaft fracture?", options: ["Radial nerve", "Median nerve", "Ulnar nerve", "Musculocutaneous nerve"], correctAnswer: "A", explanation: "The radial nerve winds around the posterior aspect of the humerus in the spiral groove and is prone to injury in mid-shaft fractures.", subject: "ANAT201", topic: "Upper Limb", difficulty: "medium", createdBy: doctors[0].user._id },
    { questionText: "The femoral triangle is bounded laterally by:", options: ["Adductor longus", "Sartorius", "Inguinal ligament", "Iliopsoas"], correctAnswer: "B", explanation: "The femoral triangle is bounded medially by adductor longus, laterally by sartorius, and superiorly by the inguinal ligament.", subject: "ANAT201", topic: "Lower Limb", difficulty: "easy", createdBy: doctors[0].user._id },
    { questionText: "Which structure passes through the carpal tunnel?", options: ["Ulnar nerve", "Radial artery", "Median nerve", "Palmaris longus tendon"], correctAnswer: "C", explanation: "The median nerve and flexor tendons pass through the carpal tunnel. The ulnar nerve passes through Guyon's canal.", subject: "ANAT201", topic: "Upper Limb", difficulty: "easy", createdBy: doctors[0].user._id },
    { questionText: "The coronary sinus drains into the:", options: ["Left atrium", "Right atrium", "Left ventricle", "Right ventricle"], correctAnswer: "B", explanation: "The coronary sinus is the largest vein of the heart and drains into the right atrium between the inferior vena cava and the tricuspid valve.", subject: "ANAT201", topic: "Thorax", difficulty: "medium", createdBy: doctors[0].user._id },
    { questionText: "Which part of the brain is responsible for coordination and balance?", options: ["Cerebrum", "Hypothalamus", "Cerebellum", "Medulla oblongata"], correctAnswer: "C", explanation: "The cerebellum coordinates voluntary movements, balance, and fine motor control.", subject: "ANAT201", topic: "Neuroanatomy", difficulty: "easy", createdBy: doctors[0].user._id },

    // ── PHYSIOLOGY ────────────────────────────────────────────────────────
    { questionText: "Normal resting cardiac output in a 70 kg adult is approximately:", options: ["2–3 L/min", "5–6 L/min", "8–10 L/min", "12–15 L/min"], correctAnswer: "B", explanation: "Cardiac output = heart rate × stroke volume. At rest: ~70 bpm × 70 mL ≈ 5 L/min.", subject: "PHYS202", topic: "Cardiovascular", difficulty: "easy", createdBy: doctors[2].user._id },
    { questionText: "Which ion is primarily responsible for the resting membrane potential of neurons?", options: ["Na⁺", "Ca²⁺", "Cl⁻", "K⁺"], correctAnswer: "D", explanation: "K⁺ leaks out through resting K⁺ channels creating a negative interior potential (~−70 mV).", subject: "PHYS202", topic: "Neurophysiology", difficulty: "medium", createdBy: doctors[2].user._id },
    { questionText: "The primary stimulus for increased ventilation during exercise is:", options: ["Decreased PO₂", "Increased PCO₂ and H⁺", "Decreased plasma pH only", "Increased body temperature only"], correctAnswer: "B", explanation: "Rising CO₂ and H⁺ stimulate central and peripheral chemoreceptors, driving the increase in ventilation during exercise.", subject: "PHYS202", topic: "Respiratory", difficulty: "hard", createdBy: doctors[2].user._id },
    { questionText: "Erythropoietin is produced primarily by:", options: ["Liver", "Bone marrow", "Kidney", "Spleen"], correctAnswer: "C", explanation: "Peritubular cells of the kidney produce ~90% of erythropoietin in response to hypoxia.", subject: "PHYS202", topic: "Renal", difficulty: "easy", createdBy: doctors[2].user._id },
    { questionText: "Insulin promotes which of the following?", options: ["Gluconeogenesis", "Lipolysis", "Glycogenolysis", "Glucose uptake by cells"], correctAnswer: "D", explanation: "Insulin promotes glucose uptake (via GLUT4 in muscle/adipose), glycogen synthesis, and inhibits gluconeogenesis.", subject: "PHYS202", topic: "Endocrine", difficulty: "easy", createdBy: doctors[2].user._id },

    // ── PHARMACOLOGY ──────────────────────────────────────────────────────
    { questionText: "Which class of drugs is first-line for heart failure with reduced ejection fraction?", options: ["Calcium channel blockers", "ACE inhibitors", "Digoxin", "Loop diuretics alone"], correctAnswer: "B", explanation: "ACE inhibitors (e.g., enalapril) reduce afterload and preload, decrease mortality, and are first-line in HFrEF.", subject: "PHARM303", topic: "Cardiovascular Drugs", difficulty: "medium", createdBy: doctors[1].user._id },
    { questionText: "Metformin's primary mechanism of action is:", options: ["Stimulating insulin secretion", "Inhibiting hepatic glucose production", "Blocking intestinal glucose absorption", "Increasing renal glucose excretion"], correctAnswer: "B", explanation: "Metformin activates AMPK and inhibits mitochondrial complex I, primarily reducing hepatic gluconeogenesis.", subject: "PHARM303", topic: "Endocrine Drugs", difficulty: "medium", createdBy: doctors[1].user._id },
    { questionText: "A patient on warfarin starts taking rifampicin. What do you expect?", options: ["INR increases — bleeding risk", "INR decreases — thrombosis risk", "No significant interaction", "Warfarin levels increase"], correctAnswer: "B", explanation: "Rifampicin induces CYP2C9, increasing warfarin metabolism and decreasing its anticoagulant effect (lower INR).", subject: "PHARM303", topic: "Drug Interactions", difficulty: "hard", createdBy: doctors[1].user._id },
    { questionText: "Which antibiotic inhibits cell wall synthesis by binding penicillin-binding proteins?", options: ["Ciprofloxacin", "Amoxicillin", "Azithromycin", "Metronidazole"], correctAnswer: "B", explanation: "Beta-lactam antibiotics including amoxicillin inhibit transpeptidases (PBPs) needed for peptidoglycan cross-linking.", subject: "PHARM303", topic: "Antibiotics", difficulty: "easy", createdBy: doctors[1].user._id },
    { questionText: "Aspirin at low dose (75–100 mg) works by:", options: ["Irreversibly inhibiting COX-1 in platelets", "Reversibly inhibiting COX-2", "Blocking thromboxane receptors", "Activating prostacyclin synthesis"], correctAnswer: "A", explanation: "Low-dose aspirin irreversibly acetylates platelet COX-1, preventing TXA₂ synthesis and aggregation for the platelet lifetime.", subject: "PHARM303", topic: "Antiplatelet Drugs", difficulty: "medium", createdBy: doctors[1].user._id },

    // ── PATHOLOGY ─────────────────────────────────────────────────────────
    { questionText: "The hallmark of irreversible cell injury is:", options: ["Cell swelling", "Nuclear pyknosis", "Mitochondrial swelling", "Membrane disruption with amorphous densities"], correctAnswer: "D", explanation: "Irreversible injury is confirmed by membrane disruption. Amorphous densities in mitochondria represent denatured proteins/lipids in mitochondria — a hallmark of irreversible injury.", subject: "PATH301", topic: "Cell Injury", difficulty: "hard", createdBy: doctors[3].user._id },
    { questionText: "Which type of necrosis is seen in tuberculosis?", options: ["Coagulative", "Liquefactive", "Caseous", "Fat necrosis"], correctAnswer: "C", explanation: "Caseous necrosis has a cheese-like appearance with complete loss of cellular architecture, characteristic of granulomatous infections like TB.", subject: "PATH301", topic: "Necrosis", difficulty: "easy", createdBy: doctors[3].user._id },
    { questionText: "The earliest change in acute myocardial infarction visible by electron microscopy:", options: ["Coagulative necrosis", "Mitochondrial swelling", "Neutrophil infiltration", "Macrophage infiltration"], correctAnswer: "B", explanation: "Mitochondrial swelling is the earliest ultrastructural change in ischemic injury, preceding light microscopic changes.", subject: "PATH301", topic: "Cardiovascular Pathology", difficulty: "hard", createdBy: doctors[3].user._id },
    { questionText: "A tumor that invades locally but rarely metastasizes is:", options: ["Benign", "In situ", "Locally malignant", "Highly malignant"], correctAnswer: "C", explanation: "Basal cell carcinoma is an example — locally invasive but with very low metastatic potential.", subject: "PATH301", topic: "Neoplasia", difficulty: "medium", createdBy: doctors[3].user._id },
    { questionText: "Amyloid fibrils in systemic AL amyloidosis are derived from:", options: ["Serum amyloid A", "Immunoglobulin light chains", "Beta-2 microglobulin", "Transthyretin"], correctAnswer: "B", explanation: "AL amyloid is derived from immunoglobulin light chains, typically in the context of plasma cell dyscrasias.", subject: "PATH301", topic: "Amyloidosis", difficulty: "hard", createdBy: doctors[3].user._id },

    // ── INTERNAL MEDICINE ─────────────────────────────────────────────────
    { questionText: "A 55-year-old man presents with central crushing chest pain radiating to the left arm, diaphoresis and nausea. ECG shows ST elevation in leads II, III and aVF. The diagnosis is:", options: ["NSTEMI", "Inferior STEMI", "Anterior STEMI", "Unstable angina"], correctAnswer: "B", explanation: "ST elevation in leads II, III, aVF localizes to the inferior wall of the left ventricle, supplied by the right coronary artery.", subject: "INTM401", topic: "Cardiology", difficulty: "easy", createdBy: doctors[2].user._id },
    { questionText: "First-line treatment for community-acquired pneumonia in an otherwise healthy outpatient:", options: ["Intravenous vancomycin", "Oral amoxicillin or amoxicillin-clavulanate", "Intravenous ceftriaxone", "Oral metronidazole"], correctAnswer: "B", explanation: "For mild CAP in outpatients without comorbidities, oral amoxicillin or a macrolide is first-line per IDSA/ATS guidelines.", subject: "INTM401", topic: "Pulmonology", difficulty: "medium", createdBy: doctors[2].user._id },
    { questionText: "Diagnostic criteria for diabetic ketoacidosis include all EXCEPT:", options: ["Blood glucose > 11 mmol/L", "pH < 7.3", "Bicarbonate < 15 mEq/L", "Blood glucose > 33 mmol/L with normal pH"], correctAnswer: "D", explanation: "Hyperglycaemic hyperosmolar state (HHS) features very high glucose (>33 mmol/L) with minimal acidosis. DKA requires acidosis and ketonemia.", subject: "INTM401", topic: "Endocrinology", difficulty: "hard", createdBy: doctors[2].user._id },
    { questionText: "Which finding is MOST specific for Helicobacter pylori gastritis?", options: ["Antral nodularity on endoscopy", "CLO (urease) test positive", "Elevated serum gastrin", "Epigastric tenderness on examination"], correctAnswer: "B", explanation: "A positive CLO/urease test is the most specific rapid test for active H. pylori infection.", subject: "INTM401", topic: "Gastroenterology", difficulty: "medium", createdBy: doctors[2].user._id },
  ];

  const questions = await Question.insertMany(questionsData);
  console.log(`✅ ${questions.length} questions created`);

  // ══════════════════════════════════════════════════════════════════════════
  // 9. QUIZZES
  // ══════════════════════════════════════════════════════════════════════════
  const anatQs    = questions.filter(q => q.subject === "ANAT201").map(q => q._id);
    const physQs    = questions.filter(q => q.subject === "PHYS202").map(q => q._id);
  const pharmQs   = questions.filter(q => q.subject === "PHARM303").map(q => q._id);
  const pathQs    = questions.filter(q => q.subject === "PATH301").map(q => q._id);
  const intmQs    = questions.filter(q => q.subject === "INTM401").map(q => q._id);

  const quizzesData = [
    {
      title: "Human Anatomy — Midterm Quiz",
      subject: "Human Anatomy",
      topic: "General Anatomy",
      description: "Covers upper limb, lower limb, thorax, and neuroanatomy for Year 2 midterm.",
      questions: anatQs,
      createdBy: doctors[0].user._id,
      createdByName: doctors[0].user.fullName,
      durationMinutes: 20,
      isPublished: true,
    },
    {
      title: "Pharmacology — Drug Mechanisms Quiz",
      subject: "Pharmacology",
      topic: "Drug Mechanisms",
      description: "Covers cardiovascular drugs, antibiotics, and drug interactions.",
      questions: pharmQs,
      createdBy: doctors[1].user._id,
      createdByName: doctors[1].user.fullName,
      durationMinutes: 25,
      isPublished: true,
    },
    {
      title: "General Pathology — Cell Injury & Neoplasia",
      subject: "General Pathology",
      topic: "Cell Injury and Neoplasia",
      description: "Covers necrosis types, irreversible injury, and amyloidosis.",
      questions: pathQs,
      createdBy: doctors[3].user._id,
      createdByName: doctors[3].user.fullName,
      durationMinutes: 25,
      isPublished: true,
    },
    {
      title: "Internal Medicine — Clinical Cases Quiz",
      subject: "Internal Medicine",
      topic: "Clinical Medicine",
      description: "Applied clinical questions covering cardiology, pulmonology, and gastroenterology.",
      questions: intmQs,
      createdBy: doctors[2].user._id,
      createdByName: doctors[2].user.fullName,
      durationMinutes: 30,
      isPublished: true,
    },
    {
      title: "Human Physiology — Systems Review",
      subject: "Human Physiology",
      topic: "Organ Systems",
      description: "Covers cardiovascular, respiratory, renal, and endocrine physiology.",
      questions: physQs,
      createdBy: doctors[2].user._id,
      createdByName: doctors[2].user.fullName,
      durationMinutes: 20,
      isPublished: true,
    },
  ];

  const quizzes = await Quiz.insertMany(quizzesData);
  console.log(`✅ ${quizzes.length} quizzes created`);

  // ══════════════════════════════════════════════════════════════════════════
  // 10. QUIZ RESULTS
  // ══════════════════════════════════════════════════════════════════════════
  const buildAnswers = (qs, correctRate) =>
    qs.map((q, i) => ({
      questionId: q._id,
      selectedAnswer: Math.random() < correctRate ? q.correctAnswer : (q.correctAnswer === "A" ? "B" : "A"),
      correctAnswer: q.correctAnswer,
      isCorrect: Math.random() < correctRate,
    }));

  const resultData = [
    { stuIdx: 0, quizIdx: 0, score: 4, rate: 0.8 },
    { stuIdx: 1, quizIdx: 0, score: 3, rate: 0.6 },
    { stuIdx: 2, quizIdx: 0, score: 5, rate: 1.0 },
    { stuIdx: 0, quizIdx: 1, score: 4, rate: 0.8 },
    { stuIdx: 1, quizIdx: 1, score: 3, rate: 0.6 },
    { stuIdx: 2, quizIdx: 2, score: 4, rate: 0.8 },
    { stuIdx: 3, quizIdx: 2, score: 2, rate: 0.4 },
    { stuIdx: 4, quizIdx: 3, score: 3, rate: 0.75 },
    { stuIdx: 0, quizIdx: 3, score: 4, rate: 0.9 },
    { stuIdx: 5, quizIdx: 4, score: 4, rate: 0.8 },
    { stuIdx: 6, quizIdx: 4, score: 3, rate: 0.6 },
  ];

  for (const r of resultData) {
    const stu  = students[r.stuIdx];
    const quiz = quizzes[r.quizIdx];
    const qs   = await Question.find({ _id: { $in: quiz.questions } });
    try {
      await QuizResult.create({
        quizId: quiz._id,
        studentId: stu._id.toString(),
        studentName: stu.fullName,
        score: r.score,
        totalQuestions: qs.length,
        answers: buildAnswers(qs, r.rate),
        submittedAt: new Date(),
      });
    } catch (_) {}
  }
  console.log("✅ Quiz results created");

  // ══════════════════════════════════════════════════════════════════════════
  // 11. MATERIALS
  // ══════════════════════════════════════════════════════════════════════════
  const materialsData = [
    { title: "Anatomy of the Upper Limb — Complete Lecture Notes", description: "Detailed PDF covering muscles, nerves, and vessels of the upper extremity.", subjectCode: "ANAT201", subjectName: "Human Anatomy", docIdx: 0, section: "A", topic: "Upper Limb", type: "pdf", fileUrl: "https://drive.google.com/file/d/anatomy_upper_limb_2025.pdf" },
    { title: "Cardiac Cycle — Animated Video", description: "Step-by-step animation of the cardiac cycle with pressure-volume loops.", subjectCode: "PHYS202", subjectName: "Human Physiology", docIdx: 2, section: "A", topic: "Cardiovascular", type: "video", fileUrl: "https://www.youtube.com/watch?v=cardiac_cycle_najah" },
    { title: "Drug Interactions in Clinical Practice — Lecture Slides", description: "PowerPoint slides covering major drug–drug and drug–food interactions.", subjectCode: "PHARM303", subjectName: "Pharmacology", docIdx: 1, section: "A", topic: "Drug Interactions", type: "pdf", fileUrl: "https://drive.google.com/file/d/pharm_interactions_2025.pdf" },
    { title: "Pathology Atlas — Necrosis & Cell Death (Illustrated)", description: "High-resolution histological images of coagulative, liquefactive, and caseous necrosis.", subjectCode: "PATH301", subjectName: "General Pathology", docIdx: 3, section: "A", topic: "Necrosis", type: "pdf", fileUrl: "https://drive.google.com/file/d/path_atlas_necrosis.pdf" },
    { title: "ECG Interpretation for Medical Students", description: "Step-by-step guide to reading ECGs with 20 practice cases.", subjectCode: "INTM401", subjectName: "Internal Medicine", docIdx: 2, section: "A", topic: "Cardiology", type: "pdf", fileUrl: "https://drive.google.com/file/d/ecg_guide_intm_2025.pdf" },
    { title: "Antibiotic Spectrum Chart — Quick Reference", description: "One-page reference chart for antibiotics, spectrum, and mechanism.", subjectCode: "PHARM303", subjectName: "Pharmacology", docIdx: 1, section: "A", topic: "Antibiotics", type: "pdf", fileUrl: "https://drive.google.com/file/d/antibiotic_spectrum.pdf" },
    { title: "Respiratory Physiology — Problem Set", description: "Practice problems on spirometry, gas exchange, and V/Q mismatch.", subjectCode: "PHYS202", subjectName: "Human Physiology", docIdx: 2, section: "A", topic: "Respiratory", type: "document", fileUrl: "https://drive.google.com/file/d/resp_physiology_problems.docx" },
    { title: "Internal Medicine Case Studies — Gastrointestinal", description: "Ten case studies on peptic ulcer, IBD, and hepatitis with full discussion.", subjectCode: "INTM401", subjectName: "Internal Medicine", docIdx: 2, section: "B", topic: "Gastroenterology", type: "pdf", fileUrl: "https://drive.google.com/file/d/gi_cases_intm.pdf" },
  ];

  for (const m of materialsData) {
    const doc = doctors[m.docIdx].user;
    await Material.create({
      title: m.title,
      description: m.description,
      subjectCode: m.subjectCode,
      subjectName: m.subjectName,
      doctorId: doc._id.toString(),
      doctorName: doc.fullName,
      sectionName: m.section,
      topic: m.topic,
      type: m.type,
      fileUrl: m.fileUrl,
      isPublished: true,
    });
  }
  console.log(`✅ ${materialsData.length} materials created`);

  // ══════════════════════════════════════════════════════════════════════════
  // 12. ANNOUNCEMENTS
  // ══════════════════════════════════════════════════════════════════════════
  const announcementsData = [
    {
      title: "Anatomy Practical Exam — Schedule Change",
      content: "The Anatomy practical exam originally scheduled for April 10 has been rescheduled to April 17, 2025 at 09:00 AM in the Dissection Lab, Building C. All Year 2 students are required to attend.",
      category: "exam",
      doctorName: doctors[0].user.fullName,
      sourceName: "Department of Anatomy",
      sourceType: "doctor",
      targetAudience: "students",
      eventDate: "2025-04-17",
      eventTime: "9:00 AM",
      location: "Dissection Lab — Building C, An-Najah Campus",
      priority: "high",
      isPinned: true,
    },
    {
      title: "Guest Lecture: Cardiac Imaging Advances",
      content: "Prof. Hani Bitar from Hadassah Medical Center will deliver a guest lecture on Recent Advances in Cardiac CT and MRI. All medicine students and residents are welcome.",
      category: "lecture",
      doctorName: doctors[3].user.fullName,
      sourceName: "Department of Cardiology",
      sourceType: "conference",
      targetAudience: "all",
      eventDate: "2025-04-22",
      eventTime: "2:00 PM",
      location: "Main Auditorium — An-Najah University",
      priority: "normal",
      isPinned: false,
    },
    {
      title: "Pharmacology Quiz — Week 10",
      content: "A graded quiz on Drug Interactions and Pharmacokinetics will be held during the regular lecture slot on Thursday, April 24. Topics include CYP450 interactions, renal dosing adjustments, and antibiotic selection.",
      category: "quiz",
      doctorName: doctors[1].user.fullName,
      sourceName: "Department of Pharmacy",
      sourceType: "doctor",
      targetAudience: "students",
      eventDate: "2025-04-24",
      eventTime: "10:00 AM",
      location: "Lecture Hall 3 — Faculty of Medicine",
      priority: "high",
      isPinned: true,
    },
    {
      title: "Spring 2025 Course Registration — Open Now",
      content: "Course registration for Spring 2025 semester is now open on the student portal. Students must register before April 30. Please consult your academic advisor if you have prerequisites issues.",
      category: "general",
      doctorName: "Dr. Raed Awad",
      sourceName: "Academic Affairs Office",
      sourceType: "admin",
      targetAudience: "students",
      eventDate: "2025-04-30",
      eventTime: "11:59 PM",
      location: "Online — Student Portal",
      priority: "high",
      isPinned: true,
    },
    {
      title: "New Clinical Simulation Lab — Grand Opening",
      content: "An-Najah Faculty of Medicine is proud to announce the opening of the new Clinical Simulation Center featuring high-fidelity mannequins, ultrasound simulators, and laparoscopic training stations. Open day for all students on May 5, 2025.",
      category: "general",
      doctorName: "Dr. Raed Awad",
      sourceName: "Faculty of Medicine Administration",
      sourceType: "faculty",
      targetAudience: "all",
      eventDate: "2025-05-05",
      eventTime: "10:00 AM",
      location: "New Simulation Center — Building D",
      priority: "normal",
      isPinned: false,
    },
    {
      title: "Internal Medicine Rounds — Student Participation",
      content: "Year 3 and Year 4 students are invited to join weekly clinical rounds at An-Najah University Hospital every Monday at 8:00 AM. Please wear your white coat and ID badge. Contact Dr. Walid Sawalha to register.",
      category: "lecture",
      doctorName: doctors[2].user.fullName,
      sourceName: "Department of Internal Medicine",
      sourceType: "doctor",
      targetAudience: "students",
      eventDate: "2025-04-21",
      eventTime: "8:00 AM",
      location: "An-Najah University Hospital — Ward 4",
      priority: "normal",
      isPinned: false,
    },
  ];

  await Announcement.insertMany(announcementsData);
  console.log(`✅ ${announcementsData.length} announcements created`);

  // ══════════════════════════════════════════════════════════════════════════
  // 13. DOCTOR EVALUATION CASES
  // ══════════════════════════════════════════════════════════════════════════
  const evalCasesData = [
    {
      stuIdx: 0,
      docIdx: 2,
      caseTitle: "62-year-old male with acute chest pain",
      specialty: "Cardiology",
      symptoms: "Sudden onset central chest pain, diaphoresis, dyspnea, nausea. Pain radiates to left jaw. BP 90/60, HR 110, SpO₂ 94%.",
      history: "Known hypertensive and diabetic for 10 years. Smoker (30 pack-years). Family history of ischemic heart disease.",
      provisionalDiagnosis: "Acute ST-Elevation Myocardial Infarction (Inferior STEMI)",
      studentPlan: "Immediate ECG, aspirin 300mg, sublingual nitrate if BP allows, IV access, troponin, urgent cardiology referral for primary PCI.",
      doctorFeedback: "Excellent clinical reasoning. Correctly identified inferior STEMI pattern. Management plan is appropriate. Ensure morphine is included for pain relief and anticoagulation with heparin before PCI.",
      doctorScore: 88,
      status: "reviewed",
    },
    {
      stuIdx: 1,
      docIdx: 2,
      caseTitle: "28-year-old woman with progressive shortness of breath",
      specialty: "Pulmonology",
      symptoms: "3-week history of progressive exertional dyspnea, dry cough, and low-grade fever. Night sweats. Weight loss of 5 kg over 2 months.",
      history: "No known medical conditions. No smoking. Recent contact with a patient diagnosed with pulmonary tuberculosis.",
      provisionalDiagnosis: "Pulmonary Tuberculosis",
      studentPlan: "CXR, Mantoux test, sputum AFB smear × 3, IGRA, isolation precautions, refer to chest clinic for RHEZ therapy.",
      doctorFeedback: "Good diagnostic approach. TB was correctly considered. You should have also included CT chest as CXR may miss early lesions. Isolation precautions must be initiated immediately, not after confirmatory tests.",
      doctorScore: 80,
      status: "reviewed",
    },
    {
      stuIdx: 2,
      docIdx: 2,
      caseTitle: "45-year-old male with polyuria and polydipsia",
      specialty: "Endocrinology",
      symptoms: "Increased urination and thirst for 3 months. Blurred vision. Fatigue. RBS in clinic = 18 mmol/L.",
      history: "Father has type 2 diabetes. BMI 31. Sedentary lifestyle.",
      provisionalDiagnosis: "New-onset Type 2 Diabetes Mellitus",
      studentPlan: "FBS, HbA1c, lipid profile, renal function, urine microalbumin, eye referral. Start lifestyle modification and consider metformin.",
      doctorFeedback: "Comprehensive and correct. You covered the essential initial workup well. Consider adding TSH to the panel to rule out thyroid disease as a contributing cause. Good inclusion of ophthalmic referral.",
      doctorScore: 90,
      status: "reviewed",
    },
    {
      stuIdx: 3,
      docIdx: 0,
      caseTitle: "35-year-old male presenting with acute abdomen",
      specialty: "Surgery",
      symptoms: "Severe right iliac fossa pain for 18 hours, started periumbilically and migrated. Nausea, vomiting × 3. Temp 38.5°C. Rebound tenderness positive at McBurney's point.",
      history: "No previous surgeries. No significant PMH.",
      provisionalDiagnosis: "Acute Appendicitis",
      studentPlan: "CBC, CRP, USS abdomen, NPO, IV fluids, analgesia, surgical consult for appendicectomy.",
      status: "pending",
    },
    {
      stuIdx: 4,
      docIdx: 4,
      caseTitle: "26-year-old female, 32 weeks pregnant with severe headache",
      specialty: "Obstetrics & Gynecology",
      symptoms: "Severe frontal headache, visual disturbances, and epigastric pain. BP 160/110. Oedema of face and hands. Proteinuria 3+ on dipstick.",
      history: "G2P1, previous uncomplicated pregnancy. No chronic medical conditions.",
      provisionalDiagnosis: "Severe Preeclampsia with features of HELLP syndrome",
      studentPlan: "Urgent admission, IV magnesium sulphate for seizure prophylaxis, antihypertensives (labetalol or hydralazine), CTG monitoring, FBC, LFT, coagulation screen, discuss delivery planning with senior.",
      status: "pending",
    },
  ];

  for (const c of evalCasesData) {
    const stu = students[c.stuIdx];
    const doc = doctors[c.docIdx];
    await DoctorEvaluationCase.create({
      studentId: stu._id.toString(),
      studentName: stu.fullName,
      assignedDoctorId: doc.user._id.toString(),
      assignedDoctorProfileId: doc.profile._id.toString(),
      assignedDoctorName: doc.user.fullName,
      caseTitle: c.caseTitle,
      specialty: c.specialty,
      symptoms: c.symptoms,
      history: c.history,
      provisionalDiagnosis: c.provisionalDiagnosis,
      studentPlan: c.studentPlan,
      doctorFeedback: c.doctorFeedback || "",
      doctorScore: c.doctorScore || null,
      status: c.status,
      reviewedAt: c.status === "reviewed" ? new Date() : null,
    });
  }
  console.log(`✅ ${evalCasesData.length} evaluation cases created`);

  // ══════════════════════════════════════════════════════════════════════════
  // 14. CLINICAL SIMULATION RESULTS
  // ══════════════════════════════════════════════════════════════════════════
  const clinicalData = [
    { stuIdx: 0, caseTitle: "Inferior STEMI Management",       diagnosis: "Inferior STEMI",        firstAction: "ECG + Aspirin 300mg",  investigations: ["ECG", "Troponin", "CXR"],           score: 85, label: "Excellent" },
    { stuIdx: 1, caseTitle: "Pulmonary Embolism Case",         diagnosis: "Pulmonary Embolism",    firstAction: "Anticoagulation + CT-PA", investigations: ["D-Dimer", "CT-PA", "ABG"],        score: 70, label: "Good" },
    { stuIdx: 2, caseTitle: "Diabetic Ketoacidosis",           diagnosis: "Diabetic Ketoacidosis", firstAction: "IV Fluids + Insulin",  investigations: ["ABG", "Glucose", "Ketones", "ECG"], score: 90, label: "Excellent" },
    { stuIdx: 3, caseTitle: "Community-Acquired Pneumonia",    diagnosis: "CAP",                   firstAction: "Amoxicillin PO",       investigations: ["CXR", "CBC", "CRP", "Culture"],      score: 75, label: "Good" },
    { stuIdx: 4, caseTitle: "Acute Appendicitis",              diagnosis: "Acute Appendicitis",    firstAction: "NPO + Surgical consult", investigations: ["CBC", "CRP", "USS Abdomen"],        score: 80, label: "Good" },
    { stuIdx: 0, caseTitle: "Upper GI Bleed",                  diagnosis: "Peptic Ulcer Bleeding", firstAction: "IV PPI + Endoscopy referral", investigations: ["FBC", "Coagulation", "Endoscopy"], score: 78, label: "Good" },
  ];

  for (const c of clinicalData) {
    const stu = students[c.stuIdx];
    await ClinicalResult.create({
      studentName: stu.fullName,
      caseTitle: c.caseTitle,
      diagnosisSelected: c.diagnosis,
      firstActionSelected: c.firstAction,
      selectedInvestigations: c.investigations,
      score: c.score,
      performanceLabel: c.label,
    });
  }
  console.log(`✅ ${clinicalData.length} clinical simulation results created`);

  // ══════════════════════════════════════════════════════════════════════════
  // 15. MESSAGES
  // ══════════════════════════════════════════════════════════════════════════
  const messagesData = [
    { fromIdx: 0, toDocIdx: 2, text: "Good morning Dr. Sawalha, I had a question about the DKA case we discussed in rounds. Should metformin be held during hospital admission?" },
    { fromIdx: 0, toDocIdx: 2, text: "Also, thank you for the feedback on my evaluation case — very helpful!" },
    { fromIdx: 2, toDocIdx: 2, text: "Dr. Sawalha, regarding the pneumonia lecture notes — are they available on the student portal?" },
    { fromIdx: 1, toDocIdx: 1, text: "Dr. Zyoud, I'm confused about the warfarin-rifampicin interaction. Does the dose of warfarin need to be increased or decreased?" },
    { fromIdx: 3, toDocIdx: 0, text: "Good morning Dr. Tabash. I submitted my appendicitis case for evaluation. Looking forward to your feedback." },
  ];

  for (const m of messagesData) {
    const sender   = students[m.fromIdx];
    const receiver = doctors[m.toDocIdx].user;
    await Message.create({
      senderId: sender._id.toString(),
      receiverId: receiver._id.toString(),
      message: m.text,
      isRead: false,
    });
  }
  console.log(`✅ ${messagesData.length} messages created`);

  // ══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════════════════
  console.log("\n══════════════════════════════════════════════════════════");
  console.log("   An-Najah National University — MediLearn Seed Complete");
  console.log("══════════════════════════════════════════════════════════\n");
  console.log("  ROLE       LOGIN                         PASSWORD");
  console.log("  ──────     ──────────────────────────    ────────");
  console.log("  Admin      admin@najah.edu               123456");
  console.log("  Doctor     a.tabash@najah.edu            123456  (Surgery)");
  console.log("  Doctor     s.zyoud@najah.edu             123456  (Pharmacology)");
  console.log("  Doctor     w.sawalha@najah.edu           123456  (Internal Medicine)");
  console.log("  Doctor     r.abdelfattah@najah.edu       123456  (Cardiology)");
  console.log("  Doctor     l.mezyed@najah.edu            123456  (OB/GYN)");
  console.log("  Student    ID: 2021001  (Mohammed Al-Masri)    123456  Year 3");
  console.log("  Student    ID: 2021002  (Lina Khalil)          123456  Year 3");
  console.log("  Student    ID: 2021003  (Omar Barakat)         123456  Year 3");
  console.log("  Student    ID: 2021004  (Sara Nabulsi)         123456  Year 3");
  console.log("  Student    ID: 2021005  (Ahmad Haddad)         123456  Year 3");
  console.log("  Student    ID: 2022001  (Rima Jaradat)         123456  Year 2");
  console.log("  Student    ID: 2022002  (Khaled Mansour)       123456  Year 2");
  console.log("  Student    ID: 2022003  (Haya Samhan)          123456  Year 2");
  console.log("  Student    ID: 2023001  (Yousef Qasim)         123456  Year 1");
  console.log("  Student    ID: 2023002  (Nour Arafat)          123456  Year 1");
  console.log("\n  Data includes:");
  console.log("  • 8 real medical subjects  • 5 course quizzes");
  console.log("  • 8 course offerings       • 11 quiz results");
  console.log("  • 24 quiz questions        • 8 course materials");
  console.log("  • 6 announcements          • 5 evaluation cases");
  console.log("  • 6 clinical sim results   • 5 messages");
  console.log("══════════════════════════════════════════════════════════\n");

  await mongoose.disconnect();
}

seed().catch((e) => { console.error("❌ Seed failed:", e); process.exit(1); });
