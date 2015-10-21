## Features
### Required
1. two user profiles: student, instructor
2. the vocabulary for the app:
   - a "course" is a series of sessions on a particular subject. for example, "iOS bootcamp" would be a course.
   - a "class" is an individual session for a course, delivered on a given day at a given time in a given location.  for example, "the oct 19th iOS bootcamp will be from 7-9PM in the Catalina room at Zynga HQ"
   - a class is "in session" if the instructor has started the class and the class has not yet ended. for example, at 8pm, the above class is "in session"
   - a student is "present" if her current location is within the geofence for the class location, and she has verified her attendance via an action in the app
   - a student is "absent" if she is not present.

#### Student Features
1. login using pre-generated identity (no oauth, etc)
2. view courses for which the student has registered. the registration process is outside the scope of the required features.
3. select a course to view details: name, location, and time
4. course detail view also provides detail view for an individual class. 
5. the student can swipe left or right to go backward or forward, respectively, through the classes for a course.
6. the class detail provides two pieces of information: (1) attendance verification and (2) questions
7. attendance verification
   - attendance verification is possible only if the instructor has allowed it for a given class.
   - if the student's location is within the geofence for the given class, and the instructor is allowing attendance collection, the student can indicate her presence by dragging her avatar into the classroom. once confirmed, the image will change to indicate the student is present.
   - if the student's location is not within the geofence for the given class, or the instructor has not allowed attendance collection, avatar dragging will be disabled (greyed out).
   - if the student is looking at the details for a class that has already completed (a past class), the UI will show presence or absence, depending on the students attendance at the time of the class.
8. questions
   - in the class details, the student can tap a UI element to show the questions view.
   - this view will allow the student to see questions submitted to the instructor by other students, including whether or not the question has already been answered.
   - this view will allow the student to submit her own questions to the instructor
   - questions can only be submitted while a class is "in session"
   
#### Instructor Features
1. login using pre-generated identity (no oauth, etc)
2. view courses for which the instructor is teaching. the creation of these courses is outside the scope of the required features.
3. select a course to view details: name, location, and time
4. course detail view also provides detail view for an individual class.
5. the instructor can swipe left or right to go backward or forward, respectively, through the classes for a course.
6. the class details view will depend on the state of the class: not yet started or finished.
7. not yet started classes
   - the instructor will be able to "start" a class through some UI element. This will create the geofence based on the course's location, which then allows students to verify attendance.
   - the instructor will be able to view the current attendance for the class.
   - the attendance view will provide a switcher so that the instructor can quickly switch between students that are present and those that are absent.
   - the instructor can be asynchronously notified whenever a new student marks attendance.
   - the instructor can view submitted questions for the active class.
   - the instructor can mark questions as "answered". the question will remain visible, but will be displayed differently than "unanswered" questions.
   - the instructor can "end" the class, closing the class and preventing students from marking attendance if they have not done so already.
8. finished class
   - the instructor can view attendance for a class that is finished.
   - the instructor can view questions for class that is finished.

### Optional Features
1. when the instructor "starts" a class, the student will be notified that she can now confirm attendance. this notification will only be delivered if the student's location is within the geofence.
2. students can upvote or downvote questions that have been submitted to the instructor.
3. the instructor's view of current attendance will be avatar based, rather than a table view.  
4. by tapping a UI element, the instructor can request that students reconfirm their attendance. this will result in a notification sent to the students currently present.
5. the instructor can create a local peer-to-peer network using iBeacon and the multi peer connectivity framework. the network will consist of the instructor, and students within a given range. this can complement using the student's location or replace the need to use the student's current location.
6. the instructor can use optional feature #5 to send one-time tokens to each of the students in the local network, thus providing two forms of attendance verification: location and the one-time token. 

### Bonus Features
1. student can use Apple Watch to mark attendance
2. instructor can send survey questions for the students to answer. this bonus feature would be an external link to a survey system, not an actual survey embedded within the app.
3. as an instructor, the workflow for creating a course
4. as a student, the workflow for registering for a course.
