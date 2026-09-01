-- =========================================================================
-- UniSphere Seed Data
-- Order of inserts strictly respects foreign key dependencies:
-- department, job_position -> section, course -> semester -> "user"
-- -> instructor, student -> course_offering -> announcement -> enrollment -> assessment,
-- resource -> submission -> grade -> transcript -> transcript_entry
-- -> fee_challan -> notification -> instructor_job_position
-- =========================================================================

begin;

-- -------------------------------------------------------------------------
-- 1. DEPARTMENTS
-- -------------------------------------------------------------------------
insert into department (department_name, department_code) values
('Computer Science', 'CS'),
('Artificial Intelligence', 'AI'),
('Software Engineering', 'SE');

-- -------------------------------------------------------------------------
-- 2. JOB POSITIONS
-- -------------------------------------------------------------------------
insert into job_position (position_name) values
('Lecturer'),
('Assistant Professor'),
('Associate Professor'),
('Professor'),
('Lab Engineer');

-- -------------------------------------------------------------------------
-- 3. SECTIONS (5 sections across departments/batches)
-- -------------------------------------------------------------------------
insert into section (section_name, batch, department_id)
select v.section_name, v.batch, d.department_id
from (values
    ('A', 23, 'CS'),
    ('B', 23, 'CS'),
    ('A', 23, 'AI'),
    ('A', 23, 'SE'),
    ('A', 22, 'CS')
) as v(section_name, batch, dept_code)
join department d on d.department_code = v.dept_code;

-- -------------------------------------------------------------------------
-- 4. SEMESTERS
-- -------------------------------------------------------------------------
insert into semester (semester_name, start_date, end_date) values
('Fall 2025', '2025-09-01', '2025-12-31'),
('Spring 2026', '2026-01-15', '2026-05-15');

-- -------------------------------------------------------------------------
-- 5. COURSES
-- -------------------------------------------------------------------------
insert into course (course_code, course_name, credit_hours, department_id)
select v.course_code, v.course_name, v.credit_hours, d.department_id
from (values
    ('CS1101', 'Programming Fundamentals', 3, 'CS'),
    ('CS2203', 'Data Structures', 3, 'CS'),
    ('CS3203', 'Database Systems', 3, 'CS'),
    ('CS4203', 'Compiler Construction', 3, 'CS'),
    ('AI2001', 'Introduction to Artificial Intelligence', 3, 'AI'),
    ('AI3001', 'Machine Learning', 3, 'AI'),
    ('AI3002', 'Neural Networks', 3, 'AI'),
    ('SE2001', 'Software Engineering', 3, 'SE'),
    ('SE3001', 'Software Design', 3, 'SE'),
    ('SE3002', 'Software Testing', 3, 'SE')
) as v(course_code, course_name, credit_hours, dept_code)
join department d on d.department_code = v.dept_code;

-- -------------------------------------------------------------------------
-- 6. USERS (1 Admin + 5 Instructors + 20 Students = 26)
-- Real bcrypt hash (10 rounds) for every account: password is "Passw0rd!"
-- Verified with Python's bcrypt.checkpw() so it will authenticate correctly
-- against any bcrypt-based auth (Flask-Bcrypt, bcryptjs, django-bcrypt, etc).
-- All accounts share one domain (unisphere.edu.pk) to match the project's academic
-- institution; adjust if UniSphere ships with its own domain later.
-- -------------------------------------------------------------------------
insert into "user" (username, password_hash, email, role) values
('admin', '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', 'admin@unisphere.edu.pk', 'Admin'),

