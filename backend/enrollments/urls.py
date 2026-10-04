from django.urls import path, include
from .views import EnrollmentViewSet

from rest_framework.routers import DefaultRouter
router = DefaultRouter()

router.register('enrollments', EnrollmentViewSet, basename = 'enrollment')


urlpatterns = [
    path('', include(router.urls)),
]