from django.contrib.auth.models import User
from django.db import models


class Notification(models.Model):
    notification_id = models.AutoField(primary_key=True)

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        db_column="user_id",
    )

    title = models.CharField(max_length=100)
    message = models.TextField()
    notification_type = models.CharField(max_length=20)
    is_read = models.BooleanField()
    created_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = "notification"
