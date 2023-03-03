- Create a file `Dockerfile` and copy the followings.

```bash
FROM alpine
RUN apk update && apk upgrade
RUN apk add --update python3
RUN apk add py3-pip
RUN pip3 install flask
COPY . /app
WORKDIR /app
CMD python3 ./app.py 
```

- Create container image with `Dockerfile`.
```bash
docker build -t "said23/roman-app:2.0" .
```

- List all images. And push this image to Docker Hub.
```bash
docker image ls
docker push said23/roman-app:2.0
```

```bash
docker pull said23/roman-app:2.0
docker run -d --name <container-name> -p 80:80 <image-name>
```



