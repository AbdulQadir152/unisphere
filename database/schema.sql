create table department (
    department_id integer generated always as identity primary key,
    department_name varchar(100) not null unique,
    department_code varchar(10) not null unique
);

create table section (
    section_id integer generated always as identity primary key,
    section_name varchar(5) not null,
    batch integer not null,
    department_id integer not null  references department(department_id),
    unique(section_name, batch, department_id)
);

create table student(
    student_id integer generated always as identity primary key,
    user_id integer not null unique references auth_user(id) on delete cascade,
    roll_no varchar(20) not null unique,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    cnic varchar(15) not null unique,
    gender varchar(10) not null check (gender in ('Male', 'Female', 'Other')),
    dob date not null,
    batch integer not null,
    degree varchar(20) not null,
    department_id integer not null references department(department_id),
    section_id integer not null references section(section_id),
    phone varchar(20) not null 
);

create table instructor (
    instructor_id integer generated always as identity primary key,
    user_id integer not null unique references auth_user(id) on delete cascade,
    employee_id varchar(20) not null unique,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    cnic varchar(15) not null unique,
    phone varchar(20) not null,
    department_id integer not null references department(department_id)
);

create table semester (
    semester_id integer generated always as identity primary key,
    semester_name varchar(20) not null unique,
    start_date date not null,
    end_date date not null,
    check (end_date > start_date)
);

create table course (
    course_id integer generated always as identity primary key,
    course_code varchar(20) not null unique,
    course_name varchar(100) not null,
    credit_hours integer not null check (credit_hours between 1 and 6),
    department_id integer not null references department(department_id)
);

create table course_offering (
    offering_id integer generated always as identity primary key,
    course_id integer not null references course(course_id),
    semester_id integer not null references semester(semester_id),
    instructor_id integer not null references instructor(instructor_id),
    section_id integer not null references section(section_id),
    registration_deadline date not null,
    unique(course_id, semester_id, section_id)
);

create table enrollment (
    enrollment_id integer generated always as identity primary key,
    student_id integer not null references student(student_id) on delete cascade,
    offering_id integer not null references course_offering(offering_id) on delete cascade,
    enrollment_date date not null,
    unique(student_id, offering_id)
);

create table assessment (
    assessment_id integer generated always as identity primary key,
    offering_id integer not null references course_offering(offering_id) on delete cascade,
    instructor_id integer not null references instructor(instructor_id),
    title varchar(100) not null,
    type varchar(20) not null check (type in ('Assignment', 'Quiz', 'Midterm', 'Final')),
    total_marks integer not null check (total_marks > 0),
    due_date timestamp not null,
    created_at timestamp not null default current_timestamp
);

create table submission (
    submission_id integer generated always as identity primary key,
    assessment_id integer not null  references assessment(assessment_id) on delete cascade,
    student_id integer not null references student(student_id) on delete cascade,
    file_path text not null,
    submitted_at timestamp not null default current_timestamp,
    status varchar(20) not null default 'submitted' check (status in ('submitted', 'late', 'missing' )),
    unique(assessment_id, student_id)
);

create table grade (
    grade_id integer generated always as identity primary key,
    submission_id integer not null unique references submission(submission_id) on delete cascade,
    instructor_id integer not null references instructor(instructor_id),
    marks_obtained integer not null check (marks_obtained >= 0),
    feedback text,
    graded_at timestamp not null default current_timestamp
);

create table resource (
    resource_id integer generated always as identity primary key,
    offering_id integer not null references course_offering(offering_id) on delete cascade,
    instructor_id integer not null references instructor(instructor_id),
    title varchar(100) not null,
    description text,
    resource_type varchar(20) not null check (resource_type in ('PDF', 'DOCX', 'PPTX', 'ZIP', 'IMAGE', 'VIDEO')),
    file_path text not null,
    uploaded_at timestamp not null default current_timestamp
);

create table announcement(
    announcement_id integer generated always as identity primary key,
    offering_id integer not null references course_offering(offering_id) on delete cascade,
    instructor_id integer not null references instructor(instructor_id),
    title varchar(100) not null,
    message text not null,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp
);

create table transcript(
    transcript_id integer generated always as identity primary key, 
    student_id integer not null references student(student_id) on delete cascade,
    semester_id integer not null references semester(semester_id) on delete cascade,
    semester_gpa numeric(3, 2) not null check(semester_gpa between 0.00 and 4.00), 
    cgpa numeric(3, 2) not null check(cgpa between 0.00 and 4.00)
);

create table transcript_entry (
    entry_id integer generated always as identity primary key,
    transcript_id integer not null references transcript(transcript_id) on delete cascade,
    offering_id integer not null references course_offering(offering_id),
    letter_grade varchar(2) not null check (letter_grade in ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D', 'F')),
    grade_points numeric(3,2) not null check (grade_points between 0.00 and 4.00),
    credits_earned integer not null check (credits_earned >= 0),
    unique(transcript_id, offering_id)
);

create table fee_challan (
    challan_id integer generated always as identity primary key,
    student_id integer not null references student(student_id) on delete cascade,
    semester_id integer not null references semester(semester_id),
    amount numeric(10,2) not null check (amount > 0),
    due_date date not null,
    status varchar(20) not null check (status in ('Paid', 'Unpaid', 'Overdue')),
    generated_at timestamp not null default current_timestamp,
    unique(student_id, semester_id)
);

create table notification (
    notification_id integer generated always as identity primary key,
    user_id integer not null references auth_user(id) on delete cascade,
    title varchar(100) not null,
    message text not null,
    notification_type varchar(20) not null check (notification_type in ('Assignment', 'Quiz', 'Grade', 'Fee', 'Course', 'Announcement', 'System')),
    is_read boolean not null default false,
    created_at timestamp not null default current_timestamp
);

create table job_position(
    position_id integer generated always as identity primary key,
    position_name varchar(50) not null unique
);

create table instructor_job_position(
    instructor_job_position_id integer generated always as identity primary key, 
    instructor_id integer not null references instructor(instructor_id) on delete cascade,
    position_id integer not null references job_position(position_id),
    unique(instructor_id, position_id)
);