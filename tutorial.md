
# Docker - 'Get started' tutorial


## Intro - pre-requisites

Here are the identified pre-requisites to run this tutorial and actually learn something from this experience:

* have a linux laptop, and an account with `sudo privilege` (i.e. you have admin rights to execute some commands). Ubuntu 20.04 will be a perfect choice for beginners.
* have curl, git and virtualbox installed (see the 'Installation appendix')
* docker, docker-compose and docker-machine installed  (see the 'Installation appendix')
* a docker hub account (with login / pwd)
* have a github account (with login / pwd)

In case you need help, an installation script is shown in the appendix. The script was tested for Ubuntu 20.04. 

This is it. Everything in the list is free (except the laptop itself) and nothing else is needed... except the desire to learn :-)

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

By contrast, a virtual machine (VM) runs a full-blown “guest” operating system with virtual access to hosclear
t resources through a hypervisor. In general, VMs provide an environment with more resources than most applications need.

In this tutorial, we will start with running *containers* on your machine. In order to illustrate concepts like *stacks* or *services*, we will thenn actually generate *several VMs* on your machine, which will simulate a *cluster of servers* on top of which you will dispatch and execute (we say *'orchestrate'*) several containers.  


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
$ docker --version
Docker version 19.03.8, build afacb8b7f0
```
Run `docker info` or `docker version` (without `--`) to view even more details about your docker installation:

```
$ docker version
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
$ docker run hello-world
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
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              bf756fb1ae65        5 months ago        13.3kB
```

List the hello-world container (spawned by the image) which exits after displaying its message. If it were still running, you would not need the `--all` option:

```
$ docker container ls --all
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


*******************************************


## Part 2 - Containers


It’s time to begin building an app the Docker way. We start at the bottom of the hierarchy of such an app, which is a **container**, which we cover on this page. Above this level is a **service**, which defines how containers behave in production, covered in Part 3. Finally, at the top level is the **stack**, defining the interactions of all the services, covered in Part 5.

|     |     |
|:---:|:---:|
| stack |  |
| service |  |
| container | *(you are here)* |

In the past, if you were to start writing a Python app, your first order of business was to install a Python runtime onto your machine. But, that creates a situation where the environment on your machine needs to be perfect for your app to run as expected, and also needs to match your production environment.

With Docker, you can just grab a portable Python runtime as an image, no installation necessary. Then, your build can include the base Python image right alongside your app code, ensuring that your app, its dependencies, and the runtime, all travel together.

These portable images are defined by something called a **Dockerfile**.


### 2.1 Define a container with Dockerfile


Dockerfile defines what goes on in the environment inside your container. Access to resources like networking interfaces and disk drives is virtualized inside this environment, which is isolated from the rest of your system, so you need to map ports to the outside world, and be specific about what files you want to “copy in” to that environment. However, after doing that, you can expect that the build of your app defined in this Dockerfile behaves exactly the same wherever it runs.


#### Dockerfile

The files `docker-compose-part3.yml`, `app.py` and `requirements.txt` will be used now to build a Docker image and corresponding container. 
We see that `pip install -r requirements.txt` installs the Flask and Redis libraries for Python, and the app prints the environment variable `NAME`, as well as the output of a call to `socket.gethostname()`. Finally, because Redis isn’t running (as we’ve only installed the Python library, and not Redis itself), we should expect that the attempt to use it here fails and produces the error message.

   Note: accessing the name of the host when inside a container retrieves the container ID, which is like the process ID for a running executable.

That’s it! You don’t need Python or anything in `requirements.txt` on your system, nor does building or running this image install them on your system. It doesn’t seem like you’ve really set up an environment with Python and Flask, but you have.


#### Build the app

We are ready to build the app. Make sure you are still at the top level of your new directory. Here’s what `ls` should show:

```
$ cd code/
/code$ ls
app.py                    docker-compose-part5-1.yml  docker-compose.yml  requirements.txt
docker-compose-part3.yml  docker-compose-part5-2.yml  Dockerfile
```
Now run the build command. This creates a Docker image, which we’re going to tag using:
   `-t` = name the image (a friendly name)
   `.`  = path to the Dockerfile

You will see that Docker will take few seconds to execute the command as it needs to download various elements in order to build the image. The image building process actually shows many more lines but we skipped most of them (represented by [...]) :  

```
/code$ docker build -t friendlyhello .
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
/code$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
friendlyhello       latest              c54174fc2d78        5 minutes ago       924MB
python              3.6                 2dfb6d103623        2 weeks ago         914MB
hello-world         latest              bf756fb1ae65        5 months ago        13.3kB
```
You can see the `hello-world` image which we used to test that Docker was properly installed, the `friendlyhello` image which you just built  - *your first Docker image ever !!!* - and a third image called `python`, which you did not ask for, but which Docker used as the base image on top of which `friendlyhello` was built.


<!--stackedit_data:
eyJoaXN0b3J5IjpbMjEyMTU0ODAzMCwtMTM1NzYzOTgwOSwtMj
Q4OTk4OTQ5LDk0NDE1OTMwM119
-->