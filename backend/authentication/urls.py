from django.urls import path, include
from .views import LoginView, LogoutView, UserViewSet
from rest_framework_simplejwt.views import (
    TokenRefreshView
)
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('users', UserViewSet, basename = 'user')

urlpatterns = [
    path('auth/login/', LoginView.as_view(), name = 'login'),
    path('auth/refresh/', TokenRefreshView.as_view(), name = 'refresh'),
    path('auth/logout/', LogoutView.as_view(), name = 'logout'),
    path('', include(router.urls)), 
]
