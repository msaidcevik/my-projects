- Create a file `Dockerfile` and copy the followings.

```bash
FROM ubuntu
RUN apt-get update -y
RUN apt-get install python3 -y
RUN apt-get install python3-pip -y
RUN pip3 install flask
COPY . /app
WORKDIR /app
CMD python3 ./app.py
```

- Create container image with `Dockerfile`.
```bash
docker build -t "said23/roman-app:1.0" .
```

- List all images. And push this image to Docker Hub.
```bash
docker image ls
docker push said23/roman-app:1.0
```

```bash
docker pull said23/roman-app:1.0
docker run -d --name <container-name> -p 80:80 <image-name>
```



