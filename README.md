# SafeDrive

**Subject:** INFO 4335 Mobile App Development  
**Group Name:** Melly  

---

## Project Initiation
Design an android mobile app that can help drivers improve their driving behaviour using flutter and deploy on Google PlayStore. 

## Project Objective
The objective of this application is to improve user's behaviour in driving. SafeDrive app will track and analyse the user's driving by tracking the amount of hardbrakes the drive did because driver does not maintain a good distance with the car in front, and the number of sharp turns done by the driver due to last minute decision and also for speeding. Users can log trips by starting drive and the trip will be analysed for feedbacks. Through this feedback message, user can drive more carefully the next time.

## Target User

Target users for SafeDrive is someone who wants to monitor their driving behaviour so that they can improve their driving. This way, users (drivers) can avoid getting fined for speeding or damage their car due to hardbrakes or sharp turns that may harm the car internally or externally. 

## Deployment Platform
SafeDrive will be deployed on Google Playstore. Phone compatibility; all Android(8+) devices that have gps sensor because this app will be utilising the device's sensors.

---

## Group Members and Assigned Tasks

| **Name**                             | **Matric No** | **Assigned Tasks**                                                                                                                                               |
|--------------------------------------|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Nur Adlin Binti Muhammad Zahid**   | 2118652       | - Authentication and profile management.                                                                                                                         |
|                                      |               | - Sensor integration for accelerometer/gyroscope.                                                                                        |
|                                      |               | - Backend logic for CRUD operations.                                                                                                                             |
| **Hannah Sabrina Binti Saiful Bahri**| 2116074       | - UI/UX design for all app screens.                                                                                                                              |
|                                      |               | - Development of trip logging and review interfaces.                                                                                                             |
|                                      |               | - Visualization of driving data (e.g., graphs and charts).                                                                                                       |
| **Nor Hidayati Binti Munadi**        | 2214282       | - Integration of GPS for route mapping and safe-driving analysis                                                                                                              |
|                                      |               | - Detection algorithms for unsafe driving behaviors.                                                                                                             |
|                                      |               | - Implementation of notifications and alerts for risky habits.                                                                                                   |

---

## Features
- **Authentication:**  
  Manage profiles for drivers, including driving feedback and safety insights.
  
- **CRUD Operations:**  
  - Log new trips with details such as date, time, and distance.  
  - Review past trips to analyze performance.  
  - Update profile data or delete outdated trip data.

- **Sensor Integration:**  
  - **Accelerometer/Gyroscope:** Detect unsafe driving behaviors such as hard braking, sudden accelerations, and sharp turns.  
  - **GPS:** Map routes and track driving behaviours.

---

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/adlinzahid/SafeDrive.git

---

## Requirement Analysis

### **Objective**
Identify and document the technical and functional requirements for the SafeDrive app.

### **Scope**
- Provide a comprehensive understanding of system requirements.
- Assess technical feasibility and platform compatibility.

### **System Requirements For Development**
- Flutter >=3.19.0
- Dart >=3.3.0 <4.0.0
- iOS >=12.0
- MacOS >=10.14
- Android compileSDK 34
- Java 17
- Android Gradle Plugin >=8.3.0
- Gradle wrapper >=8.4

### **Functional Requirements**
#### **1. User Authentication**
- Enable drivers to sign up/sign in using email/password or Google.
- Securely manage driver profiles and link user IDs to driving data in the database.

#### **2. Real-time Sensor Data Processing**
- Process sensor streams from accelerometer, gyroscope, and magnetometer for driving behavior analysis.
- Detect driving events like hard braking, sudden acceleration, and sharp turns.

#### **3. Route Tracking**
- Use GPS plugins (e.g., geolocator) to monitor routes and integrate safe driving insights.
- Aggregate data into metrics for feedback.

#### **4. Trip and Event Logging**
- Store trip data and driving behaviors in Firestore for long-term access.
- Log low-latency driving events (e.g., hard brakes) in the Realtime Database.

#### **5. Feedback Generation**
- Automate driving feedback using Firebase Cloud Functions.
- Provide insights such as "x hard brakes, y sharp turns" based on trip data.

### **Non-functional Requirements**
#### **1. System Uptime**
- Ensure an uptime of 99.9% to support real-time feedback.

#### **2. Latency**
- Maintain data handling latency below 500ms for sensor events.

#### **3. Platform Compatibility**
- Ensure compatibility with Android 8.0+ (API Level 26+).
- Test on physical devices with accelerometer, gyroscope, and GPS sensors.

#### **4. Data Privacy**
- Adhere to GDPR/CCPA compliance for data collection, storage, and usage.

### **Technical Feasibility**
#### **Frontend**
- Built using Flutter to support cross-platform functionality.

#### **Backend**
| Firebase Service       | Description                             |
|------------------------|-----------------------------------------|
| Authentication         | Secure user management.                |
| Firestore              | Trip data storage.                    |
| Realtime Database      | Low-latency data for real-time updates.|
| Cloud Functions        | Automated feedback processing.        |
| Firebase Storage       | Storage for driving-related media.     |


#### **Sensor Integration**
- Utilize `sensors_plus` for accelerometer, gyroscope, and magnetometer data.
- Combine with GPS plugins (e.g., geolocator) for route tracking.

#### **Driving Insights**
- Generate actionable feedback messages based on aggregated data.

---

## Sequence Diagram
![Sequence Diagram drawio (1)](https://github.com/user-attachments/assets/f9067d94-cf59-4c5f-a4df-2905f0932428)

---

## Navigation Flow
![mobileapp](https://github.com/user-attachments/assets/932c0837-77c1-4732-ab1e-3d246d1e5d63)

## Gantt Chart for SafeDrive Development


