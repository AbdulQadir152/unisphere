from rest_framework.viewsets import ModelViewSet
from rest_framework.generics import ListAPIView
from django.utils import timezone
from rest_framework.exceptions import PermissionDenied

from .models import Enrollment
from .serializers import StudentEnrollmentSerialzier, AdminEnrollmentSerializer, AvailableOfferingSerializer

from .permissions import IsStudent
from rest_framework.permissions import IsAdminUser

from academics.models import CourseOffering

class StudentEnrollmentViewSet(ModelViewSet):

    serializer_class = StudentEnrollmentSerialzier

    def get_permissions(self):

        if self.action in ['list', 'create', 'destroy']:
            return [IsStudent()]
        raise PermissionDenied("You do not have permission to perform this action.")

    def get_queryset(self):

        student = self.request.user.student

        return Enrollment.objects.filter(
            student = student
        )

class AdminEnrollmentViewSet(ModelViewSet):

    queryset = Enrollment.objects.all()
    serializer_class = AdminEnrollmentSerializer

    def get_permissions(self):
    
        if self.action in ['list', 'create', 'destroy']:
            return [IsAdminUser()]
        raise PermissionDenied("You do not have permission to perform this action.")

class AvailableOfferingView(ListAPIView):

    serializer_class = AvailableOfferingSerializer
    permission_classes = [IsStudent]

    def get_queryset(self):

        student = self.request.user.student

        return CourseOffering.objects.filter(
            course__department = student.department,
            registration_deadline__gte = timezone.localdate()
        ).exclude(
            enrollment__student = student
        )