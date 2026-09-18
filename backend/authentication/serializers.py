from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework import serializers
from rest_framework_simplejwt.tokens import RefreshToken


class loginSerializer(serializers.Serializer):

    username = serializers.CharField()
    password = serializers.CharField(write_only = True)

    def validate(self, attrs):
        username = attrs.get("username")
        password = attrs.get("password")

        user = authenticate(
            username = username,
            password = password
        )

        if user is None:
           raise serializers.ValidationError(
                'Invalid username or password.'
           )

        if not user.is_active:
            raise serializers.ValidationError(
                'This account is inactive.'
            )

        refresh = RefreshToken.for_user(user)

        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }

class UserSerializer(serializers.ModelSerializer):

    password = serializers.CharField(
        write_only = True,
        required = True
    )    

    class Meta:
        model = User
        fields = [
            'id',
            'username', 
            'email', 
            'first_name',
            'last_name',
            'password', 
            'is_active',
        ]
        read_only_fields = ['id']

    def create(self, validated_data):

        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()

        return user
