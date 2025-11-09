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
    git clone [https://github.com/pranyth/Course-Registration-DBMS.git](https://github.com/YourUsername/Course-Registration-DBMS.git)
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
  <img width="1913" height="1009" alt="image" src="https://github.com/user-attachments/assets/c124d1a5-f636-4135-8f61-344e600464e8" />
* Admin Dashboard
<img width="1850" height="979" alt="image" src="https://github.com/user-attachments/assets/2fac541f-9067-4f53-aff6-35caa165550e" />

---

## 📊 Database Schema

<img width="1023" height="505" alt="image" src="https://github.com/user-attachments/assets/32eaa457-aa71-4018-ba1d-a282f2615308" />
<img width="717" height="915" alt="image" src="https://github.com/user-attachments/assets/53885d27-a62d-4dc1-9943-0f6042821b0a" />

