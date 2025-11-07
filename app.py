from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)
# This is required for flashing messages and sessions (like login)
app.secret_key = 'your_super_secret_key' 

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'rgsp1512',  # <--- CHANGE THIS
    'database': 'miniproject'
}

# --- Database Connection Helper ---
def get_db_connection():
    """Establishes a connection to the MySQL database."""
    try:
        conn = mysql.connector.connect(**db_config)
        return conn
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

# --- Routes for UI ---

# 1. Login Page (Handles "Varied Privileges")
@app.route('/', methods=['GET', 'POST'])
def login():
    """Handles the login page for both students and admins."""
    if request.method == 'POST':
        user_id = request.form['user_id']
        
        # Special 'admin' user
        if user_id.lower() == 'admin':
            session['user_id'] = 'admin'
            session['name'] = 'Admin User'
            return redirect(url_for('admin_dashboard'))

        # Check if it's a valid student
        conn = get_db_connection()
        if conn is None:
            flash('Database connection failed. Check app.py credentials.', 'danger')
            return render_template('login.html')
        
        cursor = conn.cursor(dictionary=True) # dictionary=True lets us use column names
        cursor.execute("SELECT * FROM Student WHERE Student_ID = %s", (user_id,))
        student = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if student:
            # Save user info in the session
            session['user_id'] = student['Student_ID']
            session['name'] = student['Name']
            return redirect(url_for('student_dashboard'))
        else:
            flash('Invalid Student ID. Try "STU001" or "admin".', 'warning')
            
    return render_template('login.html')

# 2. Student Dashboard
@app.route('/dashboard')
def student_dashboard():
    """Shows the main dashboard for a logged-in student."""
    # Protect the route
    if 'user_id' not in session or session['user_id'] == 'admin':
        flash('Please log in as a student to view this page.', 'warning')
        return redirect(url_for('login'))
    
    student_id = session['user_id']
    conn = get_db_connection()
    if conn is None:
        flash('Database connection failed.', 'danger')
        return render_template('dashboard.html', my_courses=[], available_courses=[])

    cursor = conn.cursor(dictionary=True)
    
    # DEMO 1: Call Stored Procedure (Review 3)
    cursor.callproc('sp_GetStudentRegistrations', [student_id])
    my_courses = []
    # Must iterate over stored_results
    for result in cursor.stored_results():
        my_courses = result.fetchall()
    
    # DEMO 2: JOIN Query (Review 4)
    # Get courses the student is *not* registered for
    query = """
        SELECT C.Course_ID, C.Course_Name, F.Name as Faculty_Name, D.Dept_Name
        FROM Course C
        JOIN Faculty F ON C.Faculty_ID = F.Faculty_ID
        JOIN Department D ON C.Department_ID = D.Department_ID
        WHERE C.Course_ID NOT IN (
            SELECT Course_ID FROM Registration WHERE Student_ID = %s
        )
    """
    cursor.execute(query, (student_id,))
    available_courses = cursor.fetchall()

    cursor.close()
    conn.close()
    
    return render_template('dashboard.html', my_courses=my_courses, available_courses=available_courses)

# 3. Register for Course (Demos CREATE and TRIGGER)
@app.route('/register/<string:course_id>')
def register(course_id):
    """Handles a student's request to register for a course."""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    student_id = session['user_id']
    
    try:
        conn = get_db_connection()
        if conn is None:
            flash('Database connection failed.', 'danger')
            return redirect(url_for('student_dashboard'))
        
        cursor = conn.cursor()
        # This INSERT will fire your 'trg_CheckCapacity' trigger (Review 3)
        cursor.execute("INSERT INTO Registration (Student_ID, Course_ID, Reg_Date) VALUES (%s, %s, CURDATE())", (student_id, course_id))
        conn.commit() # Commit the transaction
        flash(f"Successfully registered for {course_id}!", 'success')
        
    except Error as e:
        # If the trigger fails, the database sends an error.
        flash(f"Error registering: {e.msg}", 'danger')
        
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()
            
    return redirect(url_for('student_dashboard'))

