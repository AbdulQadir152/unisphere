from django.urls import path, include
from .views import StudentViewSet, InstructorViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()

router.register(
    'students',
    StudentViewSet,
    basename = 'student'
)

router.register(
    'instructors',
    InstructorViewSet,
    basename='instructor'
)

urlpatterns = [
    path('', include(router.urls)),
]