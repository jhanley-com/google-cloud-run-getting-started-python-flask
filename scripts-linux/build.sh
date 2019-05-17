source ./env.sh

cd ..

gcloud builds submit \
--tag gcr.io/$PROJECT_ID/$IMAGE_NAME

gcloud beta run deploy $SERVICE_NAME \
--region $REGION \
--image gcr.io/$PROJECT_ID/$IMAGE_NAME \
--allow-unauthenticated

cd scripts-linux
