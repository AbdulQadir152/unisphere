from django.db import models


class Assessment(models.Model):
    assessment_id = models.AutoField(primary_key=True)

    offering = models.ForeignKey(
        "academics.CourseOffering",
        on_delete=models.CASCADE,
        db_column="offering_id",
    )

    instructor = models.ForeignKey(
        "accounts.Instructor",
        on_delete=models.DO_NOTHING,
        db_column="instructor_id",
    )

    title = models.CharField(max_length=100)
    type = models.CharField(max_length=20)
    total_marks = models.IntegerField()
    due_date = models.DateTimeField()
    created_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "assessment"


class Submission(models.Model):
    submission_id = models.AutoField(primary_key=True)

    assessment = models.ForeignKey(
        Assessment,
        on_delete=models.CASCADE,
        db_column="assessment_id",
    )

    student = models.ForeignKey(
        "accounts.Student",
        on_delete=models.CASCADE,
        db_column="student_id",
    )

    file_path = models.TextField()
    submitted_at = models.DateTimeField()
    status = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = "submission"
        unique_together = (("assessment", "student"),)


class Grade(models.Model):
    grade_id = models.AutoField(primary_key=True)

    submission = models.OneToOneField(
        Submission,
        on_delete=models.CASCADE,
        db_column="submission_id",
    )

    instructor = models.ForeignKey(
        "accounts.Instructor",
        on_delete=models.DO_NOTHING,
        db_column="instructor_id",
    )

    marks_obtained = models.IntegerField()
    feedback = models.TextField(blank=True, null=True)
    graded_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "grade"
