# learn-docker

This tutorial aims at guiding a beginner user to learn **Docker** by practicing, step-by-step and with details about what to do, and what results to expect, showing real examples in a terminal window. I actually ended-up writing down this tutorial because this is way *I* got to learn about Docker: since I had done the investment to get manually through all the steps as described through this tutorial, I thought it might be of interest to someone else.

The only thnig you need to run this tutorial is:

* a Linux powered machine (I typically use a laptop running on Ubuntu);
* a user account with `sudo privilege`;
* an account on *GitHub* and on *DockerHub* (free account are ok).

The various steps of the tutorial:

1. present the Docker concepts
1. play with a generic ("Heelo World!") container
1. build your own image, and spawn the corresponding container
1. publish this image to Docker Hub
1. setup a *Service*, persist data and load-balance the application
1. setup a *Swarm* of local Virtual Machines (running on your machine)
1. setup a *Stack* (a group of *Services* running on a *Swarm*) and check cluster-level resilience

... and once you have reached this point, you may be interested in getting into *real* production topics with Docker, and you will then need to pursue with much more serious tutorials, on real infrastructure.

So, if you know nothing about Docker and you want to learn about it, be my guest, run through this tutorial (and post feedbacks so that it is further improved :smile:).

