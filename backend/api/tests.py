from django.test import TestCase

# Create your tests here.
from django.test import TestCase
from django.test import Client
from .models import *
from .views import *
from chance import chance
import random
import string
# Create your tests here.

def createSampleUser():
    pw_chars = string.ascii_letters + string.digits

    newUser = User.objects.create(
        email=chance.email(),
        first_name=chance.first(),
        last_name=chance.last(),
        middle_initial=chance.character(),
        suffix=chance.character(),
        phone_no=chance.phone(formatted=False),
        username=chance.string(),
        verified=chance.boolean(),
        rejected=chance.boolean(),
        archived=chance.boolean(),
        tickets=[],
        user_type="user",
        establishments=[],
        password='aA0'.join(random.choice(pw_chars) for i in range(8))
    )
    return newUser


class UserTestCase(TestCase):
    user = createSampleUser()

    def setUp(self):
        User.objects.create(
            email=self.user.email,
            first_name=self.user.first_name,
            last_name=self.user.last_name,
            middle_initial=self.user.middle_initial,
            suffix=self.user.suffix,
            phone_no=self.user.phone_no,
            username=self.user.username,
            verified=self.user.verified,
            rejected=self.user.rejected,
            id_type=self.user.id_type,
            id_number=self.user.id_number,
            archived=self.user.archived,
            tickets=self.user.tickets,
            user_type=self.user.user_type,
            establishments=self.user.establishments,
            password=self.user.password
        )

    def test_user(self):
        user = User.objects.get(email=self.user.email)
        self.assertEqual(user.email, self.user.email)
        self.assertEqual(user.first_name, self.user.first_name)
        self.assertEqual(user.last_name, self.user.last_name)
        self.assertEqual(user.middle_initial, self.user.middle_initial)
        self.assertEqual(user.suffix, self.user.suffix)
        self.assertEqual(user.phone_no, self.user.phone_no)
        self.assertEqual(user.username, self.user.username)
        self.assertEqual(user.verified, self.user.verified)
        self.assertEqual(user.rejected, self.user.rejected)
        self.assertEqual(user.id_type, self.user.id_type)
        self.assertEqual(user.id_number, self.user.id_number)
        self.assertEqual(user.archived, self.user.archived)
        self.assertEqual(user.tickets, self.user.tickets)
        self.assertEqual(user.user_type, self.user.user_type)
        self.assertEqual(user.establishments, self.user.establishments)
        self.assertEqual(user.password, self.user.password)


class SignUpViewTestCase(TestCase):
    newUser = createSampleUser()

    def test_signup(self):
        client = Client()

        response = client.post('/signup/', {
            "email": self.newUser.email,
            "first_name": self.newUser.first_name,
            "last_name": self.newUser.last_name,
            "middle_initial": self.newUser.middle_initial,
            "suffix": self.newUser.suffix,
            "phone_no": self.newUser.phone_no,
            "username": self.newUser.username,
            "verified": self.newUser.verified,
            "rejected": self.newUser.rejected,
            "id_type": self.newUser.id_type,
            "id_number": self.newUser.id_number,
            "archived": self.newUser.archived,
            "tickets": self.newUser.tickets,
            "user_type": self.newUser.user_type,
            "establishments": self.newUser.establishments,
            "password": self.newUser.password
        })
        self.assertEqual(response.status_code, 201)


class LoginViewTestCase(TestCase):
    newUser = createSampleUser()

    def signup(self):
        client = Client()

        response = client.post('/signup/', {
            "email": self.newUser.email,
            "first_name": self.newUser.first_name,
            "last_name": self.newUser.last_name,
            "middle_initial": self.newUser.middle_initial,
            "suffix": self.newUser.suffix,
            "phone_no": self.newUser.phone_no,
            "username": self.newUser.username,
            "verified": self.newUser.verified,
            "rejected": self.newUser.rejected,
            "id_type": self.newUser.id_type,
            "id_number": self.newUser.id_number,
            "archived": self.newUser.archived,
            "tickets": self.newUser.tickets,
            "user_type": self.newUser.user_type,
            "establishments": self.newUser.establishments,
            "password": self.newUser.password
        })

        self.assertEqual(response.status_code, 201)

    def test_login(self):
        self.signup()
        client = Client()

        response = client.post('/login/', {
            "email": self.newUser.email,
            "password": self.newUser.password
        })
        self.assertEqual(response.status_code, 200)


