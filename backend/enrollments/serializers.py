from rest_framework import serializers
from django.utils import timezone

from .models import Enrollment
from academics.models import CourseOffering, Department, Section, Semester, Course
from accounts.models import Student, Instructor

from accounts.serializers import NestedDepartmentSerializer, NestedSectionSerializer
from academics.serializers import NestedCourseSerializer, NestedSemesterSerializer, NestedInstructorSerializer

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
            'roll_no',
            'first_name',
            'last_name',
            'department',
            'section',
            'batch',
        ]

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['department'] = NestedDepartmentSerializer(instance.department).data
        data['section'] = NestedSectionSerializer(instance.section).data
        return data 

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
            'course',
            'semester',
            'instructor',
            'section',
            'registration_deadline',
        ]

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['course'] = NestedCourseSerializer(instance.course).data
        data['semester'] = NestedSemesterSerializer(instance.semester).data
        data['instructor'] = NestedInstructorSerializer(instance.instructor).data
        data['section'] = NestedSectionSerializer(instance.section).data
        return data

class StudentEnrollmentSerialzier(serializers.ModelSerializer):

    student = serializers.PrimaryKeyRelatedField(
            queryset = Student.objects.all()
        )
    offering = serializers.PrimaryKeyRelatedField(
            queryset = CourseOffering.objects.all()
        )
    class Meta:
        model = Enrollment
        fields = [
            'enrollment_id',
            'student',
            'offering',
            'enrollment_date',
        ]
        read_only_fields = [
            'enrollment_id',
            'student',
            'enrollment_date',
        ]

    def validate(self, attrs):

        request = self.context['request']
        student = request.user.student
        offering = attrs.get('offering')

        if not offering:
            raise serializers.ValidationError(
                {'offering':'Course offering is required.'}
            )

        if offering.registration_deadline < timezone.localdate():
            raise serializers.ValidationError(
                {'offering':'Registration deadline has passed.'}
            )

        if offering.course.department_id != student.department_id:
            raise serializers.ValidationError(
                {'offering': 'You can only enroll in offerings from your department.'}
            )

        if Enrollment.objects.filter(
            student = student,
            offering = offering
        ).exists():
            raise serializers.ValidationError(
                {'offering':'You are already enrolled in this course offering.'}
            )

        return attrs


    def create(self, validated_data):

        student = self.context['request'].user.student

        return Enrollment.objects.create(
            student = student,
            offering = validated_data.get('offering'),
            enrollment_date = timezone.localdate(),
        )

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['student'] = StudentSerializer(instance.student).data
        data['offering'] = CourseOfferingSerializer(instance.offering).data
        return data

class AdminEnrollmentSerializer(serializers.ModelSerializer):

    student = serializers.PrimaryKeyRelatedField(
        queryset = Student.objects.all()
    )
    offering = serializers.PrimaryKeyRelatedField(
        queryset = CourseOffering.objects.all()
    )
    class Meta:
        model = Enrollment
        fields = [
            'enrollment_id',
            'student',
            'offering',
            'enrollment_date',
        ]
        read_only_fields = [
            'enrollment_id',
            'enrollment_date',
        ]

    def validate(self, attrs):

        student = attrs.get('student')
        offering = attrs.get('offering')

        if not student:
            raise serializers.ValidationError(
                {'student': 'Student is required.'}
            )

        if not offering:
            raise serializers.ValidationError(
                {'offering': 'Course offering is required.'}
            )

        if offering.registration_deadline < timezone.localdate():
            raise serializers.ValidationError(
                {'offering': 'Registration deadline has passed.'}
            )

        if Enrollment.objects.filter(
            student = student,
                offering = offering
            ).exists():
                raise serializers.ValidationError(
                {'offering':'You are already enrolled in this course offering.'}
                )
        
        return attrs

    def create(self, validated_data):

        return Enrollment.objects.create(
        student = validated_data['student'],
        offering = validated_data['offering'],
        enrollment_date = timezone.localdate(),
    )

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['student'] = StudentSerializer(instance.student).data
        data['offering'] = CourseOfferingSerializer(instance.offering).data
        return data

class AvailableOfferingSerializer(serializers.ModelSerializer):

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

    def to_representation(self, instance):
            data = super().to_representation(instance)
            data['course'] = NestedCourseSerializer(instance.course).data
            data['semester'] = NestedSemesterSerializer(instance.semester).data
            data['instructor'] = NestedInstructorSerializer(instance.instructor).data
            data['section'] = NestedSectionSerializer(instance.section).data
            return data