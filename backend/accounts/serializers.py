from rest_framework import serializers
from .models import Student, Instructor

class StudentSerializer(serializers.ModelSerializer):

    class Meta:
        model = Student
        fields = [
            'student_id',
            'user',
            'roll_no',
            'first_name',
            'last_name',
            'cnic',
            'gender',
            'dob',
            'batch',
            'degree',
            'department',
            'section',
            'phone',
        ]
        read_only_fields = ['student_id']

class InstructorSerializer(serializers.ModelSerializer):

    class Meta:
        model = Instructor
        fields = [
            'instructor_id',
            'user',
            'employee_id',
            'first_name',
            'last_name',
            'cnic',
            'phone',
            'department',
        ]
        read_only_fields = ['instructor_id']