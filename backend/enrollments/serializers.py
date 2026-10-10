from rest_framework import serializers
from django.utils import timezone

from .models import Enrollment
from academics.models import CourseOffering

class StudentEnrollmentSerialzier(serializers.ModelSerializer):

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

class AdminEnrollmentSerializer(serializers.ModelSerializer):

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

        enrollment_id = self.instance.enrollment_id if self.instance else None

        duplicate = Enrollment.objects.filter(
            student=student,
            offering=offering
        ).exclude(
            enrollment_id=enrollment_id
        ).exists()

        if duplicate:
            raise serializers.ValidationError(
                {
                    'offering':
                    'Student is already enrolled in this course offering.'
                }
            )

        return attrs

    def create(self, validated_data):

        return Enrollment.objects.create(
        student = validated_data['student'],
        offering = validated_data['offering'],
        enrollment_date = timezone.localdate(),
    )

class AvailableOfferingSerializer(serializers.ModelSerializer):

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