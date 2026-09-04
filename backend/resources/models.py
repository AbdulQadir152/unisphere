from django.db import models


class Resource(models.Model):
    resource_id = models.AutoField(primary_key=True)

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
    description = models.TextField(blank=True, null=True)
    resource_type = models.CharField(max_length=20)
    file_path = models.TextField()
    uploaded_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "resource"


class Announcement(models.Model):
    announcement_id = models.AutoField(primary_key=True)

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
    message = models.TextField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "announcement"
