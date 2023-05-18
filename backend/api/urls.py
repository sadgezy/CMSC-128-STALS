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
    # path('establishmentdetails/', views.getestablishmentdetails),
    
    path('editprofile/<str:pk>/', views.editProfile),
    path('deleteuser/<str:pk>/', views.deleteuser),
    path('unverifyuser/<str:pk>/', views.adminunverifyuser),
    path('verifyuser/<str:pk>/', views.adminverifyuser),

    path('view-all-establishment/', views.view_all_establishment),
    path('view-establishment/<str:pk>/', views.view_establishment),
    path('create-establishment/', views.create_establishment),
    path('edit-establishment/<str:pk>/', views.edit_establishment),
    path('delete-establishment/<str:pk>/', views.delete_establishment),
    path('archive-establishment/<str:pk>/', views.archive_establishment),
    path('verify-establishment/<str:pk>/', views.verify_establishment),
    
    path('add-room/', views.add_room_to_establishment),
    path('edit-room/<str:pk>/', views.edit_room),
]