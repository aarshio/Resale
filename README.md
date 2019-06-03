# Resale 

Resale is an online classified advertising service that operates as a centralized network of online communities

  - Peer to peer based
  - Allows instant access to community marketplace
  - Buy/Sell second hand items

# Features!

  - Client side built with Elm: recursion, list comphrension, client side development
  - User authentication with Django server: user registration, user login, user logout
  - SQL database, OneToMany relation using Foriegn key for user's relation to user's advertisements
  - Json parsing: Json encoding, and decoding with Python, and Elm

### Access
To access page from server on browser, follow this link
`https://mac1xa3.ca/e/patea80/static/project3.html`


### Installation

Clone the repo, create and activate a Python Environment

```sh
$ git clone https://github.com/patea80/CS1XA3.git
$ cd CS1XA3/Project03
$ python3 -m venv env
$ source env/bin/activate
```

For production environments install dependecies, and go into django_project...

```sh
$ pip install -r CS1XA3/Project03/requirements.txt
$ source env/bin/activate
$ cd CS1XA3/Project03/django_project/
$ python manage.py runserver localhost:10047
```

### Resources

| Resource | Source |
| ------ | ------ |
| W3 Layouts Bootstrap template | [http://w3layouts.com/][PlDb] |
| Elm Template | [https://github.com/NotAProfDalves/elm_django_examples][PlGh] |
# SQL Database
User Properties
> Fullname
> Email
> Username
> Password

Advertisement Properties
> Title
> Price
> Description
> PhoneNumber
> ImageUrl
> Date
