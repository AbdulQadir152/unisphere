from django.db import models


class Enrollment(models.Model):
    enrollment_id = models.AutoField(primary_key=True)

    student = models.ForeignKey(
        "accounts.Student",
        on_delete=models.CASCADE,
        db_column="student_id",
    )

    offering = models.ForeignKey(
        "academics.CourseOffering",
        on_delete=models.CASCADE,
        db_column="offering_id",
    )

    enrollment_date = models.DateField()

    class Meta:
        managed = False
        db_table = "enrollment"
        unique_together = (("student", "offering"),)