class UserDetailViewTestCase(TestCase):
    newUser = createSampleUser()

    def signup(self):
        client = Client()

        response = client.post('/signup/', {
            "email": self.newUser.email,
            "first_name": self.newUser.first_name,
            "last_name": self.newUser.last_name,
            "middle_initial": self.newUser.middle_initial,
            "suffix": self.newUser.suffix,
            "phone_no": self.newUser.phone_no,
            "username": self.newUser.username,
            "verified": self.newUser.verified,
            "rejected": self.newUser.rejected,
            "id_type": self.newUser.id_type,
            "id_number": self.newUser.id_number,
            "archived": self.newUser.archived,
            "tickets": self.newUser.tickets,
            "user_type": self.newUser.user_type,
            "establishments": self.newUser.establishments,
            "password": self.newUser.password
        })

        self.assertEqual(response.status_code, 201)

    def login(self):
        self.signup()
        client = Client()

        response = client.post('/login/', {
            "email": self.newUser.email,
            "password": self.newUser.password
        })

        self.assertEqual(response.status_code, 200)

    def test_user_detail(self):
        self.login()
        client = Client()

        response = client.get('/user-details/')
        self.assertEqual(response.status_code, 200)

class EditProfileViewTestCase(TestCase):
    newUser = createSampleUser()

    def signup(self):
        client = Client()

        response = client.post('/signup/', {
            "email": self.newUser.email,
            "first_name": self.newUser.first_name,
            "last_name": self.newUser.last_name,
            "middle_initial": self.newUser.middle_initial,
            "suffix": self.newUser.suffix,
            "phone_no": self.newUser.phone_no,
            "username": self.newUser.username,
            "verified": self.newUser.verified,
            "rejected": self.newUser.rejected,
            "id_type": self.newUser.id_type,
            "id_number": self.newUser.id_number,
            "archived": self.newUser.archived,
            "tickets": self.newUser.tickets,
            "user_type": self.newUser.user_type,
            "establishments": self.newUser.establishments,
            "password": self.newUser.password
        })

        self.assertEqual(response.status_code, 201)

    def login(self):
        self.signup()
        client = Client()

        response = client.post('/login/', {
            "email": self.newUser.email,
            "password": self.newUser.password
        })

        self.assertEqual(response.status_code, 200)

    def test_edit_profile(self):
        self.login()
        client = Client()

        editUser = createSampleUser()

        user = User.objects.get(email=self.newUser.email)
        response = client.put(f'/edit-profile/{user._id}/', {
            "email": editUser.email,
            "first_name": editUser.first_name,
            "last_name": editUser.last_name,
            "middle_initial": editUser.middle_initial,
            "suffix": editUser.suffix,
            "phone_no": editUser.phone_no,
            "username": editUser.username,
        },
        content_type='application/json')
        self.assertEqual(response.status_code, 200)


class DeleteUserViewTestCase(TestCase):
    newUser = createSampleUser()

    def signup(self):
        client = Client()

        response = client.post('/signup/', {
            "email": self.newUser.email,
            "first_name": self.newUser.first_name,
            "last_name": self.newUser.last_name,
            "middle_initial": self.newUser.middle_initial,
            "suffix": self.newUser.suffix,
            "phone_no": self.newUser.phone_no,
            "username": self.newUser.username,
            "verified": self.newUser.verified,
            "rejected": self.newUser.rejected,
            "id_type": self.newUser.id_type,
            "id_number": self.newUser.id_number,
            "archived": self.newUser.archived,
            "tickets": self.newUser.tickets,
            "user_type": self.newUser.user_type,
            "establishments": self.newUser.establishments,
            "password": self.newUser.password
        })

        self.assertEqual(response.status_code, 201)

    def login(self):
        self.signup()
        client = Client()

        response = client.post('/login/', {
            "email": self.newUser.email,
            "password": self.newUser.password
        })

        self.assertEqual(response.status_code, 200)

    def userdetail(self):
        self.login()
        client = Client()

        response = client.get('/user-details/')
        self.assertEqual(response.status_code, 200)

    def test_delete_user(self):
        self.login()
        client = Client()

        user = User.objects.get(email=self.newUser.email)
        response = client.delete(f'/delete-user/{user._id}/')
        self.assertEqual(response.status_code, 200)

    def userdetailerror(self):
        self.login()
        client = Client()

        response = client.get('/user-details/')
        self.assertEqual(response.status_code, 404)


def createSampleEstablishment():
    newEstablishment = Establishment.objects.create(
        name=chance.name(),
        owner=chance.string(),
        location_exact=chance.string(),
        location_approx=chance.string(),
        establishment_type=chance.string(),
        tenant_type=chance.string(),
        description=chance.string(),
        utilities=[],
        photos=[],
        proof_type=chance.string(),
        proof_number=chance.string(),
        proof_picture=chance.string(),
        reviews=[],
        verified=chance.boolean(),
        rejected=chance.boolean(),
        archived=chance.boolean(),
        accommodations=[],
    )
    return newEstablishment


