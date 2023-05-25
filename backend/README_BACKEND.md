In the backend directory, run:  
- py -m venv venv  
- venv\Scripts\activate.bat  
- python -m pip install -r requirements.txt

In the directory where manage.py is located, run:  
- python manage.py makemigrations api
- python manage.py migrate
- python manage.py runserver
