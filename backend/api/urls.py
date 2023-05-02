from django.urls import path
from . import views
urlpatterns = [
    path("login/", views.login),
    path("signup/", views.signup),
    path("check/", views.check_authenticated),

    path('', views.getRoutes),
    path('admindetails/', views.getadmindetails),
    path('userdetails/', views.getuserdetails),
    path('reviewdetails/', views.getreviewdetails),

    # not working pa
    path('verifyuser/<str:pk>/update/', views.adminverifyuser),
]