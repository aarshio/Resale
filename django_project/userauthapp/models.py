from django.db import models
from django.contrib.auth.models import User
# User info manager creates the user 
class UserInfoManager(models.Manager):
    def create_user_info(self, name, email, username, password):
        user = User.objects.create_user(username=username, password=password)
        user.name = name
        user.email = email

        user.save()

        acc = self.create(user=user)
        return acc
    def __str__(self):
        return self.name

# User info is a one to one relation with User  
class UserInfo(models.Model):
    user = models.OneToOneField(User,
                                on_delete=models.CASCADE,
                                primary_key=True)
    objects = UserInfoManager()

# Add is a one to many relation with User
class Add(models.Model):

    
    
    title = models.CharField(max_length=100)
    price = models.CharField(max_length=100)
    description = models.CharField(max_length=100)
    phnum = models.CharField(max_length=100)
    url = models.CharField(max_length=100)
    date = models.CharField(max_length=100) 
    # image = models.ImageField(upload_to='images')
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.title

