@set IMAGE_NAME=sample-flask-example

cd ..

docker build -t %IMAGE_NAME% .
docker run -it --rm -p 8080:8080 %IMAGE_NAME%
