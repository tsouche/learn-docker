
# Docker - 'Get started' tutorial


## Intro - pre-requisites

Here are the identified pre-requisites to run this tutorial and actually learn something from this experience:

* have a linux laptop, and an account with `sudo privilege` (i.e. you have admin rights to execute some commands). Ubuntu 20.04 will be a perfect choice for beginners.
* have `curl`, `git` and `virtualbox` installed (see the 'Installation appendix')
* have `docker`, `docker-compose` and `docker-machine` installed  (see the 'Installation appendix')
* have a DockerHub account (with login / pwd)
* have a GitHub account (with login / pwd)

In case you need help, an installation script is shown in the appendix. The script was tested for Ubuntu 20.04. 

***This is it!*** Everything in the list is free (except the laptop itself) and nothing else is needed... except the desire to learn :-)

***


## Part 1 - Orientation and setup

### 1.1 - Docker concepts

Docker is a platform for developers and sysadmins to develop, deploy, and run applications with containers. The use of Linux containers to deploy applications is called containerization. Containers are not new, but their use for easily deploying applications is.

Containerization is increasingly popular because containers are:

* *Flexible*: Even the most complex applications can be containerized.
* *Lightweight*: Containers leverage and share the host kernel.
* *Interchangeable*: You can deploy updates and upgrades on-the-fly.
* *Portable*: You can build locally, deploy to the cloud, and run anywhere.
* *Scalable*: You can increase and automatically distribute container replicas.
* *Stackable*: You can stack services vertically and on-the-fly.


#### Images and containers

A container is launched by running an image. An image is an executable package that includes everything needed to run an application: the code, a runtime, libraries, environment variables, and configuration files.

A container is a runtime instance of an image, i.e. the image is loaded in memory and executed. You will see later that you can see a list of your running containers with the command `docker ps` just as you would in Linux.


#### Containers and virtual machines

A container runs natively on Linux and shares the kernel of the host machine with other containers. It runs a discrete process, taking no more memory than any other executable, making it lightweight.

By contrast, a virtual machine (VM) runs a full-blown “guest” operating system with virtual access to host resources through a hypervisor. In general, VMs provide an environment with more resources than most applications need.

In this tutorial, we will start with running *containers* on your machine. In order to illustrate concepts like *stacks* or *services*, we will then actually generate *several VMs* on your machine, which will simulate a *cluster of servers* on top of which you will dispatch and execute (we say *'orchestrate'*) several containers.  


### 1.2 - Prepare your Docker environment


We assume here that your machine runs a recent version of Ubuntu. In case you run a different distribution, please look on the web for the appropriate installation procedure. We also provide in the appendix the installation script to get your machine ready (assuming that Ubuntu is your OS).

The installation script in the Appendix will guide through the installation of the various software required to run through the tutorial:

* curl
* docker Community Edition (CE) to manage and execute containers
* docker-machine to generate a cluster of VMs on your machine 
* docker-compose to orchestrate containers on this cluster

This should be enough to run the tutorial. Let's now test that everything is fine before we really start the tutorial.

#### Test Docker version

Run the command `docker --version` and ensure that you have a supported version of Docker:

```
tuto@laptop:~$ docker --version
Docker version 19.03.8, build afacb8b7f0
```
Run `docker info` or `docker version` (without `--`) to view even more details about your docker installation:

```
tuto@laptop:~$ docker version
Client:
 Version:           19.03.8
 API version:       1.40
 Go version:        go1.13.8
 Git commit:        afacb8b7f0
 Built:             Wed Mar 11 23:42:35 2020
 OS/Arch:           linux/amd64
 Experimental:      false

Server:
 Engine:
  Version:          19.03.8
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.13.8
  Git commit:       afacb8b7f0
  Built:            Wed Mar 11 22:48:33 2020
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.3.3-0ubuntu2
  GitCommit:        
 runc:
  Version:          spec: 1.0.1-dev
  GitCommit:        
 docker-init:
  Version:          0.18.0
  GitCommit:        
```

#### Test Docker installation

The first steps of the installation script install docker on your machine: your can check it by running the simple Docker image, hello-world:

```
tuto@laptop:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete 
Digest: sha256:6a65f928fb91fcfbc963f7aa6d57c8eeb426ad9a20c7ee045538ef34847f44f1
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

You canlList the hello-world image that was downloaded to your machine:

```
tuto@laptop:~$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              bf756fb1ae65        5 months ago        13.3kB
```

List the hello-world container (spawned by the image) which exits after displaying its message. If it were still running, you would not need the `--all` option:

```
tuto@laptop:~$ docker container ls --all
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
a9a177a596fd        hello-world         "/hello"            2 minutes ago       Exited (0) 2 minutes ago                       happy_kalam
```

### Conclusion


Containerization makes CI/CD seamless. For example:

* applications have no system dependencies
* updates can be pushed to any part of a distributed application
* resource density can be optimized

With Docker, scaling your application is a matter of spinning up new executables, not running heavy VM hosts.

### Part 1 cheat sheet

| docker commands | Effects |
| --- | ---:|
| `docker` | List Docker CLI commands |
| `docker container --help` | List Docker CLI commands |
| `docker --version` | Display Docker version and info |
| `docker version` | Display Docker version and info |
| `docker info` | Display Docker version and info |
| `docker run hello-world` | Execute Docker image |
| `docker image ls` | List Docker images |
| `docker container ls` | List running Docker containers |
| `docker container ls --all` | List all Docker containers |
| `docker container ls -aq` | List all Docker containers in quiet mode |


***


## Part 2 - Containers


It’s time to begin building an app the Docker way. We start at the bottom of the hierarchy of such an app, which is a **container**, which we cover on this page. Above this level is a **service**, which defines how containers behave in production, covered in Part 3. Finally, at the top level is the **stack**, defining the interactions of all the services, covered in Part 5.

|     |     |
|:---:|:---:|
| stack | Part 4 |
| service | Part 3 |
| container | Part 2 *(you are here)* |

In the past, if you were to start writing a Python app, your first order of business was to install a Python runtime onto your machine. But, that creates a situation where the environment on your machine needs to be perfect for your app to run as expected, and also needs to match your production environment.

With Docker, you can just grab a portable Python runtime as an image, no installation necessary. Then, your build can include the base Python image right alongside your app code, ensuring that your app, its dependencies, and the runtime, all travel together.

These portable images are defined by something called a **Dockerfile**.


### 2.1 Define a container with Dockerfile


Dockerfile defines what goes on in the environment inside your container. Access to resources like networking interfaces and disk drives is virtualized inside this environment, which is isolated from the rest of your system, so you need to map ports to the outside world, and be specific about what files you want to “copy in” to that environment. However, after doing that, you can expect that the build of your app defined in this Dockerfile behaves exactly the same wherever it runs.


#### Dockerfile

The files `docker-compose-part3.yml`, `app.py` and `requirements.txt` will be used now to build a Docker image and corresponding container. 
We see that `pip install -r requirements.txt` installs the Flask and Redis libraries for Python, and the app prints the environment variable `NAME`, as well as the output of a call to `socket.gethostname()`. Finally, because Redis isn’t running (as we’ve only installed the Python library, and not Redis itself), we should expect that the attempt to use it here fails and produces the error message.

> Note: accessing the name of the host when inside a container retrieves the container ID, which is like the process ID for a running executable.

***That’s it!***
You don’t need Python or anything in `requirements.txt` on your system, nor does building or running this image install them on your system. It doesn’t seem like you’ve really set up an environment with Python and Flask, but you have.


#### Build the app

We are ready to build the app. Make sure you are still at the top level of your new directory. Here’s what `ls` should show:

```
tuto@laptop:~$ ls code
app.py                    docker-compose-part5-1.yml  docker-compose.yml  requirements.txt
docker-compose-part3.yml  docker-compose-part5-2.yml  Dockerfile
```
Now run the build command. This creates a Docker image, which we’re going to tag using:
- `-t` = name the image (a friendly name)
- `.`  = path to the Dockerfile

You will see that Docker will take few seconds to execute the command as it needs to download various elements in order to build the image. The image building process actually shows many more lines but we skipped most of them (represented by [...]) :  

```
tuto@laptop:~$ docker build -t friendlyhello ./code
Sending build context to Docker daemon  9.728kB
Step 1/7 : FROM python:3.6
3.6: Pulling from library/python
376057ac6fa1: Pull complete 
[...]
Removing intermediate container 22f48e5a16cc
 ---> c54174fc2d78
