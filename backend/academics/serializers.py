from rest_framework import serializers
from .models import Department, Section, Semester, Course, CourseOffering

class DepartmentSerializer(serializers.ModelSerializer):

    class Meta:
        model = Department
        fields = [
            'department_id',
            'department_name',
            'department_code'
        ]
        read_only_fields = ['department_id']

class SectionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Section
        fields = [
            'section_id',
            'section_name',
            'batch',
            'department'
        ]
        read_only_fields = ['section_id']

class SemesterSerializer(serializers.ModelSerializer):

    class Meta:
        model = Semester
        fields = [
            'semester_id',
            'semester_name',
            'start_date',
            'end_date',
        ]
        read_only_fields = ['semester_id']

class CourseSerializer(serializers.ModelSerializer):

    class Meta:
        model = Course
        fields = [
            'course_id',
            'course_code',
            'course_name',
            'credit_hours',
            'department',
        ]
        read_only_fields = ['course_id']

class CourseOfferingSerializer(serializers.ModelSerializer):

    class Meta:
        model = CourseOffering
        fields = [
            'offering_id',
            'course',
            'semester',
            'instructor',
            'section',
            'registration_deadline',
        ]
        read_only_fields = ['offering_id']