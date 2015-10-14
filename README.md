# PunchInIOSApp
Attendance and course material app   
**App Description:**   
An attendance app that uses location and geofencing to verify a student is attending a given class.  The instructor can create courses with individual classes (e.g. MWF 1-2pm), verify attendance in real time, and analyze attendance over the course duration.  Optionally, we can use the app to provide course communications between instructors and students.
  
**User Story Points:**   
As a student, I can use the app to indicate my attendance for a class  
As a student, the app will use my current location to verify my attendance  
As a student, the app will periodically confirm my attendance throughout the duration of the class.  This lets the instructor know how long I remained in the class.  
As an instructor, I can use the app to create a course. I can define the logistics (location, time, etc) and provide descriptions for the course  
As an instructor, I can provide a list of expected attendees for a course.  The app will only measure attendance for these defined students.  
As an instructor, I can “start” a specific class. This step creates a geofence using the expected location, and allows students to begin verifying attendance.  
As an instructor, I can be notified whenever a student indicates attendance for the class.  
As an instructor, I can obtain a live list of students that are attending the current class.  
As an instructor, at any time I can request that students re-verify their attendance during the class session.  
As an instructor, I can view the attendance statistics for previous courses and classes.  
As a student, I can view the course logistics provided by the instructor  
   
**Optional Story Points:**     
As a student, I can use my Apple Watch to indicate my attendance   
As an instructor, I can generate a one-time token that students must use when indicating attendance.  This token, in combination with location, provides additional verification of student attendance.    
Note: the token would be communicated via bluetooth, to ensure delivery only to those students within bluetooth range (aka proximity)   
As an instructor, I can use the app to provide links to course material   
As an instructor, I can use the app to send questions/surveys to students currently in attendance, and I can also the use app to collect responses.   
As a student, I can use the app to share notes with other students   
As a student, I can use the app to submit questions for the instructor    
As a student, I can view all of my available courses     



**Demo Images**  
***Instructor View1***  
This is the first view which will appear once the instructor logs in inside the application.   
- Instructor can navigate to different classes through the pageviewcontroller   
- Instructor can also start the class
- Instructor has instant view of the attendance percentage of the current class. 
- Instructor can add class material, questions, and shared notes
- The notes, videos, assingment , labs, surveys can be uploaded per class basis.

![alt tag](https://github.com/Punch-In/PunchInIOSApp/blob/master/Wireframes/Screen%20Shot%202015-10-13%20at%207.27.11%20PM.png)

After clicking the attendance, user (instructor) can also see the : 
- Stats of attendance, per class basis. 
- Can individually see the attendance per class basis.
- Once tapped on the table cell  - a detail view will give more details about that particular student or we can just add the percentage of attendance of that student.  

![alt tag](https://github.com/Punch-In/PunchInIOSApp/blob/master/Wireframes/Screen%20Shot%202015-10-13%20at%207.27.20%20PM.png)

Instructor can also create new course and get the students on board : 

![alt tag](https://github.com/Punch-In/PunchInIOSApp/blob/master/Wireframes/Screen%20Shot%202015-10-13%20at%208.10.20%20PM.png)




This is the first view which will appear once the student logs in inside the application.   
- Student can navigate to different classes through the pageviewcontroller   
- Student can mark his attendance
- Student has instant view of the attendance percentage of the current class. 
- Student can get class material, questions, and shared notes
- The notes, videos, assingment , labs, surveys can be uploaded/viewed per class basis.

![alt tag](https://github.com/Punch-In/PunchInIOSApp/blob/master/Wireframes/Screen%20Shot%202015-10-13%20at%207.30.50%20PM.png)






