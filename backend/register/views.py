from django.shortcuts import render
from django.http import JsonResponse
import sys
sys.path.insert(0, '../')
import db
# Create your views here.

def find_member(request):
    email = request.data.get('email')
    database = db.client["modistdb"]
    modists = database["modists"]
    modists = [modist for modist in modists.find({})]
    muses = database["muses"]
    muses = [muse for muse in muses.find({})]
    check_user = email in muses['email'] or email in modists['email']
    if email in muses['email']:
        response = {"data": True,"user":"Muse"}
    elif email in modists['email']:
        response = {"data": True,"user":"Modist"}
    else:
        response = {"data": False,"user":"None"}
    return JsonResponse(response)