from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.find_member, name='register'),
]