('ahmed.raza',     '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', 'ahmed.raza@unisphere.edu.pk',     'Instructor'),
('sara.khan',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', 'sara.khan@unisphere.edu.pk',      'Instructor'),
('bilal.hussain',  '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', 'bilal.hussain@unisphere.edu.pk',  'Instructor'),
('ayesha.malik',   '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', 'ayesha.malik@unisphere.edu.pk',   'Instructor'),
('usman.tariq',    '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', 'usman.tariq@unisphere.edu.pk',    'Instructor'),

('hassan.ali',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0601@unisphere.edu.pk', 'Student'),
('ayesha.siddiqui',  '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0602@unisphere.edu.pk', 'Student'),
('bilal.ahmed',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0603@unisphere.edu.pk', 'Student'),
('sana.fatima',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0604@unisphere.edu.pk', 'Student'),
('omar.farooq',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0605@unisphere.edu.pk', 'Student'),
('hira.shahid',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0606@unisphere.edu.pk', 'Student'),
('zain.abbas',       '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0607@unisphere.edu.pk', 'Student'),
('mahnoor.iqbal',    '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0608@unisphere.edu.pk', 'Student'),
('talha.saeed',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0609@unisphere.edu.pk', 'Student'),
('rabia.yousuf',     '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0610@unisphere.edu.pk', 'Student'),
('asad.mehmood',     '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0611@unisphere.edu.pk', 'Student'),
('komal.riaz',       '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0612@unisphere.edu.pk', 'Student'),
('faizan.akhtar',    '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0613@unisphere.edu.pk', 'Student'),
('nimra.khalid',     '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0614@unisphere.edu.pk', 'Student'),
('hamza.sheikh',     '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0615@unisphere.edu.pk', 'Student'),
('areeba.noor',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0616@unisphere.edu.pk', 'Student'),
('sheraz.ahmed',     '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0617@unisphere.edu.pk', 'Student'),
('laiba.tariq',      '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '23k0618@unisphere.edu.pk', 'Student'),
('junaid.aslam',     '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '22k0601@unisphere.edu.pk', 'Student'),
('mariam.zafar',     '$2b$10$iSWDfjtkiAsRttPsIPje9e2cDLpwEE1VoE1HuHfjY1wCmt192Jzga', '22k0602@unisphere.edu.pk', 'Student');

-- -------------------------------------------------------------------------
-- 7. INSTRUCTORS
-- -------------------------------------------------------------------------
insert into instructor (user_id, employee_id, first_name, last_name, cnic, phone, department_id)
select u.user_id, v.employee_id, v.first_name, v.last_name, v.cnic, v.phone, d.department_id
from (values
    ('ahmed.raza',    'EMP-001', 'Ahmed',  'Raza',    '42101-1000001-1', '0300-1000001', 'CS'),
    ('sara.khan',     'EMP-002', 'Sara',   'Khan',    '42101-1000002-2', '0300-1000002', 'CS'),
    ('bilal.hussain', 'EMP-003', 'Bilal',  'Hussain', '42101-1000003-3', '0300-1000003', 'AI'),
    ('ayesha.malik',  'EMP-004', 'Ayesha', 'Malik',   '42101-1000004-4', '0300-1000004', 'SE'),
    ('usman.tariq',   'EMP-005', 'Usman',  'Tariq',   '42101-1000005-5', '0300-1000005', 'AI')
) as v(username, employee_id, first_name, last_name, cnic, phone, dept_code)
join "user" u on u.username = v.username
join department d on d.department_code = v.dept_code;

-- -------------------------------------------------------------------------
-- 8. STUDENTS (20)
-- -------------------------------------------------------------------------
insert into student (user_id, roll_no, first_name, last_name, cnic, gender, dob, batch, degree, department_id, section_id, phone)
select u.user_id, v.roll_no, v.first_name, v.last_name, v.cnic, v.gender, v.dob::date, v.batch, v.degree, d.department_id, sec.section_id, v.phone
from (values
    -- username, roll_no, first_name, last_name, cnic, gender, dob, batch, degree, dept_code, section_name, phone
    ('hassan.ali',     '23K-0601', 'Hassan',  'Ali',       '42101-2000001-1', 'Male',   '2004-03-12', 23, 'BS(CS)', 'CS', 'A', '0301-2000001'),
    ('ayesha.siddiqui','23K-0602', 'Ayesha',  'Siddiqui',  '42101-2000002-2', 'Female', '2004-07-21', 23, 'BS(CS)', 'CS', 'A', '0301-2000002'),
    ('bilal.ahmed',    '23K-0603', 'Bilal',   'Ahmed',     '42101-2000003-3', 'Male',   '2004-01-09', 23, 'BS(CS)', 'CS', 'A', '0301-2000003'),
    ('sana.fatima',    '23K-0604', 'Sana',    'Fatima',    '42101-2000004-4', 'Female', '2004-11-30', 23, 'BS(CS)', 'CS', 'A', '0301-2000004'),
    ('omar.farooq',    '23K-0605', 'Omar',    'Farooq',    '42101-2000005-5', 'Male',   '2004-05-17', 23, 'BS(CS)', 'CS', 'A', '0301-2000005'),
    ('hira.shahid',    '23K-0606', 'Hira',    'Shahid',    '42101-2000006-6', 'Female', '2004-09-02', 23, 'BS(CS)', 'CS', 'A', '0301-2000006'),

    ('zain.abbas',     '23K-0607', 'Zain',    'Abbas',     '42101-2000007-7', 'Male',   '2004-02-14', 23, 'BS(CS)', 'CS', 'B', '0301-2000007'),
    ('mahnoor.iqbal',  '23K-0608', 'Mahnoor', 'Iqbal',     '42101-2000008-8', 'Female', '2004-06-25', 23, 'BS(CS)', 'CS', 'B', '0301-2000008'),
    ('talha.saeed',    '23K-0609', 'Talha',   'Saeed',     '42101-2000009-9', 'Male',   '2004-10-04', 23, 'BS(CS)', 'CS', 'B', '0301-2000009'),
    ('rabia.yousuf',   '23K-0610', 'Rabia',   'Yousuf',    '42101-2000010-0', 'Female', '2004-04-19', 23, 'BS(CS)', 'CS', 'B', '0301-2000010'),

    ('asad.mehmood',   '23K-0611', 'Asad',    'Mehmood',   '42101-2000011-1', 'Male',   '2004-08-08', 23, 'BS(AI)', 'AI', 'A', '0301-2000011'),
    ('komal.riaz',     '23K-0612', 'Komal',   'Riaz',      '42101-2000012-2', 'Female', '2004-12-23', 23, 'BS(AI)', 'AI', 'A', '0301-2000012'),
    ('faizan.akhtar',  '23K-0613', 'Faizan',  'Akhtar',    '42101-2000013-3', 'Male',   '2004-01-27', 23, 'BS(AI)', 'AI', 'A', '0301-2000013'),
    ('nimra.khalid',   '23K-0614', 'Nimra',   'Khalid',    '42101-2000014-4', 'Female', '2004-03-31', 23, 'BS(AI)', 'AI', 'A', '0301-2000014'),

    ('hamza.sheikh',   '23K-0615', 'Hamza',   'Sheikh',    '42101-2000015-5', 'Male',   '2004-07-06', 23, 'BS(SE)', 'SE', 'A', '0301-2000015'),
    ('areeba.noor',    '23K-0616', 'Areeba',  'Noor',      '42101-2000016-6', 'Female', '2004-09-15', 23, 'BS(SE)', 'SE', 'A', '0301-2000016'),
    ('sheraz.ahmed',   '23K-0617', 'Sheraz',  'Ahmed',     '42101-2000017-7', 'Male',   '2004-11-11', 23, 'BS(SE)', 'SE', 'A', '0301-2000017'),
    ('laiba.tariq',    '23K-0618', 'Laiba',   'Tariq',     '42101-2000018-8', 'Female', '2004-02-28', 23, 'BS(SE)', 'SE', 'A', '0301-2000018'),

    ('junaid.aslam',   '22K-0601', 'Junaid',  'Aslam',     '42101-2000019-9', 'Male',   '2003-05-05', 22, 'BS(CS)', 'CS', 'A', '0301-2000019'),
    ('mariam.zafar',   '22K-0602', 'Mariam',  'Zafar',     '42101-2000020-0', 'Female', '2003-10-18', 22, 'BS(CS)', 'CS', 'A', '0301-2000020')
) as v(username, roll_no, first_name, last_name, cnic, gender, dob, batch, degree, dept_code, section_name, phone)
join "user" u on u.username = v.username
join department d on d.department_code = v.dept_code
join section sec on sec.section_name = v.section_name and sec.batch = v.batch and sec.department_id = d.department_id;

-- -------------------------------------------------------------------------
-- 9. COURSE OFFERINGS (11 offerings across both semesters)
-- -------------------------------------------------------------------------
insert into course_offering (course_id, semester_id, instructor_id, section_id, registration_deadline)
select c.course_id, sem.semester_id, i.instructor_id, sec.section_id, v.reg_deadline::date
from (values
    -- course_code, semester_name, employee_id, section_name, batch, dept_code, reg_deadline
    ('CS1101', 'Fall 2025',   'EMP-001', 'A', 23, 'CS', '2025-08-25'),
    ('CS1101', 'Fall 2025',   'EMP-002', 'B', 23, 'CS', '2025-08-25'),
    ('CS2203', 'Fall 2025',   'EMP-001', 'A', 22, 'CS', '2025-08-25'),
    ('AI2001', 'Fall 2025',   'EMP-003', 'A', 23, 'AI', '2025-08-25'),
    ('SE2001', 'Fall 2025',   'EMP-004', 'A', 23, 'SE', '2025-08-25'),

    ('CS2203', 'Spring 2026', 'EMP-002', 'A', 23, 'CS', '2026-01-10'),
    ('CS2203', 'Spring 2026', 'EMP-001', 'B', 23, 'CS', '2026-01-10'),
    ('CS4203', 'Spring 2026', 'EMP-001', 'A', 22, 'CS', '2026-01-10'),
    ('AI3001', 'Spring 2026', 'EMP-003', 'A', 23, 'AI', '2026-01-10'),
    ('SE3001', 'Spring 2026', 'EMP-004', 'A', 23, 'SE', '2026-01-10'),
    ('AI3002', 'Spring 2026', 'EMP-005', 'A', 23, 'AI', '2026-01-10')
) as v(course_code, semester_name, employee_id, section_name, batch, dept_code, reg_deadline)
join course c on c.course_code = v.course_code
join semester sem on sem.semester_name = v.semester_name
join instructor i on i.employee_id = v.employee_id
join department d on d.department_code = v.dept_code
join section sec on sec.section_name = v.section_name and sec.batch = v.batch and sec.department_id = d.department_id;

-- -------------------------------------------------------------------------
-- 10. ANNOUNCEMENTS
-- Realistic announcements for existing course offerings
-- -------------------------------------------------------------------------
insert into announcement (
    offering_id,
    instructor_id,
    title,
    message,
    created_at
)
select
    co.offering_id,
    co.instructor_id,
    v.title,
    v.message,
    v.created_at::timestamp
from (values
    -- course_code, semester, employee_id, section, batch, dept_code,
    -- title, message, created_at

    ('CS1101', 'Fall 2025', 'EMP-001', 'A', 23, 'CS',
     'Programming Fundamentals - Assignment 1',
     'Assignment 1 has been posted. Submit your solution through the course portal before the deadline. Make sure your code follows the required submission format.',
     '2025-10-01 10:00:00'),

    ('CS1101', 'Fall 2025', 'EMP-002', 'B', 23, 'CS',
     'Programming Fundamentals - Quiz Reminder',
     'Quiz 1 will cover variables, data types, conditional statements, and basic input/output. Please review the Week 1 and Week 2 lecture material before attempting the quiz.',
     '2025-09-20 14:30:00'),

    ('CS2203', 'Fall 2025', 'EMP-001', 'A', 22, 'CS',
     'Data Structures - Midterm Preparation',
     'The midterm examination will cover arrays, linked lists, stacks, queues, and their basic operations. A revision session will be held during the next scheduled lecture.',
     '2025-11-10 09:00:00'),

    ('AI2001', 'Fall 2025', 'EMP-003', 'A', 23, 'AI',
     'Introduction to AI - Assignment Guidelines',
     'Assignment 1 is now available. Read the problem statement carefully and submit both your written explanation and source code. Late submissions may receive a penalty.',
     '2025-10-05 11:15:00'),

    ('SE2001', 'Fall 2025', 'EMP-004', 'A', 23, 'SE',
     'Software Engineering - Project Groups',
     'Students should finalize their project groups and select a project topic. Each group must submit its proposed topic and member list through the course portal.',
     '2025-09-28 13:00:00'),

    ('CS2203', 'Spring 2026', 'EMP-002', 'A', 23, 'CS',
     'Data Structures - Lecture Resources',
     'The latest lecture slides and course handout have been uploaded to the Resources section. Please review the material before the next class.',
     '2026-02-05 10:30:00'),

    ('CS2203', 'Spring 2026', 'EMP-001', 'B', 23, 'CS',
     'Data Structures - Quiz 1',
     'Quiz 1 has been posted and will focus on arrays, linked lists, and algorithm complexity. Please complete it before the stated deadline.',
     '2026-02-12 15:00:00'),

    ('CS4203', 'Spring 2026', 'EMP-001', 'A', 22, 'CS',
     'Compiler Construction - Midterm Topics',
     'The midterm will cover lexical analysis, regular expressions, finite automata, and basic parsing concepts. Additional revision material is available in the course resources.',
     '2026-03-20 09:30:00'),

    ('AI3001', 'Spring 2026', 'EMP-003', 'A', 23, 'AI',
     'Machine Learning - Assignment 1',
     'Assignment 1 has been posted. The task covers data preprocessing, exploratory analysis, and implementation of a basic machine learning model. Follow the submission instructions carefully.',
     '2026-02-20 12:00:00'),

    ('SE3001', 'Spring 2026', 'EMP-004', 'A', 23, 'SE',
     'Software Design - Design Document',
     'The first project milestone requires submission of the system design document. Include the architecture, major components, and relevant UML diagrams.',
     '2026-02-25 14:00:00'),

    ('AI3002', 'Spring 2026', 'EMP-005', 'A', 23, 'AI',
     'Neural Networks - Course Update',
     'The next lectures will introduce forward propagation, activation functions, loss functions, and backpropagation. Students are encouraged to review the uploaded lecture slides beforehand.',
     '2026-02-08 16:00:00')
) as v(
    course_code,
    semester_name,
    employee_id,
    section_name,
    batch,
    dept_code,
    title,
    message,
    created_at
)
join course c
    on c.course_code = v.course_code
join semester sem
    on sem.semester_name = v.semester_name
join instructor i
    on i.employee_id = v.employee_id
join department d
    on d.department_code = v.dept_code
join section sec
    on sec.section_name = v.section_name
   and sec.batch = v.batch
   and sec.department_id = d.department_id
join course_offering co
    on co.course_id = c.course_id
   and co.semester_id = sem.semester_id
   and co.instructor_id = i.instructor_id
   and co.section_id = sec.section_id;

-- -------------------------------------------------------------------------
-- 11. ENROLLMENTS
-- A student is enrolled into every course_offering that matches their own
-- section (this naturally yields 44 enrollments across both semesters).
-- -------------------------------------------------------------------------
insert into enrollment (student_id, offering_id, enrollment_date)
select s.student_id, co.offering_id, sem.start_date + interval '5 days'
from student s
join course_offering co on co.section_id = s.section_id
join semester sem on sem.semester_id = co.semester_id;

-- -------------------------------------------------------------------------
-- 12. ASSESSMENTS (4 per offering: Quiz, Assignment, Midterm, Final)
-- -------------------------------------------------------------------------
insert into assessment (offering_id, instructor_id, title, type, total_marks, due_date)
select co.offering_id, co.instructor_id, v.title, v.type, v.total_marks,
       sem.start_date + (v.offset_days || ' days')::interval
from course_offering co
join semester sem on sem.semester_id = co.semester_id
cross join (values
    ('Quiz 1',              'Quiz',       10, 15),
    ('Assignment 1',        'Assignment', 20, 30),
    ('Midterm Examination', 'Midterm',    30, 60),
    ('Final Examination',   'Final',      50, 110)
) as v(title, type, total_marks, offset_days);

-- -------------------------------------------------------------------------
-- 13. RESOURCES (2 per offering: slides + handout)
-- -------------------------------------------------------------------------
insert into resource (offering_id, instructor_id, title, description, resource_type, file_path)
select co.offering_id, co.instructor_id, v.title, v.description, v.resource_type,
       'resources/' || co.offering_id || '_' || v.suffix
from course_offering co
cross join (values
    ('Lecture Slides - Week 1', 'Introductory lecture slide deck for the course', 'PPTX', 'slides_week1.pptx'),
    ('Course Handout',          'Reference handout covering core course material', 'PDF',  'handout.pdf')
) as v(title, description, resource_type, suffix);

-- -------------------------------------------------------------------------
-- 14. SUBMISSIONS (one row per enrolled student per assessment)
-- -------------------------------------------------------------------------
insert into submission (assessment_id, student_id, file_path, submitted_at, status)
select a.assessment_id, e.student_id,
       'submissions/' || e.student_id || '_' || a.assessment_id || '.pdf',
       case
           when (e.student_id + a.assessment_id) % 20 = 0 then a.due_date + interval '6 hours'
           else a.due_date - interval '1 day'
       end,
       case
           when (e.student_id + a.assessment_id) % 20 = 0 then 'missing'
           when (e.student_id + a.assessment_id) % 20 in (1, 2) then 'late'
           else 'submitted'
       end
from assessment a
join enrollment e on e.offering_id = a.offering_id;

-- -------------------------------------------------------------------------
-- 15. GRADES (graded for every submission, 60%-100% of total marks)
-- -------------------------------------------------------------------------
insert into grade (submission_id, instructor_id, marks_obtained, feedback, graded_at)
select s.submission_id, a.instructor_id,
       floor(a.total_marks * (60 + (s.submission_id * 13) % 41) / 100.0)::int,
       'Good effort, keep up the consistent work.',
       s.submitted_at + interval '3 days'
from submission s
join assessment a on a.assessment_id = s.assessment_id;

-- -------------------------------------------------------------------------
-- 16. TRANSCRIPTS (one per student per semester they were enrolled in)
-- semester_gpa and cgpa are DERIVED, not independently assigned:
--   1. offering_perf: each student's average percentage in an offering,
--      computed directly from grade.marks_obtained / assessment.total_marks
--   2. graded: that percentage mapped to a letter grade + grade_points on a
--      standard 4.00 scale
--   3. semester_totals: credit-weighted GPA per student per semester
--   4. cumulative: a running credit-weighted average (CGPA) across semesters,
--      ordered by semester start_date, per student
-- This keeps grade -> transcript_entry -> transcript fully consistent.
-- -------------------------------------------------------------------------
with offering_perf as (
    select e.student_id, co.offering_id, co.semester_id, c.credit_hours,
           avg(g.marks_obtained::numeric / a.total_marks) * 100 as pct
    from enrollment e
    join course_offering co on co.offering_id = e.offering_id
    join course c on c.course_id = co.course_id
    join assessment a on a.offering_id = co.offering_id
    join submission s on s.assessment_id = a.assessment_id and s.student_id = e.student_id
    join grade g on g.submission_id = s.submission_id
    group by e.student_id, co.offering_id, co.semester_id, c.credit_hours
),
graded as (
    select op.*,
        case
            when pct >= 90 then 'A+' when pct >= 85 then 'A'  when pct >= 80 then 'A-'
            when pct >= 75 then 'B+' when pct >= 70 then 'B'  when pct >= 65 then 'B-'
            when pct >= 60 then 'C+' when pct >= 55 then 'C'  when pct >= 50 then 'C-'
            when pct >= 40 then 'D'  else 'F'
        end as letter_grade,
        case
            when pct >= 90 then 4.00 when pct >= 85 then 4.00 when pct >= 80 then 3.67
            when pct >= 75 then 3.33 when pct >= 70 then 3.00 when pct >= 65 then 2.67
            when pct >= 60 then 2.33 when pct >= 55 then 2.00 when pct >= 50 then 1.67
            when pct >= 40 then 1.00 else 0.00
        end as grade_points
    from offering_perf op
),
semester_totals as (
    select g.student_id, g.semester_id, sem.start_date,
           sum(g.grade_points * g.credit_hours) as weighted_points,
           sum(g.credit_hours) as total_credits
    from graded g
    join semester sem on sem.semester_id = g.semester_id
    group by g.student_id, g.semester_id, sem.start_date
),
cumulative as (
    select student_id, semester_id,
           round((weighted_points / total_credits)::numeric, 2) as semester_gpa,
           round(
               (sum(weighted_points) over (partition by student_id order by start_date)
                / sum(total_credits) over (partition by student_id order by start_date))::numeric
           , 2) as cgpa
    from semester_totals
)
insert into transcript (student_id, semester_id, semester_gpa, cgpa)
select student_id, semester_id, semester_gpa, cgpa
from cumulative;

-- -------------------------------------------------------------------------
-- 17. TRANSCRIPT ENTRIES (one per enrollment / completed offering)
-- Same offering_perf/graded derivation as above, joined to the transcript
-- row just inserted, so entry-level letter grades always match the
-- underlying marks_obtained data (and roll up correctly into GPA/CGPA).
-- -------------------------------------------------------------------------
with offering_perf as (
    select e.student_id, co.offering_id, co.semester_id, c.credit_hours,
           avg(g.marks_obtained::numeric / a.total_marks) * 100 as pct
    from enrollment e
    join course_offering co on co.offering_id = e.offering_id
    join course c on c.course_id = co.course_id
    join assessment a on a.offering_id = co.offering_id
    join submission s on s.assessment_id = a.assessment_id and s.student_id = e.student_id
    join grade g on g.submission_id = s.submission_id
    group by e.student_id, co.offering_id, co.semester_id, c.credit_hours
),
graded as (
    select op.*,
        case
            when pct >= 90 then 'A+' when pct >= 85 then 'A'  when pct >= 80 then 'A-'
            when pct >= 75 then 'B+' when pct >= 70 then 'B'  when pct >= 65 then 'B-'
            when pct >= 60 then 'C+' when pct >= 55 then 'C'  when pct >= 50 then 'C-'
            when pct >= 40 then 'D'  else 'F'
        end as letter_grade,
        case
            when pct >= 90 then 4.00 when pct >= 85 then 4.00 when pct >= 80 then 3.67
            when pct >= 75 then 3.33 when pct >= 70 then 3.00 when pct >= 65 then 2.67
            when pct >= 60 then 2.33 when pct >= 55 then 2.00 when pct >= 50 then 1.67
            when pct >= 40 then 1.00 else 0.00
        end as grade_points
    from offering_perf op
)
insert into transcript_entry (transcript_id, offering_id, letter_grade, grade_points, credits_earned)
select tr.transcript_id, g.offering_id, g.letter_grade, g.grade_points, g.credit_hours
from graded g
join transcript tr on tr.student_id = g.student_id and tr.semester_id = g.semester_id;

-- -------------------------------------------------------------------------
-- 18. FEE CHALLANS (one per student per semester)
-- -------------------------------------------------------------------------
insert into fee_challan (student_id, semester_id, amount, due_date, status)
select s.student_id, sem.semester_id,
       case when sem.semester_name = 'Fall 2025' then 75000.00 else 78000.00 end,
       case when sem.semester_name = 'Fall 2025' then date '2025-09-15' else date '2026-01-31' end,
       case
           when sem.semester_name = 'Fall 2025' then 'Paid'
           when s.student_id % 5 = 0 then 'Overdue'
           when s.student_id % 5 = 1 then 'Unpaid'
           else 'Paid'
       end
from student s
cross join semester sem;

-- -------------------------------------------------------------------------
-- 19. NOTIFICATIONS
-- -------------------------------------------------------------------------
-- Welcome / system notification for every user
insert into notification (user_id, title, message, notification_type, is_read)
select user_id, 'Welcome to UniSphere',
       'Welcome to UniSphere, your smart university service and information management system.',
       'System', false
from "user";

-- Fee notification for every fee challan generated
insert into notification (user_id, title, message, notification_type, is_read)
select st.user_id, 'Fee Challan Generated',
       'Your fee challan for ' || sem.semester_name || ' has been generated. Please review and pay before the due date.',
       'Fee', false
from fee_challan fc
join student st on st.student_id = fc.student_id
join semester sem on sem.semester_id = fc.semester_id;

-- Grade notification whenever a student's submission has been graded
insert into notification (user_id, title, message, notification_type, is_read)
select distinct st.user_id, 'Assessment Graded',
       'One of your assessments has been graded. Check your results.',
       'Grade', true
from grade g
join submission sub on sub.submission_id = g.submission_id
join student st on st.student_id = sub.student_id;

-- Assignment Posted: notify every enrolled student when an Assignment-type
-- assessment is created for their offering
insert into notification (user_id, title, message, notification_type, is_read)
select st.user_id, 'Assignment Posted',
       '"' || a.title || '" has been posted. Check the due date and submit before it closes.',
       'Assignment', false
from assessment a
join enrollment e on e.offering_id = a.offering_id
join student st on st.student_id = e.student_id
where a.type = 'Assignment';

-- Quiz Posted: notify every enrolled student when a Quiz-type assessment
-- is created for their offering
insert into notification (user_id, title, message, notification_type, is_read)
select st.user_id, 'Quiz Posted',
       '"' || a.title || '" has been posted. Check the due date and submit before it closes.',
       'Quiz', false
from assessment a
join enrollment e on e.offering_id = a.offering_id
join student st on st.student_id = e.student_id
where a.type = 'Quiz';

-- Resource Uploaded: notify every enrolled student when a new resource is
-- uploaded to their offering (notification_type 'Course' covers general
-- course-content updates since the schema has no dedicated 'Resource' type)
insert into notification (user_id, title, message, notification_type, is_read)
select st.user_id, 'Resource Uploaded',
       'A new resource, "' || r.title || '", has been uploaded to your course.',
       'Course', false
from resource r
join enrollment e on e.offering_id = r.offering_id
join student st on st.student_id = e.student_id;

-- -------------------------------------------------------------------------
-- 20. INSTRUCTOR JOB POSITIONS
-- -------------------------------------------------------------------------
insert into instructor_job_position (instructor_id, position_id)
select i.instructor_id, jp.position_id
from (values
    ('EMP-001', 'Assistant Professor'),
    ('EMP-001', 'Lab Engineer'),
    ('EMP-002', 'Lecturer'),
    ('EMP-003', 'Associate Professor'),
    ('EMP-004', 'Assistant Professor'),
    ('EMP-005', 'Professor')
) as v(employee_id, position_name)
join instructor i on i.employee_id = v.employee_id
join job_position jp on jp.position_name = v.position_name;

commit;

-- =========================================================================
-- End of seed.sql
-- =========================================================================
