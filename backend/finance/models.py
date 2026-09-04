from django.db import models


class FeeChallan(models.Model):
    challan_id = models.AutoField(primary_key=True)

    student = models.ForeignKey(
        "accounts.Student",
        on_delete=models.CASCADE,
        db_column="student_id",
    )

    semester = models.ForeignKey(
        "academics.Semester",
        on_delete=models.DO_NOTHING,
        db_column="semester_id",
    )

    amount = models.DecimalField(max_digits=10, decimal_places=2)
    due_date = models.DateField()
    status = models.CharField(max_length=20)
    generated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "fee_challan"
        unique_together = (("student", "semester"),)