class EstablishmentTestCase(TestCase):
    newEstablishment = createSampleEstablishment()

    def setUp(self):
        Establishment.objects.create(
            name=self.newEstablishment.name,
            owner=self.newEstablishment.owner,
            location_exact=self.newEstablishment.location_exact,
            location_approx=self.newEstablishment.location_approx,
            establishment_type=self.newEstablishment.establishment_type,
            tenant_type=self.newEstablishment.tenant_type,
            description=self.newEstablishment.description,
            utilities=self.newEstablishment.utilities,
            photos=self.newEstablishment.photos,
            proof_type=self.newEstablishment.proof_type,
            proof_number=self.newEstablishment.proof_number,
            proof_picture=self.newEstablishment.proof_picture,
            reviews=self.newEstablishment.reviews,
            verified=self.newEstablishment.verified,
            rejected=self.newEstablishment.rejected,
            archived=self.newEstablishment.archived,
            accommodations=self.newEstablishment.accommodations,
        )

    def test_establishment(self):
        establishment = Establishment.objects.get(name=self.newEstablishment.name)
        self.assertEqual(establishment.name, self.newEstablishment.name)
        self.assertEqual(establishment.owner, self.newEstablishment.owner)
        self.assertEqual(establishment.location_exact, self.newEstablishment.location_exact)
        self.assertEqual(establishment.location_approx, self.newEstablishment.location_approx)
        self.assertEqual(establishment.establishment_type, self.newEstablishment.establishment_type)
        self.assertEqual(establishment.tenant_type, self.newEstablishment.tenant_type)
        self.assertEqual(establishment.description, self.newEstablishment.description)
        self.assertEqual(establishment.utilities, self.newEstablishment.utilities)
        self.assertEqual(establishment.photos, self.newEstablishment.photos)
        self.assertEqual(establishment.proof_type, self.newEstablishment.proof_type)
        self.assertEqual(establishment.proof_number, self.newEstablishment.proof_number)
        self.assertEqual(establishment.proof_picture, self.newEstablishment.proof_picture)
        self.assertEqual(establishment.reviews, self.newEstablishment.reviews)
        self.assertEqual(establishment.verified, self.newEstablishment.verified)
        self.assertEqual(establishment.rejected, self.newEstablishment.rejected)
        self.assertEqual(establishment.archived, self.newEstablishment.archived)
        self.assertEqual(establishment.accommodations, self.newEstablishment.accommodations)


class CreateEstablishmentViewTestCase(TestCase):
    newEstablishment = createSampleEstablishment()

    def test_create(self):
        client = Client()

        response = client.post('/create-establishment/', {
            "name": self.newEstablishment.name,
            "owner": self.newEstablishment.owner,
            "location_exact": self.newEstablishment.location_exact,
            "location_approx": self.newEstablishment.location_approx,
            "establishment_type": self.newEstablishment.establishment_type,
            "tenant_type": self.newEstablishment.tenant_type,
            "description": self.newEstablishment.description,
            "utilities": self.newEstablishment.utilities,
            "photos": self.newEstablishment.photos,
            "proof_type": self.newEstablishment.proof_type,
            "proof_number": self.newEstablishment.proof_number,
            "proof_picture": self.newEstablishment.proof_picture,
            "reviews": self.newEstablishment.reviews,
            "verified": self.newEstablishment.verified,
            "rejected": self.newEstablishment.rejected,
            "archived": self.newEstablishment.archived,
            "accommodations": self.newEstablishment.accommodations,
        })
        

        self.assertEqual(response.status_code, 200)

# class ViewEstablishmentViewTestCase(TestCase):
#     newEstablishment = createSampleEstablishment()

#     def create_establishment(self):
#         client = Client()

#         response = client.post('/create-establishment/', {
#             "name": self.newEstablishment.name,
#             "owner": self.newEstablishment.owner,
#             "location_exact": self.newEstablishment.location_exact,
#             "location_approx": self.newEstablishment.location_approx,
#             "establishment_type": self.newEstablishment.establishment_type,
#             "tenant_type": self.newEstablishment.tenant_type,
#             "description": self.newEstablishment.description,
#             "utilities": self.newEstablishment.utilities,
#             "photos": self.newEstablishment.photos,
#             "proof_type": self.newEstablishment.proof_type,
#             "proof_number": self.newEstablishment.proof_number,
#             "proof_picture": self.newEstablishment.proof_picture,
#             "reviews": self.newEstablishment.reviews,
#             "verified": self.newEstablishment.verified,
#             "archived": self.newEstablishment.archived,
#             "accommodations": self.newEstablishment.accommodations,
#         })
#         self.assertEqual(response.status_code, 200)

