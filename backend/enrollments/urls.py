from django.urls import path, include
from .views import StudentEnrollmentViewSet, AdminEnrollmentViewSet, AvailableOfferingView

from rest_framework.routers import DefaultRouter
student_router = DefaultRouter()
admin_router = DefaultRouter()

student_router.register('enrollments', StudentEnrollmentViewSet, basename = 'student-enrollment')
admin_router.register('enrollments', AdminEnrollmentViewSet, basename = 'admin-enrollment')


urlpatterns = [
    path('', include(student_router.urls)),
    path('admin/', include(admin_router.urls)),
    path('enrollments-available/', AvailableOfferingView.as_view(), name = 'available-enrollments'),
]