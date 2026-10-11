from rest_framework import serializers
from .models import Student, Instructor
from academics.models import Department, Section

class DepartmentSerializer(serializers.ModelSerializer):

    class Meta:
        model = Department
        fields = [
            'department_name',
            'department_code',
        ]

class SectionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Section
        fields = [
            'section_name'
        ]

class StudentSerializer(serializers.ModelSerializer):

    department = serializers.PrimaryKeyRelatedField(
        queryset = Department.objects.all()
    )
    section = serializers.PrimaryKeyRelatedField(
        queryset = Section.objects.all()
    )

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

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['department'] = DepartmentSerializer(instance.department).data
        data['section'] = SectionSerializer(instance.section).data
        return data 

class InstructorSerializer(serializers.ModelSerializer):

    department = serializers.PrimaryKeyRelatedField(
        queryset = Department.objects.all()
    )

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

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['department'] = DepartmentSerializer(instance.department).data
        return data