#     def test_view(self):
#         client = Client()

#         establishment = Establishment.objects.get(name=self.newEstablishment.name)

#         response = client.get(f'/view-establishment/{establishment._id}/')
#         self.assertEqual(response.status_code, 200)

class ViewAllEstablishmentViewTestCase(TestCase):
    newEstablishment = createSampleEstablishment()
    anotherNewEstablishment = createSampleEstablishment()

    def test_view_all(self):
        client = Client()

        response = client.get('/view-all-establishment/')
        self.assertEqual(response.status_code, 200)

# class EditEstablishmentViewTestCase(TestCase):
#     newEstablishment = createSampleEstablishment()

#     def create_establishment(self):
#         client = Client()

#         response = client.post('/create-establishment/', {
#             "name": self.newEstablishment.name,
#             "owner": self.newEstablishment.owner,
#             "location_exact": self.newEstablishment.location_exact,
#             "location_approx": self.newEstablishment.location_approx,
#             "establishment_type": self.newEstablishment.establishment_type,
#             "tenant_type": self.newEstablishment.tenant_type,
#             "description": self.newEstablishment.description,
#             "utilities": self.newEstablishment.utilities,
#             "photos": self.newEstablishment.photos,
#             "proof_type": self.newEstablishment.proof_type,
#             "proof_number": self.newEstablishment.proof_number,
#             "proof_picture": self.newEstablishment.proof_picture,
#             "reviews": self.newEstablishment.reviews,
#             "verified": self.newEstablishment.verified,
#             "archived": self.newEstablishment.archived,
#             "accommodations": self.newEstablishment.accommodations,
#         })
#         self.assertEqual(response.status_code, 200)


#     def test_edit(self):
#         self.create_establishment()

#         client = Client()


#         establishment = Establishment.objects.get(name=self.newEstablishment.name)
    
#         anotherNewEstablishment = createSampleEstablishment()

#         response = client.put(f'/edit-establishment/{establishment._id}/', {
#             "name": anotherNewEstablishment.name,
#             "location_exact": anotherNewEstablishment.location_exact,
#             "location_approx": anotherNewEstablishment.location_approx,
#             "establishment_type": anotherNewEstablishment.establishment_type,
#             "tenant_type": anotherNewEstablishment.tenant_type,
#             "description": anotherNewEstablishment.description
#         })
#         self.assertEqual(response.status_code, 201)
#         self.assertNotEqual(establishment.name, self.newEstablishment.name)


# def createSampleRoom(estab_id):
#     price = random.randint(100, 1000)
#     newRoom = Room.objects.create(
#         availability=chance.boolean(),
#         price_lower=price,
#         price_upper=(price + random.randint(100, 1000)),
#         capacity=random.randint(1, 10),
#         establishment_id=estab_id,
#     )
#     return newRoom

# class AddRoomViewTestCase(TestCase):
#     newEstablishment = createSampleEstablishment()

#     def create_establishment(self):
#         client = Client()

#         response = client.post('/create-establishment/', {
#             "name": self.newEstablishment.name,
#             "owner": self.newEstablishment.owner,
#             "location_exact": self.newEstablishment.location_exact,
#             "location_approx": self.newEstablishment.location_approx,
#             "establishment_type": self.newEstablishment.establishment_type,
#             "tenant_type": self.newEstablishment.tenant_type,
#             "description": self.newEstablishment.description,
#             "utilities": self.newEstablishment.utilities,
#             "photos": self.newEstablishment.photos,
#             "proof_type": self.newEstablishment.proof_type,
#             "proof_number": self.newEstablishment.proof_number,
#             "proof_picture": self.newEstablishment.proof_picture,
#             "reviews": self.newEstablishment.reviews,
#             "verified": self.newEstablishment.verified,
#             "archived": self.newEstablishment.archived,
#             "accommodations": self.newEstablishment.accommodations,
#         })

#         self.assertEqual(response.status_code, 200)

#     def test_create(self):
#         self.create_establishment()
#         print(Establishment.objects.all())
#         newRoom = createSampleRoom(Establishment.objects.get(name=self.newEstablishment.name)._id)
#         client = Client()

#         print(newRoom.establishment_id)

#         response = client.post('/add-room/', {
#             "availability": newRoom.availability,
#             "price_lower": newRoom.price_lower,
#             "price_upper": newRoom.price_upper,
#             "capacity": newRoom.capacity,
#             "establishment_id": newRoom.establishment_id,
#         })
#         print(response.content)
#         self.assertEqual(response.status_code, 200)