# 4. Drop Course (Demos DELETE)
@app.route('/drop/<int:reg_id>')
def drop(reg_id):
    """Handles a student's request to drop a course."""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    conn = get_db_connection()
    if conn is None:
        flash('Database connection failed.', 'danger')
        return redirect(url_for('student_dashboard'))
        
    cursor = conn.cursor()
    # DELETE operation based on the registration ID and matching student ID for security
    cursor.execute("DELETE FROM Registration WHERE Reg_ID = %s AND Student_ID = %s", (reg_id, session['user_id']))
    conn.commit()
    cursor.close()
    conn.close()
    
    flash("Course dropped successfully.", 'success')
    return redirect(url_for('student_dashboard'))

# 5. Admin Dashboard (For queries and UPDATE)
@app.route('/admin')
def admin_dashboard():
    """Shows the main dashboard for the admin."""
    if 'user_id' not in session or session['user_id'] != 'admin':
        flash('You must be an admin to view this page.', 'warning')
        return redirect(url_for('login'))
    
    conn = get_db_connection()
    if conn is None:
        flash('Database connection failed.', 'danger')
        return render_template('admin.html', agg_results=[], nested_results=[], all_registrations=[])

    cursor = conn.cursor(dictionary=True)

    # DEMO 3: AGGREGATE Query (Review 4)
    query_agg = """
        SELECT D.Dept_Name, COUNT(S.Student_ID) AS Number_Of_Students
        FROM Student S
        JOIN Department D ON S.Department_ID = D.Department_ID
        GROUP BY D.Dept_Name
        ORDER BY Number_Of_Students DESC
    """
    cursor.execute(query_agg)
    agg_results = cursor.fetchall()
    
    # DEMO 4: NESTED Query (Review 4)
    query_nested = """
        SELECT Course_Name, Credits
        FROM Course
        WHERE Department_ID = (
            SELECT Department_ID 
            FROM Department 
            WHERE Dept_Name = 'Computer Science'
        )
    """
    cursor.execute(query_nested)
    nested_results = cursor.fetchall()
    
    # Get all registrations for UPDATE demo
    query_all_reg = """
        SELECT R.Reg_ID, S.Name, C.Course_Name, R.Grade 
        FROM Registration R 
        JOIN Student S ON R.Student_ID = S.Student_ID 
        JOIN Course C ON R.Course_ID = C.Course_ID
        ORDER BY S.Name, C.Course_Name
    """
    cursor.execute(query_all_reg)
    all_registrations = cursor.fetchall()
    
    cursor.close()
    conn.close()

    return render_template('admin.html', agg_results=agg_results, nested_results=nested_results, all_registrations=all_registrations)

# 6. Update Grade (Demos UPDATE)
@app.route('/update_grade', methods=['POST'])
def update_grade():
    """Handles the admin's request to update a grade."""
    if 'user_id' not in session or session['user_id'] != 'admin':
        return redirect(url_for('login'))
        
    reg_id = request.form['reg_id']
    grade = request.form['grade']
    
    conn = get_db_connection()
    if conn is None:
        flash('Database connection failed.', 'danger')
        return redirect(url_for('admin_dashboard'))
        
    cursor = conn.cursor()
    # UPDATE operation
    cursor.execute("UPDATE Registration SET Grade = %s WHERE Reg_ID = %s", (grade, reg_id))
    conn.commit()
    cursor.close()
    conn.close()
    
    flash("Grade updated successfully!", 'success')
    return redirect(url_for('admin_dashboard'))

# 7. Logout
@app.route('/logout')
def logout():
    """Logs the user out by clearing the session."""
    session.clear()
    flash('You have been logged out.', 'success')
    return redirect(url_for('login'))

# --- Run the App ---
if __name__ == '__main__':
    app.run(debug=True) # debug=True auto-reloads the server when you save the file