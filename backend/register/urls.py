from django.urls import path
from . import views

urlpatterns = [
    path('get_users/', views.find_member, name='register'),
]