# Running a simple Matlab script in a Docker image

## What is Docker?
Docker is a open source tool allowing to create, deploy and run applications in an environment or a container, without the need of creating a whole virtula operating system. More information about dockercan be found in the below links

    https://opensource.com/resources/what-docker
    https://docs.docker.com/engine/docker-overview/

Lets create a simple function in matlab and see how we can run this function in a docker



## Step 1: SPM script - To find a mean volume
Open Matlab and add SPM12 to your path. Create a function to find a mean volume of given images

#### To find mean volume
        
        function example()
        nii = spm_select('FPList', './execute/','^T_boldrest.nii');
        nvol = spm_vol(nii);

        nvols=spm_read_vols(nvol);
        meanvols = mean(nvols,4);
        vo=nvol(1);
        vo.fname = fullfile(fileparts(nii),['mean_' spm_str_manip(nvol(1).fname,'t')]);
        vo.dt = [16 0];
        spm_write_vol(vo,meanvols);
        end


#### Step 2: Creating a Stand alone application in matlab 

A detailed description is given in the following link: 
https://www.mathworks.com/help/compiler/create-and-install-a-standalone-application-from-matlab-code.html

This will create multiple folders, the binary file we need is located inside for_testing folder. When creating a stand alone application, matlab includes  necessary scripts to run the function. In the above example, matlab will automatically add spm_select, spm_read_vols and spm_write_vol.
If its a simple script with few functions to be called, we can follow the method described in this tutorial.  If you would like to run a preprocessing pipeline in SPM, where it need other toolboxes as well, please check my Dockerize_spm_preproc_pipeline section.

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

        docker run --rm -it -v /path/to/functionSquare/for_testing:/execute matlab /execute/example


--rm  Automatically remove the container when it exits
-v  Mounting a volume. Here we are mapping the local folder /path/to/functionSquare/for_testing  to  "execute" folder in the docker image. 
After mapping the input folder, we call the function "example". "execute" folder can be called by any name. The mean image will be written in  the mapped folder.






