Successfully built c54174fc2d78
Successfully tagged friendlyhello:latest
```

Where is your built image? It’s in your machine’s local Docker image registry:

```
tuto@laptop:~$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
friendlyhello       latest              c54174fc2d78        5 minutes ago       924MB
python              3.6                 2dfb6d103623        2 weeks ago         914MB
hello-world         latest              bf756fb1ae65        5 months ago        13.3kB
```
You can see the `hello-world` image which we used to test that Docker was properly installed, the `friendlyhello` image which you just built  - *your first Docker image ever !!!* - and a third image called `python`, which you did not ask for, but which Docker used as the base image on top of which `friendlyhello` was built.

#### Run the app

You will now run the app, mapping your machine’s port 4000 to the container’s published port 80 using -p:

```
tuto@laptop:~$ docker run -p 4000:80 friendlyhello
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)

```

You should see such a message that Python is serving your app at [http://0.0.0.0:80](http://0.0.0.0:80). This message is coming from *inside* the container, which doesn’t know that you mapped port 80 of that container to port 4000 on your laptop, making the correct URL [http://localhost:4000](http://localhost:4000).
Go to that second URL in a web browser to see the display content served up on a web page. It should look like this:

![alt text](./images/part2-friendlyhello.png "friendlyhello displayed in a browser")

You can also use the `curl` command in a shell to view the same content... in text format:

```
tuto@laptop:~$ curl http://localhost:4000
<h3>Hello World!</h3><b>Hostname:</b> 8fc990912a14<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
```
This port remapping of 4000:80 demonstrates the difference between EXPOSE within the Dockerfile and what the publish value is set to when running `docker run -p`. In later steps, map port 4000 on the host to port 80 in the container and use [http://localhost](http://localhost).

Hit `CTRL+C` in your terminal to quit.

Now let’s run the app in the background, in detached mode:

```
tuto@laptop:~$ docker run -d -p 4000:80 friendlyhello
959d6fbadbbd58032af60022cf0e02f6f49475600a46fc4628dd736a12640c4f
```
You get the `long container ID` for your app and then are kicked back to your terminal. Your container is running in the background. You can also see the `abbreviated container ID` with `docker container ls` (and both work interchangeably when running commands):
```
tuto@laptop:~$ docker container ls
CONTAINER ID IMAGE         COMMAND         CREATED
959d6fbadbbd friendlyhello "python app.py" 28 seconds ago
```
Notice that `CONTAINER ID` matches what is displayed on [http://localhost:4000](http://localhost:4000).

Now, you will use `docker container stop` to end the process, using the `CONTAINER ID` to tell which container should be stopped. Docker will need few seconds to actually stop the container, and it will output the container ID once it is done:
```
tuto@laptop:~$ docker container stop 959d6fbadbbd
959d6fbadbbd
```
In parallel, you can refresh the web page on [http://localhost:4000](http://localhost:4000) until the container stops, and the browser will then not be able to connect anymore:

![alt text](./images/part2-friendlyhello-not-responding.png "friendlyhello not reachable in a browser")


#### Share your image

To demonstrate the portability of what we just created, let’s upload our built image and run it somewhere else. After all, you need to know how to push to *registries* when you want to deploy containers to production.
A **registry** is a collection of repositories, and a **repository** is a collection of images—sort of like a GitHub repository, except the code is already built.
An account on a registry can create many repositories. The docker CLI uses Docker’s public registry by default.

> Note: We use Docker’s public registry here just because it’s free and pre-configured, but there are many public ones to choose from, and you can even set up your own private registry using Docker Trusted Registry.

##### Log in with your Docker ID

If you don’t have a Docker account, sign up for one at [https://hub.docker.com](https://hub.docker.com). Make note of your username: we assume from now on that your login is *account*.

Log in to the Docker public registry on your local machine.
```
tuto@laptop:~$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to [https://hub.docker.com](https://hub.docker.com) to create one.
Username: account
Password:
WARNING! Your password will be stored unencrypted in /home/tso/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
Login Succeeded
```

##### Tag the image

The notation for associating a local image with a repository on a registry is `username/repository:tag`. The `tag` is optional, but recommended, since it is the mechanism that registries use to give Docker images a *version*. Give the repository and tag meaningful names for the context, such as `get-started:part2`. This puts the image in the `get-started` repository and tags it as `part2`.

Now, put it all together to tag the image. Run `docker tag image` with your username, repository, and tag names so that the image uploads to your desired destination. The syntax of the command is `docker tag image username/repository:tag`.

For example:
```
tuto@laptop:~$ docker tag friendlyhello account/get-started:part2
```
You may run `docker image ls` command to see your newly tagged image.


#####  Publish the image

Now, let's put it all together to tag the image. Run `docker tag image` with your username, repository, and tag names so that the image uploads to your desired destination:
```
tuto@laptop:~$ docker image ls
REPOSITORY           TAG      IMAGE ID     CREATED       SIZE
friendlyhello        latest   d9e555c53008 3 minutes ago 195MB
account/get-started part2    d9e555c53008 3 minutes ago 195MB
python               2.7-slim 1c7128a655f6 5 days ago    183MB
```
The command to actually upload your tagged image to the repository is `docker push username/repository:tag`, so let's run it now:
```
tuto@laptop:~$ docker push account/get-started:part2
```
Once complete, the results of this upload are publicly available. If you log in to Docker Hub, you see the new image there, with its pull command.

#####  Pull and run the image from the remote repository

From now on, you can use docker run and run your app on any machine with this command `docker run -p 4000:80 username/repository:tag`.

So in our case `docker run -p 4000:80 account/get-started:part2`. If the image isn’t available locally on the machine, Docker pulls it from the repository:

```
tuto@laptop:~$ docker run -p 4000:80 account/get-started:part2
Unable to find image 'account/get-started:part2' locally
part2: Pulling from account/get-started
10a267c67f42: Already exists
f68a39a6a5e4: Already exists
9beaffc0cf19: Already exists
3c1fe835fb6b: Already exists
4c9f1fa8fcb8: Already exists
ee7d8f576a14: Already exists
fbccdcced46e: Already exists
Digest: sha256:0601c866aab2adcc6498200efd0f754037e909e5fd42069adeff72d1e2439068
Status: Downloaded newer image for account/get-started:part2
 * Running on [http://0.0.0.0:80/](http://0.0.0.0:80/) (Press CTRL+C to quit)
```
No matter where docker run executes, it pulls your image, along with Python and all the dependencies from requirements.txt, and runs your code. It all travels together in a neat little package, and you don’t need to install anything on the host machine for Docker to run it.


###  Conclusion of Part 2

That’s all for this page. In the next section, we learn how to scale our application by running this container in a service.

### Part 2 Cheat Sheet

|  |  |
| --- | ---:|
| `docker build -t friendlyhello .` | Create image using this directory's Dockerfile |
| `docker run -p 4000:80 friendlyhello` | Run "friendlyname" mapping port 4000 to 80 |
| `docker run -d -p 4000:80 friendlyhello` | Same thing, but in detached mode |
| `docker container ls` | List all running containers |
| `docker container ls -a` | List all containers, even those not running |
| `docker container stop <hash>` | Gracefully stop the specified container |
| `docker container kill <hash>` | Force shutdown of the specified container |
| `docker container rm <hash>` | Remove specified container from this machine |
| `docker container rm $(docker container ls -a -q)` | Remove all containers |
| `docker image ls -a` | List all images on this machine |
| `docker image rm <image id>` | Remove specified image from this machine |
| `docker image rm $(docker image ls -a -q)` | Remove all images from this machine |
| `docker login` | Log in this CLI session using your Docker credentials |
| `docker tag <image> username/repository:tag` | Tag <image> for upload to registry |
| `docker push username/repository:tag` | Upload tagged image to registry |
| `docker run username/repository:tag` | Run image from a registry |



## Docker get started - Part 3 - Services

### 3.1 - Your first docker-compose.yml file

A `docker-compose.yml` file is a YAML file that defines how Docker containers should behave in production. Here, we will use the `docker-compose-part3.yml` file which tells Docker to do the following:

* pull the image we uploaded in step 2 from the registry.
* run 5 instances of that image as a service called web, limiting each one to use, at most, 10% of the CPU (across all cores), and 50MB of RAM.
* immediately restart containers if one fails.
* map port 4000 on the host to web’s port 80.
* instruct web’s containers to share port 80 via a load-balanced network called webnet. (Internally, the containers themselves publish to web’s port 80 at an ephemeral port.)
* define the webnet network with the default settings (which is a load-balanced overlay network).

### 3.2 - Run your new load-balanced app

Before we can use the docker stack deploy command we first run:
```
tuto@laptop:~$ docker swarm init
```
> Note: We get into the meaning of that command in part 4. If you don’t run docker swarm init you get an error that “this node is not a swarm manager.”

Now let’s run it. You need to give your app a name. Here, it is set to `getstartedlab`:
```
tuto@laptop:~$ docker stack deploy -c code/docker-compose-part3.yml getstartedlab
Creating network getstartedlab_webnet
Creating service getstartedlab_web
```
Our single service stack is running 5 container instances of our deployed image on one host. Let’s investigate.
Get the `service ID` for the one service in our application:
```
tuto@laptop:~$ docker service ls
ID             NAME                MODE         REPLICAS    IMAGE                         PORTS
xoagyod5294j   getstartedlab_web   replicated   5/5         account/get-started:part2   *:4000->80/tcp
```
Look for output for the web service, prepended with your app name. If you named it the same as shown in this example, the name is getstartedlab_web. The `service ID` is listed as well, along with the number of replicas, image name, and exposed ports.

A single container running in a service is called a task. Tasks are given unique IDs that numerically increment, up to the number of replicas you defined in docker-compose.yml. List the tasks for your service:
```
tuto@laptop:~$ docker service ps getstartedlab_web
ID              NAME                   IMAGE                         NODE      DESIRED STATE    ID                  NAME                  IMAGE                       NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
r8z7k5gw4mdg        getstartedlab_web.1   account/get-started:part2   laptop              Running             Running 2 minutes ago                       
mruh44c14hii        getstartedlab_web.2   account/get-started:part2   laptop              Running             Running 2 minutes ago                       
rketr3b5523p        getstartedlab_web.3   account/get-started:part2   laptop              Running             Running 2 minutes ago                       
sgw7n6mo152h        getstartedlab_web.4   account/get-started:part2   laptop              Running             Running 2 minutes ago                       
n984sajq0gu7        getstartedlab_web.5   account/get-started:part2   laptop              Running             Running 2 minutes ago
```
Tasks also show up if you just list all the containers on your system, though that is not filtered by service:
```
tuto@laptop:~$ docker container ls -a
df119c85f902        account/get-started:part2   "python app.py"     3 minutes ago       Up 2 minutes                  80/tcp                 getstartedlab_web.4.sgw7n6mo152hdoskfyu7f0xu3
3717956b14e9        account/get-started:part2   "python app.py"     3 minutes ago       Up 2 minutes                  80/tcp                 getstartedlab_web.1.r8z7k5gw4mdggf2hhlj58c53s
d04e320efdb3        account/get-started:part2   "python app.py"     3 minutes ago       Up 2 minutes                  80/tcp                 getstartedlab_web.5.n984sajq0gu7koc9szbllgs3p
4c3229476930        account/get-started:part2   "python app.py"     3 minutes ago       Up 2 minutes                  80/tcp                 getstartedlab_web.3.rketr3b5523p9zan30mvxe8q9
14e380d75bf0        account/get-started:part2   "python app.py"     3 minutes ago       Up 2 minutes                  80/tcp                 getstartedlab_web.2.mruh44c14hiiwpgdilasj7hfp
29568f266344        account/get-started:part2   "python app.py"     7 minutes ago       Up 7 minutes                  0.0.0.0:4000->80/tcp   flamboyant_goldwasser
```

### 3.3 - Service stack resilience

The service stack is instructed from the docker-compose file to keep at any moment 5 containers active. This is true even if a container would stop (for any reason: a bug in the app, a problem on the system etc etc). Let's see the sequence of events:

* list the containers (showing 5 active containers)
* stop one container (identifying this container from its ID)
* list again the containers (showing only 4 active containers)
* list again the containers after few seconds (showing again 5 active containers)

```
tuto@laptop:~$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                       PORTS
xoagyod5294j        getstartedlab_web   replicated          5/5                 account/get-started:part2   *:4000->80/tcp

```
We see in the containers list above that the container `3717956b14e9` is running one of the five instance: we will kill it, and observe how the swarm reacts.
```
tuto@laptop:~$ docker container stop 3717956b14e9
```
Now list again the service, and you will notice that the service is running only on 4 containers (as indicated on the `REPLICAS` column, showing 4/5).
```
tuto@laptop:~$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                       PORTS
xoagyod5294j        getstartedlab_web   replicated          4/5                 account/get-started:part2   *:4000->80/tcp

tuto@laptop:~$ docker container ls
CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS                  NAMES
df119c85f902        account/get-started:part2   "python app.py"     7 minutes ago       Up 7 minutes        80/tcp                 getstartedlab_web.4.sgw7n6mo152hdoskfyu7f0xu3
d04e320efdb3        account/get-started:part2   "python app.py"     7 minutes ago       Up 7 minutes        80/tcp                 getstartedlab_web.5.n984sajq0gu7koc9szbllgs3p
4c3229476930        account/get-started:part2   "python app.py"     7 minutes ago       Up 7 minutes        80/tcp                 getstartedlab_web.3.rketr3b5523p9zan30mvxe8q9
14e380d75bf0        account/get-started:part2   "python app.py"     8 minutes ago       Up 7 minutes        80/tcp                 getstartedlab_web.2.mruh44c14hiiwpgdilasj7hfp
```
As you can see, there are still only 4 instance left running, while we asked for 5. Wait few seconds and list the service and containers again: as you can see, docker restarted a new container (`ID 23b1b1a90fe6`) to meet again the target of 5 concurrent containers for the service stack. The `REPLICAS` column now indicate 5/5 again:
```
tuto@laptop:~$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                       PORTS
xoagyod5294j        getstartedlab_web   replicated          5/5                 account/get-started:part2   *:4000->80/tcp

tuto@laptop:~$ docker container ls
CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS                  NAMES
b12b6b1d6cc4        account/get-started:part2   "python app.py"     20 seconds ago      Up 8 seconds        80/tcp                 getstartedlab_web.1.iwzq5zzy1pp2lqtn233b1qsg6
df119c85f902        account/get-started:part2   "python app.py"     8 minutes ago       Up 8 minutes        80/tcp                 getstartedlab_web.4.sgw7n6mo152hdoskfyu7f0xu3
d04e320efdb3        account/get-started:part2   "python app.py"     8 minutes ago       Up 8 minutes        80/tcp                 getstartedlab_web.5.n984sajq0gu7koc9szbllgs3p
4c3229476930        account/get-started:part2   "python app.py"     8 minutes ago       Up 8 minutes        80/tcp                 getstartedlab_web.3.rketr3b5523p9zan30mvxe8q9
14e380d75bf0        account/get-started:part2   "python app.py"     8 minutes ago       Up 8 minutes        80/tcp                 getstartedlab_web.2.mruh44c14hiiwpgdilasj7hfp
```


### 3.4 - Scale the app

You can scale the app by changing the replicas value (e.g. from 5 to 8) in the YAML file `docker-compose-part3.yml`, saving the change, and re-running the `docker stack deploy` command:
```
tuto@laptop:~$ docker stack deploy -c code/docker-compose-part3.yml getstartedlab
```
Docker performs an in-place update, no need to tear the stack down first or kill any containers. Now, re-run `docker container ls -q` to see the deployed instances reconfigured. If you scaled up the replicas, more tasks, and hence, more containers, are started.
```
tuto@laptop:~$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                       PORTS
xoagyod5294j        getstartedlab_web   replicated          8/8                 account/get-started:part2   *:4000->80/tcp

tuto@laptop:~$ docker container ls
CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS                  NAMES
29eaeb676554        account/get-started:part2   "python app.py"     11 seconds ago      Up 3 seconds        80/tcp                 getstartedlab_web.6.rmdk53alns3l56q9dzcwwe8a7
e2643e1f9374        account/get-started:part2   "python app.py"     11 seconds ago      Up 4 seconds        80/tcp                 getstartedlab_web.7.w79tecr01nxnz7xgb6w2xch61
076bda02c8ac        account/get-started:part2   "python app.py"     11 seconds ago      Up 3 seconds        80/tcp                 getstartedlab_web.8.038y0t3sv10fw5bhpp6272n03
b12b6b1d6cc4        account/get-started:part2   "python app.py"     2 minutes ago       Up 2 minutes        80/tcp                 getstartedlab_web.1.iwzq5zzy1pp2lqtn233b1qsg6
df119c85f902        account/get-started:part2   "python app.py"     10 minutes ago      Up 10 minutes       80/tcp                 getstartedlab_web.4.sgw7n6mo152hdoskfyu7f0xu3
d04e320efdb3        account/get-started:part2   "python app.py"     10 minutes ago      Up 10 minutes       80/tcp                 getstartedlab_web.5.n984sajq0gu7koc9szbllgs3p
4c3229476930        account/get-started:part2   "python app.py"     10 minutes ago      Up 10 minutes       80/tcp                 getstartedlab_web.3.rketr3b5523p9zan30mvxe8q9
14e380d75bf0        account/get-started:part2   "python app.py"     10 minutes ago      Up 10 minutes       80/tcp                 getstartedlab_web.2.mruh44c14hiiwpgdilasj7hfp
```

### 3.5 - Take the app down

The instruction to take the service stack down is `docker stack rm` followed with the name of the service:
```
tuto@laptop:~$ docker stack rm getstartedlab
Removing service getstartedlab_web
Removing network getstartedlab_webnet
```

### 3.6 - Take the swarm down

The instruction to take the service stack down is `docker swarm leave` with the option `--force` to take it down even if there could connections active.
```
tuto@laptop:~$ docker swarm leave --force
Node left the swarm.
```

### Conclusion of Part 3

It’s as easy as that to stand up and scale your app with Docker. You’ve taken a huge step towards learning how to run containers in production. Up next, you learn how to run this app as a bonafide swarm on a cluster of Docker machines.
> Note: Compose files like this are used to define applications with Docker, and can be uploaded to cloud providers using Docker Cloud, or on any hardware or cloud provider you choose with Docker Enterprise Edition.

### Cheat Sheet for Part 3:

|  |  |
| --- | ---:|
| `docker stack ls` | List stacks or apps |
| `docker stack deploy -c <composefile> <appname>` | Run the specified Compose file |
| `docker service ls` | List running services associated with an app |
| `docker service ps <service>` | List tasks associated with an app |
| `docker inspect <task or container>` | Inspect task or container |
| `docker container ls -q` | List container IDs |
| `docker stack rm <appname>` | Tear down an application |
| `docker swarm leave --force` | Take down a single node swarm from the manager |



## Part 4 - Swarms

In part 3, you took an app you wrote in part 2, and defined how it should run in production by turning it into a service, scaling it up 5x in the process. Here in part 4, you deploy this application onto a cluster, running it on multiple machines. Multi-container, multi-machine applications are made possible by joining multiple machines into a “Dockerized” cluster called a swarm.

A swarm is a group of machines that are running Docker and joined into a cluster. After that has happened, you continue to run the Docker commands you’re used to, but now they are executed on a cluster by a swarm manager. The machines in a swarm can be physical or virtual. After joining a swarm, they are referred to as nodes.

Swarm managers can use several strategies to run containers, such as “emptiest node” -- which fills the least utilized machines with containers. Or “global”, which ensures that each machine gets exactly one instance of the specified container. You instruct the swarm manager to use these strategies in the `Compose` file, just like the one you have already been using.

Swarm managers are the only machines in a swarm that can execute your commands, or authorize other machines to join the swarm as workers. Workers are just there to provide capacity and do not have the authority to tell any other machine what it can and cannot do.

Up until now, you have been using Docker in a single-host mode on your local machine. But Docker also can be switched into swarm mode, and that’s what enables the use of swarms. Enabling swarm mode instantly makes the current machine a swarm manager. From then on, Docker runs the commands you execute on the swarm you’re managing, rather than just on the current machine.

### 4.1 - Set up your swarm

A swarm is made up of multiple nodes, which can be either physical or virtual machines. The basic concept is simple enough: run `docker swarm init` to enable swarm mode and make your current machine a swarm manager, then run `docker swarm join` on other machines to have them join the swarm as workers.

In this tutorial, we use VMs to quickly create a three-machine cluster and turn it into a swarm.

#### Create a cluster

You need a hypervisor that can create virtual machines (VMs), so install Oracle VirtualBox for your machine’s OS.

Now, let's create three VMs using docker-machine with the VirtualBox driver:
```
tuto@laptop:~$ docker-machine create --driver virtualbox myvm1
Running pre-create checks...
(myvm1) Default Boot2Docker ISO is out-of-date, downloading the latest release...
(myvm1) Latest release for github.com/boot2docker/boot2docker is v18.06.1-ce
(myvm1) Downloading /home/thierry/.docker/machine/cache/boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v18.06.1-ce/boot2docker.iso...
(myvm1) 0%....10%....20%....30%....40%....50%....60%....70%....80%....90%....100%
Creating machine...
(myvm1) Copying /home/thierry/.docker/machine/cache/boot2docker.iso to /home/thierry/.docker/machine/machines/myvm1/boot2docker.iso...
(myvm1) Creating VirtualBox VM...
(myvm1) Creating SSH key...
(myvm1) Starting the VM...
(myvm1) Check network to re-create if needed...
(myvm1) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with boot2docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env myvm1
```
Now, do the same for the two additional VMs:
```
tuto@laptop:~$ docker-machine create --driver virtualbox myvm2
tuto@laptop:~$ docker-machine create --driver virtualbox myvm3
```
You now have three VMs created, named `myvm1`, `myvm2` and `myvm3`.

Use the `docker-machine ls` command to list the machines and get their IP addresses.
```
tuto@laptop:~$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER     ERRORS
myvm1   -        virtualbox   Running   tcp://192.168.99.100:2376           v19.03.5   
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v19.03.5   
myvm3   -        virtualbox   Running   tcp://192.168.99.102:2376           v19.03.5
```

#### Initialize the swarm

The first machine acts as the manager, which executes management commands and authenticates workers to join the swarm, and the second and third are workers. You can send commands to your VMs using `docker-machine ssh`. Instruct `myvm1` to become a swarm manager with `docker swarm init` and look for output like `docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>"`.

More elegantly, we will actually spawn a new terminal tab for each VM, use `docker-machine` to connect (via SSH) into the VM, and - from within each VM - either initialize the swarm (for `myvm1`) or join the swarm (`myvm2` and `myvm3`):
```
tuto@laptop:~$ gnome-terminal --tab --tab --tab
```
In the second tab, we will log into VM1 and initialize the swam:
```
tuto@laptop:~$ docker-machine ssh myvm1
docker@myvm1:~$ docker swarm init --advertise-addr 192.168.99.100
Swarm initialized: current node (jo9p4yihnnvu2wu4r1vx09gmc) is now a manager.

To add a worker to this swarm, run the following command:
    docker swarm join --token SWMTKN-1-45tzwsnjei5f5c3k9l9i8y7zbxje750f5accagd82oqriq8z8s-abtnq3asuu168095qf326i5n8 192.168.99.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```
We keep preciously these connection instruction: the other nodes will not be able to join the swarm if they don't know the token.

#### Add nodes to the swarm

So, we continue logging into the next VM and joining it to the swarm. To do so, we use the docker command `docker swarm join --token <token> <myvm ip>:<port>` and we will use the token which is included in the response to docker swarm init (above).

copy this command, and run it from `myvm2` and `myvm3` via `docker swarm join --token <token> <ip>:2377`

In this case:
```
tuto@laptop:~$ docker-machine ssh myvm2
docker@myvm2:~$ docker swarm join --token SWMTKN-1-45tzwsnjei5f5c3k9l9i8y7zbxje750f5accagd82oqriq8z8s-abtnq3asuu168095qf326i5n8 192.168.99.100:2377
This node joined a swarm as a worker.
```
and:
```
tuto@laptop:~$ docker-machine ssh myvm3
docker@myvm3:~$ docker swarm join --token SWMTKN-1-45tzwsnjei5f5c3k9l9i8y7zbxje750f5accagd82oqriq8z8s-abtnq3asuu168095qf326i5n8 192.168.99.100:2377
This node joined a swarm as a worker.
```
***Congratulations***, you have now created your first swarm on a cluster of 3 VMs!

Run `docker node ls` on the manager to view the nodes in this swarm:
```
docker@myvm1:~$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
jo9p4yihnnvu2wu4r1vx09gmc *   myvm1               Ready               Active              Leader              19.03.5
fkfmmeirve311smrdd1s2dld4     myvm2               Ready               Active                                  19.03.5
0lajp4xuakprqorap8ezgdu3s     myvm3               Ready               Active                                  19.03.5
```
As you can see, all three VMs appear in the list, and `myvm1` is indicated as the 'leader' of the swarm.

#### Leaving a swarm

If you want to start over, you can run `docker swarm leave` from each node. However, we can continue using the swarm '*as is*' for some more time. 


### 4.2 - Deploy your app on the swarm cluster

The hard part is over. Now you just repeat the process you used in Part 3 to deploy on your new swarm. Just remember that only swarm managers like `myvm1` execute Docker commands; workers are just for capacity.

#### Configure a docker-machine shell to the swarm manager

So far, you’ve been wrapping Docker commands in docker-machine ssh to talk to the VMs, or you logged directly into the VM (via SSH) in order to place orders.

Another option is to run `docker-machine env <machine>` to get and run a command that configures your current shell to talk to the Docker daemon on the VM. This method works better for the next step because it allows you to use your local copy of the `docker-compose.yml` file (on your laptop) to deploy the app “*remotely*” without having to copy it inside the VM1.

```
tuto@laptop:~$ docker-machine env myvm1
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/home/tso/.docker/machine/machines/myvm1"
export DOCKER_MACHINE_NAME="myvm1"
# Run this command to configure your shell:
# eval $(docker-machine env myvm1)
```
So, we just have to follow the instructions above:
```
tuto@laptop:~$ eval $(docker-machine env myvm1)
```
Run `docker-machine ls` to verify that `myvm1` is now the active machine, as indicated by the asterisk next to it:
```
tuto@laptop:~$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
myvm1   *        virtualbox   Running   tcp://192.168.99.100:2376           v19.03.5   
myvm2   -        virtualbox   Running   tcp://192.168.99.101:2376           v19.03.5   
myvm3   -        virtualbox   Running   tcp://192.168.99.102:2376           v19.03.5   
```

#### Deploy the app on the swarm manager

Now that you have `myvm1`, you can use its powers as a swarm manager to deploy your app by using the same `docker stack deploy` command you used in part 3 to `myvm1`, and your local copy of `docker-compose.yml`. This command may take a few seconds to complete and the deployment takes some time to be available. Use the `docker service ps <service_name>` command on a swarm manager to verify that all services have been redeployed.

You are connected to `myvm1` by means of the docker-machine shell configuration, and you still have access to the files on your local host. Make sure you are in the same directory as before, which includes the `docker-compose.yml` file you created in part 3.

Just like before, run the following command to deploy the app on `myvm1`:

```
tuto@laptop:~$ docker stack deploy -c code/docker-compose-part3.yml getstartedlab
Creating network getstartedlab_webnet
Creating service getstartedlab_web
```
And that’s it, the app is deployed on a swarm cluster!

> Note: If your image is stored on a private registry instead of Docker Hub, you need to be logged in using docker login <your-registry> and then you need to add the --with-registry-auth flag to the above Command. For example:
> ```$ docker login registry.example.com```
> ```$ docker stack deploy --with-registry-auth -c docker-compose-part3.yml getstartedlab```
>This passes the login token from your local client to the swarm nodes where the service is deployed, using the encrypted WAL logs. With this information, the nodes are able to log into the registry and pull the image.

Now you can use the same docker commands you used in part 3. Only this time Notice that the services (and associated containers) have been distributed between both myvm1 and myvm2.
```
tuto@laptop:~$ docker stack ps getstartedlab
ID                  NAME                  IMAGE                       NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
xr369odnin3x        getstartedlab_web.1   tsouche/get-started:part2   myvm2               Running             Running about a minute ago                       
i0cy5sv9y4l0        getstartedlab_web.2   tsouche/get-started:part2   myvm3               Running             Running about a minute ago                       
sqnb23j0n6xr        getstartedlab_web.3   tsouche/get-started:part2   myvm2               Running             Running about a minute ago                       
hnt4hndfqxd2        getstartedlab_web.4   tsouche/get-started:part2   myvm3               Running             Running about a minute ago                       
l41yrxn5vavl        getstartedlab_web.5   tsouche/get-started:part2   myvm1               Running             Running about a minute ago                       
wkzok2n1kjb1        getstartedlab_web.6   tsouche/get-started:part2   myvm1               Running             Running about a minute ago                            
g3igrtiezmhe        getstartedlab_web.7   tsouche/get-started:part2   myvm1               Running             Running about a minute ago                            
r8xs2ytlwtvz        getstartedlab_web.8   tsouche/get-started:part2   myvm3               Running             Running about a minute ago  
```
#### Connecting to VMs with docker-machine env and docker-machine ssh

To set your shell to talk to a different machine like myvm2, simply re-run docker-machine env in the same or a different shell, then run the given command to point to myvm2. This is always specific to the current shell. If you change to an unconfigured shell or open a new one, you need to re-run the commands. Use docker-machine ls to list machines, see what state they are in, get IP addresses, and find out which one, if any, you are connected to. To learn more, see the Docker Machine getting started topics.

Alternatively, you can wrap Docker commands in the form of `docker-machine ssh <machine> "<command>"`, which logs directly into the VM but doesn’t give you immediate access to files on your local host.

You can use `docker-machine` to *secure copy* (scp) files across machines:
```
tuto@laptop:~$ docker-machine scp <file> <machine>:~
```

#### Accessing your cluster

You can access your app from the IP address of either VM. Typically, you can enter [http://192.168.99.100:4000/](http://192.168.99.100:4000/) or [http://192.168.99.101:4000/](http://192.168.99.101:4000/) or [http://192.168.99.102:4000/](http://192.168.99.102:4000/) in the browser and see the *same* app running.

The network you created is shared between them and load-balancing. Run `docker-machine ls` to get your VMs’ IP addresses and visit either of them on a browser, hitting refresh. In order to show the result, we use `curl`:
```
tuto@laptop:~$ curl http://192.168.99.100:4000
<h3>Hello World!</h3><b>Hostname:</b> 160f2964ebb1<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
tuto@laptop:~$ curl http://192.168.99.100:4000
<h3>Hello World!</h3><b>Hostname:</b> d0da3840a388<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
tuto@laptop:~$ curl http://192.168.99.100:4000
<h3>Hello World!</h3><b>Hostname:</b> a2e30e45b9c4<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
tuto@laptop:~$ curl http://192.168.99.100:4000
<h3>Hello World!</h3><b>Hostname:</b> a10839a1e4a8<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
tuto@laptop:~$ curl http://192.168.99.100:4000
<h3>Hello World!</h3><b>Hostname:</b> c49b406440d2<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
tuto@laptop:~$ curl http://192.168.99.100:4000
<h3>Hello World!</h3><b>Hostname:</b> 05994270e546<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
tuto@laptop:~$ curl http://192.168.99.100:4000
<h3>Hello World!</h3><b>Hostname:</b> 1cd9df25ec42<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
...
```
There are eight possible container IDs all cycling by randomly, demonstrating the load-balancing.
The reason all 3 IP addresses work is that nodes in a swarm participate in an ingress routing mesh. This ensures that a service deployed at a certain port within your swarm always has that port reserved to itself, no matter what node is actually running the container.

#### Having connectivity trouble?

Keep in mind that to use the ingress network in the swarm, you need to have the following ports open between the swarm nodes before you enable swarm mode:

* Port 7946 TCP/UDP for container network discovery.
* Port 4789 UDP for the container ingress network.

### 4.3 - Iterating and scaling your app

From here you can do everything you learned about in parts 2 and 3:

* Scale the app by changing the docker-compose.yml file.
* Change the app behavior by editing code, then rebuild, and push the new image. (To do this, follow the same steps you took earlier to build the app and publish the image).

In either case, simply run docker stack deploy again to deploy these changes.

You can join any machine, physical or virtual, to this swarm, using the same docker swarm join command you used on myvm2, and capacity is added to your cluster. Just run docker stack deploy afterwards, and your app can take advantage of the new resources.

### 4.4 - Cleanup and reboot Stacks and swarms

You can tear down the stack with docker stack rm. For example:
```
tuto@laptop:~$ docker stack rm getstartedlab
Removing service getstartedlab_web
Removing network getstartedlab_webnet
```
Keep the swarm or remove it?
At some point later, you can remove this swarm if you want to with `docker-machine ssh myvm2 "docker swarm leave"` on the workers and `docker-machine ssh myvm1 "docker swarm leave --force"` on the manager, but you will still need this swarm for part 5, so keep it around for now.

#### Unsetting `docker-machine` shell variable settings
You can unset the `docker-machine` environment variables in your current shell with the given command:
```
tuto@laptop:~$ eval $(docker-machine env -u)
```
This disconnects the shell from docker-machine created virtual machines, and allows you to continue working in the same shell, now using native docker commands. 

#### Restarting Docker machines
If you shut down your local host, Docker machines stops running. You can check the status of machines by running `docker-machine ls`.
```
tuto@laptop:~$ docker-machine ls
NAME    ACTIVE   DRIVER       STATE     URL   SWARM   DOCKER    ERRORS
myvm1   -        virtualbox   Stopped                 Unknown
myvm2   -        virtualbox   Stopped                 Unknown
myvm3   -        virtualbox   Stopped                 Unknown
```
To restart a machine that’s stopped, run `docker-machine start <machine-name>`. For example:
```
tuto@laptop:~$ docker-machine start myvm1
Starting "myvm1"...
(myvm1) Check network to re-create if needed...
(myvm1) Waiting for an IP...
Machine "myvm1" was started.
Waiting for SSH to be available...
Detecting the provisioner...
```
Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.

### Conclusion of Part 4

In part 4 you learned what a swarm is, how nodes in swarms can be managers or workers, created a swarm, and deployed an application on it. You saw that the core Docker commands didn’t change from part 3, they just had to be targeted to run on a swarm master. You also saw the power of Docker’s networking in action, which kept load-balancing requests across containers, even though they were running on different machines. Finally, you learned how to iterate and scale your app on a cluster.

### Part 4 Cheat Sheet
|   |   |
| --- | ---:|
| `docker-machine create --driver virtualbox myvm1` | Create a VM |
| `docker-machine env myvm1` | View basic information about your node |
| `docker-machine ssh myvm1 "docker node ls"` | List the nodes in your swarm |
| `docker-machine ssh myvm1 "docker node inspect <node ID>"` | Inspect a node |
| `docker-machine ssh myvm1 "docker swarm join-token -q worker"` | View join token |
| `docker-machine ssh myvm1` | Open an SSH session with the VM; type "exit" to end |
| `docker node ls` | View nodes in swarm (while logged on to manager) |
| `docker-machine ssh myvm2 "docker swarm leave"` | Make the worker leave the swarm |
| `docker-machine ssh myvm1 "docker swarm leave -f"` | Make master leave, kill swarm |
| `docker-machine ls` | list VMs, asterisk shows which VM this shell is talking to |
| `docker-machine start myvm1` | Start a VM that is currently not running |
| `docker-machine env myvm1` | show environment variables and command for myvm1 |
| `eval $(docker-machine env myvm1)` | Mac command to connect shell to myvm1 |
| `docker stack deploy -c <file> <app>` | Deploy an app; command shell must be set to talk to manager (myvm1), uses local Compose file |
| `docker-machine scp docker-compose.yml myvm1:~` | Copy file to node's home dir (only required if you use ssh to connect to manager and deploy the app) |
| `docker-machine ssh myvm1 "docker stack deploy -c <file> <app>"` | Deploy an app using ssh (you must have first copied the Compose file to myvm1) |
| `eval $(docker-machine env -u)` | Disconnect shell from VMs, use native docker |
| `docker-machine stop $(docker-machine ls -q)` | Stop all running VMs |
| `docker-machine rm $(docker-machine ls -q)` | Delete all VMs and their disk images |


***

## Docker get started - Part 5 - Stacks

In Part 4, you learned how to set up a **swarm**, which is a cluster of machines running Docker, and deployed an application to it, with containers running in concert on multiple machines.

Here in Part 5, you reach the top of the hierarchy of distributed applications: the **stack**. A stack is a group of interrelated services that share dependencies, and can be orchestrated and scaled together. A single stack is capable of defining and coordinating the functionality of an entire application (though very complex applications may want to use multiple stacks).

Some good news is, you have technically been working with stacks since Part 3, when you created a Compose file and used `docker stack deploy`. But that was a single service stack running on a single host, which is not usually what takes place in production. Here, you can take what you’ve learned, make multiple services relate to each other, and run them on multiple machines.

### 5.1 - Add a new service and redeploy

It’s easy to add services to our docker-compose.yml file. First, let’s add a free visualizer service that lets us look at how our swarm is scheduling containers.

We will use here `docker-compose-part5-1.yml`, a modified version of the previous `docker-compose-part3.yml`. The only thing new here is the peer service to web, named visualizer. Notice two new things here:

* a volumes key, giving the visualizer access to the host’s socket file for Docker, and
* a placement key, ensuring that this service only ever runs on a swarm manager -- never a worker. That’s because this container, built from an open source project created by Docker, displays Docker services running on a swarm in a diagram.

We will talk more about placement constraints and volumes in a moment.

Make sure your shell is configured to talk to `myvm1`:

* Run docker-machine ls to list machines and make sure you are connected to `myvm1`, as indicated by an asterisk next to it.
* If needed, re-run `docker-machine env myvm1`, then run the `eval $(docker-machine env myvm1)` command to configure the shell.
* Re-run the `docker stack deploy` command on the manager, and whatever services
need updating are updated:
```
$ docker stack deploy -c docker-compose-part5-1.yml getstartedlab
Creating network getstartedlab_webnet
Creating service getstartedlab_visualizer
Creating service getstartedlab_web
```

#### Take a look at the visualizer:

You saw in the Compose file that visualizer runs on 8080. Get the IP address of one of your nodes by running docker-machine ls. Go to either IP address at port 8080 and you can see the visualizer running. In our case: go to the port 8080 of `myvm1`: [http://192.168.99.100:8080/](http://192.168.99.100:8080/)

The single copy of visualizer is running on the manager as you expect, and the 8 instances of web are spread out across the swarm. You can corroborate this visualization by running `docker stack ps <stack>`:

tuto@laptop:~$ docker stack ps getstartedlab
ID NAME IMAGE NODE DESIRED STATE CURRENT STATE ERROR PORTS
kb8e3d7iqj76 getstartedlab_web.1 account/get-started:part2 myvm3 Running Running 59 seconds ago
puk3a65hf5up getstartedlab_visualizer.1 dockersamples/visualizer:stable myvm1 Running Running 50 seconds ago
zr4jjcvrr0l5 getstartedlab_web.2 account/get-started:part2 myvm1 Running Running 58 seconds ago
v6a1qd49a0ka getstartedlab_web.3 account/get-started:part2 myvm2 Running Running 59 seconds ago
x0gq7usig5y6 getstartedlab_web.4 account/get-started:part2 myvm3 Running Running 59 seconds ago
9uxjs2ve3x1s getstartedlab_web.5 account/get-started:part2 myvm1 Running Running 58 seconds ago
4r6a1dxxlh0e getstartedlab_web.6 account/get-started:part2 myvm2 Running Running 59 seconds ago
pqxvp3m14loh getstartedlab_web.7 account/get-started:part2 myvm3 Running Running 59 seconds ago
gs5ox6yvnumw getstartedlab_web.8 account/get-started:part2 myvm2 Running Running 59 seconds ago

As you can see, the previous containers were stopped and replaced with the new versions of the containers, corresponding to the new docker-compose file.

If you go to [http://192.168.99.100:8080/](http://192.168.99.100:8080/), you should see this:

***insert a picture here***



You had to take no action: the whole process is orchestrated by docker. The visualizer is a standalone service that can run in any app that includes it in the stack. It doesn’t depend on anything else. Now let’s create a service that does have a dependency: the Redis service that provides a visitor counter.

================

Persist the data

================

Let’s go through the same workflow once more to add a Redis database for

storing app data. This is defined in the docker-compose-part5-2.yml file,

which finally adds a Redis service.

Redis has an official image in the Docker library and has been granted the

short image name of just redis, so no username/repo notation here. The Redis

port, 6379, has been pre-configured by Redis to be exposed from the container

to the host, and here in our Compose file we expose it from the host to the

world, so you can actually enter the IP for any of your nodes into Redis

Desktop Manager and manage this Redis instance, if you so choose.

Most importantly, there are a couple of things in the redis specification

that make data persist between deployments of this stack:

- redis always runs on the manager, so it’s always using the same

filesystem.

- redis accesses an arbitrary directory in the host’s file system as /data

inside the container, which is where Redis stores data.

Together, this is creating a “source of truth” in your host’s physical

filesystem for the Redis data. Without this, Redis would store its data in

/data inside the container’s filesystem, which would get wiped out if that

container were ever redeployed.

This source of truth has two components:

- The placement constraint you put on the Redis service, ensuring that it

always uses the same host.

- The volume you created that lets the container access ./data (on the

host) as /data (inside the Redis container). While containers come and

go, the files stored on ./data on the specified host persists, enabling

continuity.

You are ready to deploy your new Redis-using stack.

Create a ./data directory on the manager

========================================

Note: Make sure your shell is configured to talk to myvm1:

- Run docker-machine ls to list machines and make sure you are

connected to myvm1, as indicated by an asterisk next it.

- If needed, re-run docker-machine env myvm1, then run the given

command to configure the shell.

$ eval $(docker-machine env myvm1)

Then you can create the directory on the VM:

$ docker-machine ssh myvm1 "mkdir ./data"

Run docker stack deploy one more time

=====================================

$ docker stack deploy -c docker-compose-part5-2.yml getstartedlab

Updating service getstartedlab_web (id: 2ythn4okhrdcnnj2o7ecmjbcl)

Updating service getstartedlab_visualizer (id: tufou3x0sztx69eg6kzfmzvi8)

Creating service getstartedlab_redis

Run docker service ls from the VM1 to verify that the three services are

running as expected.

docker@myvm1:~$ docker service ls

ID NAME MODE REPLICAS IMAGE PORTS

ugr2oqhctk52 getstartedlab_redis replicated 1/1 redis:latest *:6379->6379/tcp

tufou3x0sztx getstartedlab_visualizer replicated 1/1 dockersamples/visualizer:stable *:8080->8080/tcp

2ythn4okhrdc getstartedlab_web replicated 8/8 account/get-started:part2 *:80->80/tcp

docker@myvm1:~$ docker stack ps getstartedlab

ID NAME IMAGE NODE DESIRED STATE CURRENT STATE ERROR PORTS

hcvuq1nt48hp getstartedlab_redis.1 redis:latest myvm1 Running Running about a minute ago

kb8e3d7iqj76 getstartedlab_web.1 account/get-started:part2 myvm3 Running Running 5 minutes ago

puk3a65hf5up getstartedlab_visualizer.1 dockersamples/visualizer:stable myvm1 Running Running 5 minutes ago

zr4jjcvrr0l5 getstartedlab_web.2 account/get-started:part2 myvm1 Running Running 5 minutes ago

v6a1qd49a0ka getstartedlab_web.3 account/get-started:part2 myvm2 Running Running 5 minutes ago

x0gq7usig5y6 getstartedlab_web.4 account/get-started:part2 myvm3 Running Running 5 minutes ago

9uxjs2ve3x1s getstartedlab_web.5 account/get-started:part2 myvm1 Running Running 5 minutes ago

4r6a1dxxlh0e getstartedlab_web.6 account/get-started:part2 myvm2 Running Running 5 minutes ago

pqxvp3m14loh getstartedlab_web.7 account/get-started:part2 myvm3 Running Running 5 minutes ago

gs5ox6yvnumw getstartedlab_web.8 account/get-started:part2 myvm2 Running Running 5 minutes ago

Check the web page at one of your nodes, such as http://192.168.99.101, and

take a look at the results of the visitor counter, which is now live and

storing information on Redis.

Now come back to the host, and check the visualizer at port 8080 on either

node’s IP address, and notice see the redis service running along with the web

and visualizer services. We can show it here with curl:

tuto@laptop:~$ curl http://192.168.99.101

<h3>Hello World!</h3><b>Hostname:</b> 4bf84a659203<br/><b>Visits:</b> 1

tuto@laptop:~$ curl http://192.168.99.101

<h3>Hello World!</h3><b>Hostname:</b> 6e44c2030d1d<br/><b>Visits:</b> 2

tuto@laptop:~$ curl http://192.168.99.101

<h3>Hello World!</h3><b>Hostname:</b> 72e463fe35f4<br/><b>Visits:</b> 3

tuto@laptop:~$ curl http://192.168.99.101

<h3>Hello World!</h3><b>Hostname:</b> de35f3de665f<br/><b>Visits:</b> 4

tuto@laptop:~$ curl http://192.168.99.101

<h3>Hello World!</h3><b>Hostname:</b> 84fe0906e70b<br/><b>Visits:</b> 5

...

so go on the browser, visit the '192.168.99.101' URL and observe the result.

Cleanup!!!

==========

Before leaving, tidy the place!

This means bringing the services down and removing any container/images left.

tuto@laptop:~$ docker service ls

ID NAME MODE REPLICAS IMAGE PORTS

ugr2oqhctk52 getstartedlab_redis replicated 1/1 redis:latest *:6379->6379/tcp

tufou3x0sztx getstartedlab_visualizer replicated 1/1 dockersamples/visualizer:stable *:8080->8080/tcp

2ythn4okhrdc getstartedlab_web replicated 8/8 account/get-started:part2 *:80->80/tcp

tuto@laptop:~$ docker stack rm getstartedlab

Removing service getstartedlab_redis

Removing service getstartedlab_visualizer

Removing service getstartedlab_web

Removing network getstartedlab_webnet

tuto@laptop:~$ docker container ls -a

CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES

tuto@laptop:~$ docker images -a

REPOSITORY TAG IMAGE ID CREATED SIZE

account/get-started <none> c160e4abb8aa About an hour ago 159MB

redis <none> c33c9b2541a8 2 days ago 98.2MB

dockersamples/visualizer <none> 8dbf7c60cf88 2 years ago 148MB

tuto@laptop:/projects/get-started/docker$ docker image rm c160e4abb8aa c33c9b2541a8 8dbf7c60cf88

...

Here you are :-)

=======================

Conclusion of part five

=======================

You learned that stacks are inter-related services all running in concert,

and that -- surprise! -- you’ve been using stacks since part three of this

tutorial. You learned that to add more services to your stack, you insert

them in your Compose file. Finally, you learned that by using a combination

of placement constraints and volumes you can create a permanent home for

persisting data, so that your app’s data survives when the container is torn

down and redeployed.



## Appendix - installation script


zepjezapohf

## Appendix - conventions

In this tutorial, we assume that you are logged on a linux server or laptop, and we will use the following conventions:
* *user*: the examples are given with a user called `tuto`. You will need however to use your personal account on GitHub and Docker Hub. In the examples, we substituted your `login` with `account`.  
* *machine*: 
* *shell prompt*: when you are logged on your machine, we represent it with the prompt `tuto@laptop:~`. When you are logged into one of the cluster's VM (here `myvm1`), we represent it with the prompt `docker@myvm1:~`


<!--stackedit_data:
eyJoaXN0b3J5IjpbMTM5Njc0NDkxMCwtNTYwNjA0MjExLDYyMj
EyMDMzNSwtOTI5NjQwMjU1LC0xNzUxNDkyMDQ4LDE0NTkyMDg5
NjAsMTQ1OTk2NzM0NCwxOTM2NTAyNzg3LDE1NDk0MjgwODQsMT
g5NTY1ODM2MywtMTAwNjcwMjMxOCwtNDg0NTQ2MDc1LC0xOTI5
NjgwNjIwLC0xMTExNDM0NTksLTExNTk0ODk3NDMsLTEzNTc2Mz
k4MDksLTI0ODk5ODk0OSw5NDQxNTkzMDNdfQ==
-->