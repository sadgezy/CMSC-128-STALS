from django.urls import path
from . import views
urlpatterns = [

    path('', views.getRoutes),
    path("login/", views.login),
    path("signup/", views.signup),
    path("check/", views.check_authenticated),

    path('admindetails/', views.getadmindetails),
    path('userdetails/', views.getuserdetails),
    path('reviewdetails/', views.getreviewdetails),
    path('ticketdetails/', views.getticketdetails),
    # path('accommodationdetails/', views.getaccommodationdetails),

    path('deleteuser/<str:pk>/', views.deleteuser),
    path('unverifyuser/<str:pk>/', views.adminunverifyuser),
    path('verifyuser/<str:pk>/', views.adminverifyuser),

    path('view-all-accommodation/', views.view_all_accommodation),
    path('view-accommodation/<str:pk>/', views.view_accommodation),
    path('create-accommodation/', views.create_accommodation),
    path('delete-accommodation/<str:pk>/', views.delete_accommodation),
    path('archive-accommodation/<str:pk>/', views.archive_accommodation),
]