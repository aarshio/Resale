from django.http import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.http import JsonResponse
import json
from datetime import datetime
from userauthapp.models import Add, UserInfo, UserInfoManager
from django.db import IntegrityError

#POST request for posting an add into the data base
def post_add(request):
    #checks if user if auth
    if not request.user.is_authenticated:
        return HttpResponse("GetOut")
    #gets json request
    json_req = json.loads(request.body)
    title = json_req.get('title','')
    price = json_req.get('price', '')
    description = json_req.get('description','')
    phnum = json_req.get('phnum','')
    url = json_req.get('url','')
    now = datetime.now()
    now = now = datetime.now()
    date = str(now.strftime("%m/%d/%Y, %H:%M:%S"))
    u = request.user
    phnum =  "\n"+ str(request.user)+", "+u.email+", " +  phnum
    if title == "":
        return HttpResponse("IncompleteInfo")
    else: 
        # if all is good, posts the ads
        postAdd = Add(id = None,title = title, price = price, description = description, phnum =phnum, url = url, date = date, user = request.user)
        postAdd.save()
        return HttpResponse('AddPosted')
# GET request to get all ads on database
def get_adds(request):
     #checks if user if auth
    if not request.user.is_authenticated:
        return HttpResponse("IncompleteInfo")
    # fetched data from database, and converts to Json
    title = (list(Add.objects.values_list('title', flat=True)))[::-1]
    price = (list(Add.objects.values_list('price', flat=True)))[::-1]
    description = (list(Add.objects.values_list('description', flat=True)))[::-1]
    phnum = (list(Add.objects.values_list('phnum', flat=True)))[::-1]
    url = (list(Add.objects.values_list('url', flat=True)))[::-1]
    date = (list(Add.objects.values_list('date', flat=True)))[::-1]
    d = {"title":title, "price":price, "description":description, "phnum":phnum, "url":url, "date":date}

    return JsonResponse(d)

# POST request to add user
def add_user(request):
    """recieves a json request { 'username' : 'val0', 'password' : 'val1' } and saves it
       it to the database using the django User Model
       Assumes success and returns an empty Http Response"""
    logout(request)   
    try:

        json_req = json.loads(request.body)
        fname = json_req.get('fullname','')
        mail = json_req.get('email','')
        uname = json_req.get('username','')
        passw = json_req.get('password','')
        # checks if all fields are entered
        if fname!= ' ' and mail != ' ' and uname != '' and passw != " ":
            account = UserInfo.objects.create_user_info(name = fname, email = mail, username=uname,password=passw)
            user = authenticate(request, username=uname, password=passw)
            logout(request)                                
            account.save()
            login(request,user)
            return HttpResponse('Registered')
    # if some thing goes wrong
        else:
            return HttpResponse('Error')
    except IntegrityError:
        logout(request)
        return HttpResponse("Exsists")


# GET request to login user
def login_user(request):
    """recieves a json request { 'username' : 'val0' : 'password' : 'val1' } and
       authenticates and loggs in the user upon success """
    print("login")
    json_req = json.loads(request.body)
    uname = json_req.get('username','')
    passw = json_req.get('password','')
    # auth user
    user = authenticate(request,username=uname,password=passw)
    if user is not None:
        login(request,user)
        return HttpResponse("READY")
    else:
        return HttpResponse('LoginFailed')

# GET request to logout user
def logout_user(request):
    logout(request)
    return HttpResponse("LoggedOut")

# GET request to check for auth
def user_info(request):
    """serves content that is only available to a logged in user"""
    if not request.user.is_authenticated:
        return HttpResponse("LoggedOut")
    else:
        # do something only a logged in user can do
        return HttpResponse("Auth")
