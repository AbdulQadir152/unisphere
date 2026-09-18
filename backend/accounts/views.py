from rest_framework.viewsets import ModelViewSet
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAdminUser, IsAuthenticated

from .models import Student, Instructor
from .serializers import StudentSerializer, InstructorSerializer

class StudentViewSet(ModelViewSet):

    queryset = Student.objects.all()
    serializer_class = StudentSerializer

    def get_permissions(self):

        if self.action == 'me':
            return [IsAuthenticated()]

        return [IsAdminUser()]
    
    @action(
        detail=False,
        methods=['get'],
        url_path='me'
    )
    def me(self, request):

        try:
            student = Student.objects.get(user = request.user)
        except Student.DoesNotExist:
            return Response(
                {'detail': 'Student profile not found.'},
                status=status.HTTP_404_NOT_FOUND
            )
        serializer = StudentSerializer(student)

        return Response(
            serializer.data, status = status.HTTP_200_OK
        )

class InstructorViewSet(ModelViewSet):

    queryset = Instructor.objects.all()
    serializer_class = InstructorSerializer

    def get_permissions(self):

        if self.action == 'me':
            return [IsAuthenticated()]

        return [IsAdminUser()]

    @action(
        detail=False,
        methods=['get'],
        url_path='me'
    )
    def me(self, request):

        try:
            instructor = Instructor.objects.get(user=request.user)

        except Instructor.DoesNotExist:
            return Response(
                {'detail': 'Instructor profile not found.'},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = self.get_serializer(instructor)

        return Response(
            serializer.data,
            status=status.HTTP_200_OK
        )