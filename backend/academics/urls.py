from django.urls import path, include
from .views import DepartmentViewSet, SectionViewSet, SemesterViewSet, CourseViewSet, CourseOfferingViewSet

from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register('departments', DepartmentViewSet, basename = 'department')
router.register('sections', SectionViewSet, basename = 'section')
router.register('semesters', SemesterViewSet, basename = 'semester')
router.register('courses', CourseViewSet, basename = 'course')
router.register('course-offerings', CourseOfferingViewSet, basename = 'course-offering')

urlpatterns = [
    path('', include(router.urls)),
]