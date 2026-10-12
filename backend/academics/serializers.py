from rest_framework import serializers
from .models import Department, Section, Semester, Course, CourseOffering
from accounts.models import Instructor
from accounts.serializers import NestedDepartmentSerializer

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

    department = serializers.PrimaryKeyRelatedField(
            queryset = Department.objects.all()
        )
    
    class Meta:
        model = Section
        fields = [
            'section_id',
            'section_name',
            'batch',
            'department'
        ]
        read_only_fields = ['section_id']

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['department'] = NestedDepartmentSerializer(instance.department).data
        return data

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

    department = serializers.PrimaryKeyRelatedField(
        queryset = Department.objects.all()
            )
    
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

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['department'] = NestedDepartmentSerializer(instance.department).data
        return data

class NestedCourseSerializer(serializers.ModelSerializer):

    department = serializers.PrimaryKeyRelatedField(
            queryset = Department.objects.all()
                )
    
    class Meta:
        model = Course
        fields = [
            'course_code',
            'course_name',
            'credit_hours',
            'department',
        ]
        read_only_fields = ['course_id']

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['department'] = NestedDepartmentSerializer(instance.department).data
        return data

class NestedSemesterSerializer(serializers.ModelSerializer):

    class Meta:
        model = Semester
        fields = [
            'semester_name',
        ]

class NestedInstructorSerializer(serializers.ModelSerializer):

    class Meta:
        model = Instructor
        fields = [
            'first_name',
            'last_name',
        ]

class NestedSectionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Section
        fields = [
            'section_name',
            'batch',
        ]

class CourseOfferingSerializer(serializers.ModelSerializer):

    course = serializers.PrimaryKeyRelatedField(
                queryset = Course.objects.all()
            )
    semester = serializers.PrimaryKeyRelatedField(
        queryset = Semester.objects.all()
    )
    instructor = serializers.PrimaryKeyRelatedField(
        queryset = Instructor.objects.all()
    )
    section = serializers.PrimaryKeyRelatedField(
        queryset = Section.objects.all()
    )

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

    def to_representation(self, instance):
            data = super().to_representation(instance)
            data['course'] = NestedCourseSerializer(instance.course).data
            data['semester'] = NestedSemesterSerializer(instance.semester).data
            data['instructor'] = NestedInstructorSerializer(instance.instructor).data
            data['section'] = NestedSectionSerializer(instance.section).data
            return data