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
    if muses.find({"email":email}):
        response = {"data": True,"user":"Muse"}
    elif modists.find({"email":email}):
        response = {"data": True,"user":"Modist"}
    else:
        response = {"data": False,"user":"None"}

    print(response)
    return jsonify(response)

@app.route("/")
def test():
    return "test"

if __name__ == "__main__":
    app.run(debug=True,port=5000)