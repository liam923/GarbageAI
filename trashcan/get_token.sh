export GOOGLE_APPLICATION_CREDENTIALS=garbageai-firebase-adminsdk-5aafn-8e73f12b20.json
export PROJECT_ID=garbageai
gcloud auth login
gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member="serviceAccount:firebase-adminsdk-5aafn@garbageai.iam.gserviceaccount.com" \
   --role="roles/automl.editor"
echo $(gcloud auth application-default print-access-token)
