from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from urllib.parse import quote_plus
password = quote_plus('HackUm@ssModista!')

uri = "mongodb+srv://epicsri21:" + password + "@modistdb.dlzwa.mongodb.net/?retryWrites=true&w=majority&appName=modistdb&tls=true&tlsAllowInvalidCertificates=true"
# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))
# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)