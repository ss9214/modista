from django.shortcuts import render
from django.http import HttpResponse
import sys
sys.path.insert(0, '../')
import db
# Create your views here.

def find_member(request):
    database = db.client["modistdb"]
    modists = database["modists"]
    modists = [modist for modist in modists.find({})]
    muses = database["muses"]
    muses = [muse for muse in muses.find({})]
    response = {"data":{"modists":modists,"muses":muses},"status":"Sucessful"}
    print(response)
    return HttpResponse(response)