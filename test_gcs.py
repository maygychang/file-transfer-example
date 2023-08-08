import datetime
from google.cloud import storage
from google.oauth2 import service_account


class GCS:
    project_id = "dmz-jitsi"
    bucket_name = "test-ftp-bucket-1"    
    s = storage.Client(project=project_id)
    key_path = "./key.json"

    def __init__(self):
        self.credentials = self.create_credentials()
        self.s = storage.Client(project=self.project_id, credentials=self.credentials)

    def create_credentials(self):
        credentials = service_account.Credentials.from_service_account_file(self.key_path)
        return credentials

    def list_objects_in_bucket(self):
        blobs = self.s.list_blobs(self.bucket_name)
        object_list = []
        print("Blobs:", blobs)
        for blob in blobs:
            object_list.append(blob.name)
        print("Listed all storage objects.", object_list)
        return object_list

    def upload_blob(self, src_file_name, dest_blob_name):
        bucket = self.s.bucket(self.bucket_name)
        blob = bucket.blob(dest_blob_name)
        generation_match_precondiction = 0 
        blob.upload_from_filename(src_file_name, if_generation_match=generation_match_precondition)
        print(f"File({src_file_name} uploaded to {dest_blob_name})")

    def generate_upload_signed_url_v4(self, blob_name):
        bucket = self.s.bucket(self.bucket_name)
        blob = bucket.blob(blob_name)
        url = blob.generate_signed_url(
            version="v4",
            expiration=datetime.timedelta(minutes=15),
            method="PUT",
            content_type="application/octet-stream"
        )
        print(f"Generated PUT signed URL: {url}\n")
        print("You can use this URL with any user agent, for example: ")
        print(f"curl -X PUT -H 'Content-Type: application/octet-stream' --upload-file my-file {url}")
        return url