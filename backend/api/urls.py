from django.urls import path
from . import views
urlpatterns = [

    path('', views.getRoutes),
    path("login/", views.login),
    path("signup/", views.signup),
    path("check/", views.check_authenticated),

    path('admin-details/', views.getadmindetails),
    path('user-details/', views.getuserdetails),
    path('get-one-user/', views.get_one_user),
    path('review-details/', views.getreviewdetails),
    path('delete-review/<str:pk>/', views.admindeletereview),
    path('ticket-details/', views.getticketdetails),
    # path('establishmentdetails/', views.getestablishmentdetails),
    path('edit-profile/<str:pk>/', views.editProfile),
    path('delete-user/<str:pk>/', views.deleteuser),
    path('unverify-user/<str:pk>/', views.adminunverifyuser),
    path('verify-user/<str:pk>/', views.adminverifyuser),
    path('view-all-user-favorites/', views.view_all_user_favorites),
    path('add-room-to-user-favorites/', views.add_room_to_user_favorites),

    path('create-establishment/', views.create_establishment),
    path('view-all-establishment/', views.view_all_establishment),
    path('view-establishment/<str:pk>/', views.view_establishment),
    path('edit-establishment/<str:pk>/', views.edit_establishment), 
    path('delete-establishment/<str:pk>/', views.delete_establishment), 
    path('verify-establishment/<str:pk>/', views.verify_establishment), 
    path('unverify-establishment/<str:pk>/', views.unverify_establishment), 
    path('archive-establishment/<str:pk>/', views.archive_establishment),
    path('unarchive-establishment/<str:pk>/', views.unarchive_establishment),
    path('report-establishment/', views.report_establishment),
    path('review-establishment/<str:pk>/', views.review_establishment),

    path('add-room/', views.add_room_to_establishment), 
    path('edit-room/<str:pk>/', views.edit_room), 
    path('delete-room/<str:pk>/', views.delete_room),

    path('view-all-users/', views.view_all_users),
    path('view-all-registered-users/', views.view_all_verified_users),
    path('view-all-verified-establishments/', views.view_all_verified_establishments),
    path('view-all-archived-establishments/', views.view_all_archived_establishments),
    
    path('search-room/', views.search_room),
    path('search-establishment/', views.search_establishment),
    
    path('view-all-users/', views.view_all_users),
    path('view-all-verified-users/', views.view_all_verified_users),
    path('view-all-verified-establishments/', views.view_all_verified_establishments),
    path('view-all-archived-establishments/', views.view_all_archived_establishments),

    path('get-one-user-using-id/<str:pk>/', views.get_one_user_using_id),
 ]