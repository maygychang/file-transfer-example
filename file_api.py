from distutils.log import debug
from fileinput import filename
from flask import *
from test_gcs import GCS 
app = Flask(__name__)


@app.route('/')
def main():
    response = { 
    "api": "CloudMile API",
    "version": "v1.0.0",
    "status": "running",
    "message": "Welcome to CloudMile"
    }   
    return response


@app.route('/upload', methods = ['POST', "GET"])
def upload():
    response = {}
    gcs = GCS()
    f = request.files.get('file')
    if not f:
        file_name = request.args.get("file")
    else:
        file_name = f.file_name    
    if request.method == 'POST':
        src_file_name = file_name
        dest_blob_name = file_name
        f.save(f.filename)
        gcs.upload_blob(src_file_name, dest_blob_name)
        response["statue"] = "save files"
    elif request.method == "GET":
        blob_name = file_name 
        url = gcs.generate_upload_signed_url_v4(blob_name)
        response["url"] = url 
        response["status"] = "OK"
    else:
        response["status"] = "Error Arguments"
    return response


@app.route('/list', methods = ["GET"])
def list():
    response = {}
    gcs = GCS()
    if request.method == "GET":
        object_list = gcs.list_objects_in_bucket()
        response["objects"] = object_list
        response["status"] = "get files"
    return response


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=8080)