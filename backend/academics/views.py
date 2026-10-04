from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import IsAuthenticated, IsAdminUser

from .models import Department, Section, Semester, Course, CourseOffering
from .serializers import DepartmentSerializer, SectionSerializer, SemesterSerializer, CourseSerializer, CourseOfferingSerializer

class DepartmentViewSet(ModelViewSet):

    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer

    def get_permissions(self):

        if self.action in ['list', 'retrieve']:
            return [IsAuthenticated()]
        return [IsAdminUser()]

class SectionViewSet(ModelViewSet):

    queryset = Section.objects.all()
    serializer_class = SectionSerializer

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [IsAuthenticated()]
        return [IsAdminUser()]

class SemesterViewSet(ModelViewSet):

    queryset = Semester.objects.all()
    serializer_class = SemesterSerializer

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [IsAuthenticated()]
        return [IsAdminUser()]

class CourseViewSet(ModelViewSet):

    queryset = Course.objects.all()
    serializer_class = CourseSerializer

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [IsAuthenticated()]
        return [IsAdminUser()]

class CourseOfferingViewSet(ModelViewSet):

    queryset = CourseOffering.objects.all()
    serializer_class = CourseOfferingSerializer

    def get_permissions(self):
            if self.action in ['list', 'retrieve']:
                return [IsAuthenticated()]
            return [IsAdminUser()]