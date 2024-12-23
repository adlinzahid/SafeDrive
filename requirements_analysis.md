# **Requirements Analysis for SafeDrive Application**

## **Objective**
Identify and document the technical and functional requirements for the SafeDrive app.

## **Scope**
- Provide a comprehensive understanding of system requirements.
- Assess technical feasibility and platform compatibility.

## **Functional Requirements**
### **1. User Authentication**
- Enable drivers to sign up/sign in using email/password or Google.
- Securely manage driver profiles and link user IDs to driving data in the database.

### **2. Real-time Sensor Data Processing**
- Process sensor streams from accelerometer, gyroscope, and magnetometer for driving behavior analysis.
- Detect driving events like hard braking, sudden acceleration, and sharp turns.

### **3. Route Tracking**
- Use GPS plugins (e.g., geolocator) to monitor routes and integrate safe driving insights.
- Aggregate data into metrics for feedback.

### **4. Trip and Event Logging**
- Store trip data and driving behaviors in Firestore for long-term access.
- Log low-latency driving events (e.g., hard brakes) in the Realtime Database.

### **5. Feedback Generation**
- Automate driving feedback using Firebase Cloud Functions.
- Provide insights such as "x hard brakes, y sharp turns" based on trip data.

## **Non-functional Requirements**
### **1. System Uptime**
- Ensure an uptime of 99.9% to support real-time feedback.

### **2. Latency**
- Maintain data handling latency below 500ms for sensor events.

### **3. Platform Compatibility**
- Ensure compatibility with Android 8.0+ (API Level 26+).
- Test on physical devices with accelerometer, gyroscope, and GPS sensors.

### **4. Data Privacy**
- Adhere to GDPR/CCPA compliance for data collection, storage, and usage.

## **Technical Feasibility**
### **Frontend**
- Built using Flutter to support cross-platform functionality.

### **Backend**
| Firebase Service       | Description                             |
|------------------------|-----------------------------------------|
| Authentication         | Secure user management.                |
| Firestore              | Trip data storage.                    |
| Realtime Database      | Low-latency data for real-time updates.|
| Cloud Functions        | Automated feedback processing.        |
| Firebase Storage       | Storage for driving-related media.     |


### **Sensor Integration**
- Utilize `sensors_plus` for accelerometer, gyroscope, and magnetometer data.
- Combine with GPS plugins (e.g., geolocator) for route tracking.

### **Driving Insights**
- Generate actionable feedback messages based on aggregated data.


### **Screen Navigation Flow**
![mobileapp](https://github.com/user-attachments/assets/932c0837-77c1-4732-ab1e-3d246d1e5d63)



## **Next Steps**
1. Optimize Firestore rules for write-heavy usage.
2. Confirm Firebase Cloud Function quotas to handle simultaneous app usage.
3. Conduct real-world testing across diverse devices to ensure sensor accuracy and performance consistency.
4. Enhance user feedback mechanisms for better driving insights.
