from rest_framework import serializers
from django.utils import timezone

from .models import Enrollment

class EnrollmentSerializer(serializers.ModelSerializer):

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

        offering = attrs.get('offering') 
        student = attrs.get('student')

        # Check student 
        if not student: 
            raise serializers.ValidationError( 
                {'student': 'Student is required.'} 
            ) 
        
        # Check course offering 
        if not offering: raise serializers.ValidationError( 
            {'offering': 'Course offering is required.'} 
            )

        # Check registration deadline
        if offering.registration_deadline < timezone.localdate():
            raise serializers.ValidationError(
                {'offering':'Registration deadline has passed.'}
            )

        # Check duplicate enrollment
        if Enrollment.objects.filter(
            student = student,
            offering = offering
        ).exists():
            raise serializers.ValidationError(
                {'offering':'Student is already enrolled in this course offering.'}
            )
        
        return attrs
    
    def create(self, validated_data):
        
        return Enrollment.objects.create(
            student=validated_data['student'],
            offering = validated_data['offering'],
            enrollment_date = timezone.localdate(),
        )


