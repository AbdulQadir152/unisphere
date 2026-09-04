from django.db import models


class Transcript(models.Model):
    transcript_id = models.AutoField(primary_key=True)

    student = models.ForeignKey(
        "accounts.Student",
        on_delete=models.CASCADE,
        db_column="student_id",
    )

    semester = models.ForeignKey(
        "academics.Semester",
        on_delete=models.CASCADE,
        db_column="semester_id",
    )

    semester_gpa = models.DecimalField(max_digits=3, decimal_places=2)
    cgpa = models.DecimalField(max_digits=3, decimal_places=2)

    class Meta:
        managed = False
        db_table = "transcript"


class TranscriptEntry(models.Model):
    entry_id = models.AutoField(primary_key=True)

    transcript = models.ForeignKey(
        Transcript,
        on_delete=models.CASCADE,
        db_column="transcript_id",
    )

    offering = models.ForeignKey(
        "academics.CourseOffering",
        on_delete=models.DO_NOTHING,
        db_column="offering_id",
    )

    letter_grade = models.CharField(max_length=2)
    grade_points = models.DecimalField(max_digits=3, decimal_places=2)
    credits_earned = models.IntegerField()

    class Meta:
        managed = False
        db_table = "transcript_entry"
        unique_together = (("transcript", "offering"),)
