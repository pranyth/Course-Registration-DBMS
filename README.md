# 📚 Course Registration System - DBMS Mini Project

A complete database application for a College Course Registration System. This project, part of the **UE23CS351A** curriculum, simulates a real-world portal for students and administrators.

This application is built with a Python Flask backend, a MySQL database, and an HTML/Bootstrap front end.

---

## Team Members
* **PRANITH K** (PES2UG23CS434)
* **PRANAV NEGI** (PES2UG23CS429)

---

## 🌟 Key Features

* **Varied User Privileges:**
    * **Student View:** Students can log in, view their registered courses, and register for or drop available courses.
    * **Admin View:** Admins have a separate dashboard to view reports and manage student data.
* **CRUD Operations:**
    * **Create:** Students can register for new courses.
    * **Read:** Students (and admins) can view course/registration data.
    * **Update:** Admins can update student grades.
    * **Delete:** Students can drop courses from their schedule.
* **Database Integrity:**
    * **Trigger:** A `trg_CheckCapacity` trigger blocks registration if a class is full, protecting data integrity.
    * **Stored Procedure:** `sp_GetStudentRegistrations` is used to efficiently fetch a student's dashboard data.
    * **Stored Function:** `fn_GetCourseEnrollmentCount` is a helper function used by the trigger.
* **Complex Queries:**
    * **JOINs:** Used to display faculty names and department info on the student dashboard.
    * **Aggregate Query:** The admin dashboard shows an aggregate `COUNT` of students per department.
    * **Nested Query:** The admin dashboard shows all courses from the 'Computer Science' department using a subquery.
* **Student View:**
     * View all classmates registered in the same course.
     * Displays student names and departments for each course.
* **Admin View:**
      * Search for students by grade and course.
      * Admin enters a grade and selects a course → displays all students who received that grade.

---

## 💻 Technology Stack

* **Backend:** Python (Flask)
* **Database:** MySQL
* **Frontend:** HTML, CSS (Bootstrap)
* **Connector:** `mysql-connector-python`

---

## 🚀 How to Run This Project

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/pranyth/Course-Registration-DBMS.git
    cd Course-Registration-DBMS
    ```
2.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
    

3.  **Set up the database:**
    * Open your MySQL client (like MySQL Workbench).
    * Run the entire `miniproject.sql` file to create the database, tables, and procedures.

4.  **Run the application:**
    * Edit `app.py` and update the `db_config` password with your MySQL password.
    * Run the app:
    ```bash
    python app.py
    ```
5.  **View the app:**
    Open your browser and go to `http://127.0.0.1:5000`

---

## 📸 Screenshots


* Login Page
  <img width="1915" height="644" alt="image" src="https://github.com/user-attachments/assets/21ff389d-35c8-460c-b31c-b2b0190b6ada" />
* Student Dashboard
  <img width="1818" height="940" alt="image" src="https://github.com/user-attachments/assets/e4c2891c-84c2-4ebb-9a6b-353f264ed375" />

  <img width="1839" height="428" alt="image" src="https://github.com/user-attachments/assets/907122f5-0cd2-425b-954b-ab330834f43b" />

* Admin Dashboard
<img width="1686" height="1030" alt="image" src="https://github.com/user-attachments/assets/acf1c4f8-71b4-42f2-b869-0fdf1b4db9fe" />

<img width="1909" height="737" alt="image" src="https://github.com/user-attachments/assets/cdc78a1e-9eae-418c-bd65-8dd143624dff" />


---

## 📊 Database Schema

<img width="1023" height="505" alt="image" src="https://github.com/user-attachments/assets/32eaa457-aa71-4018-ba1d-a282f2615308" />
<img width="717" height="915" alt="image" src="https://github.com/user-attachments/assets/53885d27-a62d-4dc1-9943-0f6042821b0a" />

