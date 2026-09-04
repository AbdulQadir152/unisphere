from django.db import models


class Department(models.Model):
    department_id = models.AutoField(primary_key=True)
    department_name = models.CharField(max_length=100, unique=True)
    department_code = models.CharField(max_length=10, unique=True)

    class Meta:
        managed = False
        db_table = "department"


class Section(models.Model):
    section_id = models.AutoField(primary_key=True)

    section_name = models.CharField(max_length=5)
    batch = models.IntegerField()

    department = models.ForeignKey(
        Department,
        on_delete=models.DO_NOTHING,
        db_column="department_id",
    )

    class Meta:
        managed = False
        db_table = "section"
        unique_together = (("section_name", "batch", "department"),)


class Semester(models.Model):
    semester_id = models.AutoField(primary_key=True)
    semester_name = models.CharField(max_length=20, unique=True)
    start_date = models.DateField()
    end_date = models.DateField()

    class Meta:
        managed = False
        db_table = "semester"


class Course(models.Model):
    course_id = models.AutoField(primary_key=True)
    course_code = models.CharField(max_length=20, unique=True)
    course_name = models.CharField(max_length=100)
    credit_hours = models.IntegerField()

    department = models.ForeignKey(
        Department,
        on_delete=models.DO_NOTHING,
        db_column="department_id",
    )

    class Meta:
        managed = False
        db_table = "course"


class CourseOffering(models.Model):
    offering_id = models.AutoField(primary_key=True)

    course = models.ForeignKey(
        Course,
        on_delete=models.DO_NOTHING,
        db_column="course_id",
    )

    semester = models.ForeignKey(
        Semester,
        on_delete=models.DO_NOTHING,
        db_column="semester_id",
    )

    instructor = models.ForeignKey(
        "accounts.Instructor",
        on_delete=models.DO_NOTHING,
        db_column="instructor_id",
    )

    section = models.ForeignKey(
        Section,
        on_delete=models.DO_NOTHING,
        db_column="section_id",
    )

    registration_deadline = models.DateField()

    class Meta:
        managed = False
        db_table = "course_offering"
        unique_together = (("course", "semester", "section"),)


class JobPosition(models.Model):
    position_id = models.AutoField(primary_key=True)
    position_name = models.CharField(max_length=50, unique=True)

    class Meta:
        managed = False
        db_table = "job_position"


class InstructorJobPosition(models.Model):
    instructor_job_position_id = models.AutoField(primary_key=True)

    instructor = models.ForeignKey(
        "accounts.Instructor",
        on_delete=models.CASCADE,
        db_column="instructor_id",
    )

    position = models.ForeignKey(
        JobPosition,
        on_delete=models.DO_NOTHING,
        db_column="position_id",
    )

    class Meta:
        managed = False
        db_table = "instructor_job_position"
        unique_together = (("instructor", "position"),)
