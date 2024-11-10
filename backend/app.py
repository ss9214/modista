from flask import Flask, jsonify, request
from flask_cors import CORS
from mongoclient import client

# Allow Cross-Origin Resource Sharing to prevent CORS errors when making requests from the front end
app = Flask(__name__)
cors = CORS(app, resources={r"/api/*": {"origins": "*"}})

@app.route("/api/post/check-user",methods=['POST'])
def check_user():
    email = "sriharisriva@umass.edu"
    database = client["modistdb"]
    modists = database["modists"]
    modists = [modist for modist in modists.find({})]
    muses = database["muses"]
    muses = [muse for muse in muses.find({})]
    if email in muses['email']:
        response = {"data": True,"user":"Muse"}
    elif email in modists['email']:
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