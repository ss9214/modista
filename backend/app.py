from flask import Flask, jsonify, request
from flask_cors import CORS
from mongoclient import client

# Allow Cross-Origin Resource Sharing to prevent CORS errors when making requests from the front end
app = Flask(__name__)
cors = CORS(app, resources={r"/api/*": {"origins": "*"}})

@app.route("/api/post/check-user/", methods=['POST'])
def check_user():
    email = request.get_json()["email"]
    database = client["modistdb"]
    modists = database["modists"]
    muses = database["muses"]
    if muses.find_one({"email":email}):
        response = {"data": True,"user":"Muse"}
    elif modists.find_one({"email":email}):
        response = {"data": True,"user":"Modist"}
    else:
        response = {"data": False,"user":"None"}
    print(response)
    return jsonify(response)

@app.route("/api/post/create-user/",methods=['POST'])
def create_user():
    data = request.get_json()
    database = client["modistdb"]
    if data["user"] == "muse":
        del data["user"]
        database["muses"].insert_one(data)
    else:
        del data["user"]
        database["modists"].insert_one(data)

@app.route("/api/post/make-order/",methods=['POST'])
def make_order():
    data = request.get_json()
    database = client["modistdb"]
    orders_collection = database["orders"]
    orders = orders_collection.find({}).sort("style_id",-1).limit(1)
    for order in orders:
        next_id = order["style_id"] + 1
    orders_collection.insert_one({"style_id":next_id,"modist":data["modist"],"muse":data["muse"],"price":data["price"]})
    
@app.route("/api/get/modist-list",methods=['GET'])
def get_modists():
    database = client["modistdb"]
    modists_collection = database["modists"]
    cursor = modists_collection.find({})
    modists = []
    for modist in cursor:
        modists.append(modist)
    return {"Modists":modists}

if __name__ == "__main__":
    app.run(debug=True,port=5000)