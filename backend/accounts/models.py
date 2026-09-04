from django.contrib.auth.models import User
from django.db import models


class Student(models.Model):
    student_id = models.AutoField(primary_key=True)

    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        db_column="user_id",
    )

    roll_no = models.CharField(max_length=20, unique=True)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    cnic = models.CharField(max_length=15, unique=True)
    gender = models.CharField(max_length=10)
    dob = models.DateField()
    batch = models.IntegerField()
    degree = models.CharField(max_length=20)

    department = models.ForeignKey(
        "academics.Department",
        on_delete=models.DO_NOTHING,
        db_column="department_id",
    )

    section = models.ForeignKey(
        "academics.Section",
        on_delete=models.DO_NOTHING,
        db_column="section_id",
    )

    phone = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = "student"


class Instructor(models.Model):
    instructor_id = models.AutoField(primary_key=True)

    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        db_column="user_id",
    )

    employee_id = models.CharField(max_length=20, unique=True)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    cnic = models.CharField(max_length=15, unique=True)
    phone = models.CharField(max_length=20)

    department = models.ForeignKey(
        "academics.Department",
        on_delete=models.DO_NOTHING,
        db_column="department_id",
    )

    class Meta:
        managed = False
        db_table = "instructor"
