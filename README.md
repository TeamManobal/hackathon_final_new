# TeamManobal – AI-Powered Mobile Platform for Democratizing Sports Talent Assessment

## 📌 Problem Statement (SIH 25073)
**Title:** AI-Powered Mobile Platform for Democratizing Sports Talent Assessment

**Background:**  
Identifying and assessing athletic talent in India is challenging, especially for athletes from rural and remote areas. Standardized assessment tests (height, weight, vertical jump, shuttle run, sit-ups, endurance runs) provide scientific evaluation, but infrastructure constraints limit access.

**Problem Description:**  
The Sports Authority of India (SAI) requires a mobile-based platform to democratize sports talent assessment. The app should:  
- Allow athletes to record videos of prescribed fitness tests.  
- Use AI/ML-based on-device verification to analyze videos for accuracy (e.g., jump height, sit-ups count, run timing).  
- Securely submit verified data to SAI servers.  
- Be low-cost and lightweight for accessibility on entry-level smartphones and low-bandwidth networks.

**Innovative Features:**  
- AI-based Cheat Detection to identify tampered or incorrect movements.  
- Offline Video Analysis for preliminary performance assessment without internet.  
- Performance Benchmarking against age/gender norms with instant feedback.  
- Gamified UI with progress badges, leaderboards, and interactive visuals.  
- Auto-Test Segmentation for automatic detection of test clips (e.g., counting sit-ups).

**Expected Deliverables:**  
- Mobile app (Android/iOS) for video recording and assessment.  
- AI/ML modules for on-device video analysis and cheat detection.  
- Secure backend to transmit verified data to SAI.  
- Dashboard for officials to view and evaluate performance data.

**Expected Impact:**  
- Democratization of sports talent assessment in remote areas.  
- Low-cost, scalable solution enabling mass participation.  
- Improved efficiency and transparency in discovering athletes.

**Dataset Link:** [SIH Annexure A](https://sih.gov.in/dataset/Youth_Affairs_Annexure_A_SIH25073.pdf)

---

## 🚀 Solution Overview
Our Flutter app enables athletes to record their fitness assessments, automatically analyze performance using AI/ML on-device, and securely submit verified results to SAI.  

**Key highlights:**  
- Cross-platform support (Android, iOS, Web)  
- AI-based cheat detection for fair assessments  
- Gamified UI for engagement  
- Offline processing to ensure accessibility

---

## 🛠️ Key Features
- Record and analyze athlete performance across standard fitness tests.  
- User authentication and profile management.  
- Visual dashboards and charts for performance tracking.  
- Reports and insights for coaches and officials.  
- Multi-platform support: Android, iOS, Web, Desktop.

---

## 💻 Tech Stack
- **Flutter** – Frontend UI  
- **Firebase** – Authentication, Database, Storage  
- **Dart & Flutter packages** – as listed in `pubspec.yaml`  
- **AI/ML Modules:**  
  - MediaPipe – Skeleton detection and pose analysis  
  - Google ML Kit – On-device ML tasks  
  - TensorFlow Lite – On-device inference for AI models

---

## ▶️ How to Run
1. Clone the repository:  
```bash
git clone https://github.com/TeamManobal/hackathon_final_new.git
```
2.Navigate to the project directory:
```bash
cd hackathon_final_new
```
3.Install dependencies:
```bash
flutter pub get
```
4.Run the app:
```bash
flutter run
```


