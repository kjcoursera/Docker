# Running a simple Matlab script in a Docker image

## What is Docker?
Docker is a open source tool allowing to create, deploy and run applications in an environment or a container, without the need of creating a whole virtula operating system. More information about dockercan be found in the below links

    https://opensource.com/resources/what-docker
    https://docs.docker.com/engine/docker-overview/

Lets create a simple function in matlab and see how we can run this function in a docker



## Step 1: Matlab script
In matlab create a simple function, for example, finding the square of a number 

#### To find a square of a number
        
        function output =functionSquare(input)
        output = input.^2;
        fileName  = ['./execute/dataWriteNew' num2str(input) '.mat'];
        save(fileName,'output');

#### Step 2: Creating a Stand alone application in matlab 

A detailed description is given in the following link: 
https://www.mathworks.com/help/compiler/create-and-install-a-standalone-application-from-matlab-code.html

This will create multiple folders, the binary file we need is located inside for_testing folder.

#### Step 3: Install the Docker Destop App

Depending on the Operating System, install Docker on your system after creating an account in Docker webpage

1. To create an account : https://hub.docker.com/
2. Install Docker depending on OS
nstall the Docker: 

        a.Linux:  https://docs.docker.com/install/linux/docker-ce/ubuntu/
        b.Mac: https://docs.docker.com/docker-for-mac/
        c.Windows: https://docs.docker.com/docker-for-windows/


#### Step 4: Create a Docker file
To run a matlab script, we need to build a docker image that contains Matlab Compiler Runtime (MCR).
Either we can pull the prebuilt version of MCR docker image from docker hub or build using the Docker file. There are several Docker files available on Github. I used the Docker file available on Flywheel Docker hub. (https://github.com/flywheel-apps/matlab-mcr/tree/master/2018b). 
Copy the  Docker file  from the mentioned Github link to your local folder where your  binary file resides.

#### Step 5: Building a Docker image

Run this command in a terminal to build a docker image

        docker build . -t "user-defined name of the image"
        for example:
        docker build . -t matlab

This will create a matlab docker image and we can verify this by typing the following command in the terminal

        docker images
        

#### Step 6: Running  the  matlab script in a docker image

Now we have installed MCR in a docker image, this will allow us to run our matlab script without having Matlab installed in our machine.

To run the functionSqaure matlab script, type the following command 

        docker run --rm -it -v /path/to/functionSquare/for_testing:/execute matlab /execute/functionSquare 4


--rm  Automatically remove the container when it exits
-v  Mounting a volume. Here we are mapping the local folder /path/to/functionSquare/for_testing  to  "execute" folder in the docker image. 
After mapping the input folder, we call the function "functionSquare" with an argument. "execute" folder can be called by any name. Depending on the script, the output will written in  the mapped folder.






















