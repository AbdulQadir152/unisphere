from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated 
from rest_framework.views import APIView
from rest_framework.viewsets import ModelViewSet
from rest_framework_simplejwt.tokens import RefreshToken

from .serializers import loginSerializer, UserSerializer
from rest_framework.permissions import IsAdminUser

# Create your views here.

class LoginView(APIView):

    permission_classes = [AllowAny]
    def post(self, request):
        serializer = loginSerializer(data = request.data)
        serializer.is_valid(raise_exception=True)

        return Response(
            serializer.validated_data, status = status.HTTP_200_OK,
        )

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        refresh_token = request.data.get('refresh')

        if not refresh_token:
            return Response (
                {'detail': 'Refresh token is required.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            token = RefreshToken(refresh_token)
            token.blacklist()

            return Response(
                {'detail': 'Logout successful.'},
                status=status.HTTP_200_OK,
            )

        except Exception:
                return Response(
                {'detail': 'Invalid or expired refresh token.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

class UserViewSet(ModelViewSet):

    permission_classes = [IsAdminUser]
    queryset = User.objects.all()
    serializer_class = UserSerializer