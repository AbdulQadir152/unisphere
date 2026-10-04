from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import IsAdminUser, IsAuthenticated

from .models import Enrollment
from .serializers import EnrollmentSerializer
from .permissions import IsStudent

# Create your views here.
class EnrollmentViewSet(ModelViewSet):

    queryset = Enrollment.objects.all()
    serializer_class = EnrollmentSerializer

    def get_permissions(self):
        if self.request.user.is_staff:
            return [IsAdminUser()]

        if self.action in ['list']:
            return [IsStudent()]
        
        return [IsAdminUser()]

    def get_queryset(self):
        if self.request.user.is_staff:
            return Enrollment.objects.all()

        try:
            student = self.request.user.student
        except AttributeError:
            return Enrollment.objects.none()

        return Enrollment.objects.filter(student = student)