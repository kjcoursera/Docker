# Running SPM12 script in a Docker image - spm preprocessing pipeline

## What is Docker?
Docker is a open source tool allowing to create, deploy and run applications in an environment or a container, without the need of creating a whole virtula operating system. More information about docker can be found in the below links

    https://opensource.com/resources/what-docker
    https://docs.docker.com/engine/docker-overview/

Lets create a spm preprocessing pipeline in SPM12/MATLAB and see how we can run this function in a docker


#### Step 1: Files needed to run spm preprocessing script in a docker image

    1. spm preprocessing batch script - in matlab/spm12
    2. Docker file - to install Matlab compiler runtime and stand alone SPM
    3. JSON file -  to pass the parameters to the bash/shell script
    4. bash/shell script -  to run the pre processing within the docker image

## Step 2: SPM script - simple preprocessing pipeline
Open Matlab and add SPM12 to your path. Lets first create a batch script to preprocess fMRI data using the batch GUI. We will add the follwoing steps.

            1. Realignment -  Correct Head motion
            2. Coregister  - registering to high resolution structural image
            3. Segment  -  to find the gray matter and get deformation fields
            4. Deformation -  apply deformation field to register to MNI space
            5. Smoothing  - to lower the noise or to increase SNR

Save the script as a function with  any input arguments.  This example preprocessing script is called as " spm_preproce_pipeline.m".

            function spm_preproce_pipeline(data_path, anat, numpasses, voxelsize,smooth)

To run the above function, we need 5 paramters as input arguments. 

        1. data_ path  -  where the data is located
        2. anat -  structural data - file path and file name
        3. numpasses -  specification in realignment, whether to register to first or mean image. It is a binary value
        4. voxel size -  voxel size for normalized images
        5. smooth -  smoothing factor

#### Step 3: JSON file
The paramters that needs to passed to the function can be stored as simple data structure in JSON (JavaScript Object Notation) format.
for example, we have a paramter called numpasses in our preprocessing function. This paramter excepts 0 or 1 as a value, we can refer this as boolean variable. In JSON structure, we can write this as:
        
        "config": {
                    "realignment": {
                    "description": "NumPasses: Register to First image(0) or Mean image(1).",
                    "default": 1,
                    "type": "boolean",
                    "id": "-s"
                    }
                }

In our example, the file is named as manifest.json


#### Step 4: bash/shell script

Shell script is used for two purposes : 
1. getting the input arguments either from JSON file or defining within the shell script 
2. executing the spm preprocessing script 

The next step is to install Docker App before creating Docker file.

#### Step 5: Install the Docker Destop App

Depending on the Operating System, install Docker on your system after creating an account in Docker webpage

1. To create an account : https://hub.docker.com/
2. Install Docker depending on OS
nstall the Docker: 

        a.Linux:  https://docs.docker.com/install/linux/docker-ce/ubuntu/
        b.Mac: https://docs.docker.com/docker-for-mac/
        c.Windows: https://docs.docker.com/docker-for-windows/


#### Step 6: Create a Docker file

A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image.(docs.docker.com)
Our document should have thefollowing

In our Docker file we have three sections. 1. Matlab Compiler Runtime (MCR)installation 2. SPM12 standalone installation 3. to run the shell script thereby we are running the pipeline.

1. MCR installation:

To run a matlab based script, we need to build a docker image that contains Matlab Compiler Runtime (MCR).
Either we can pull the prebuilt version of MCR docker image from docker hub or build using the Docker file. There are several Docker files available on Github. I used the Docker file available on Flywheel Docker hub. (https://github.com/flywheel-apps/matlab-mcr/tree/master/2018b). 
Copy the  Docker file  from the mentioned Github link to your local folder where your  binary file resides.

2. SPM12 - a stand alone version:

A docker file to install SPM12 standalone is available in https://github.com/spm/spm-docker . This docker file comes with both matlab(MCR) and SPM12 installation.  For MCR installtion, we can either use the one available in Flywheel DOcker page or the one provided by SPM developers.

3. Add shell script 

Add the shell script, so we can run the preprocessing pipeline



#### Step 7: Building a Docker image

Run this command in a terminal to build a docker image

        docker build . -t "user-defined name of the image"
        for example:
        docker build . -t pipeline

This will create a pipeline docker image and we can verify this by typing the following command in the terminal

        docker images



#### Step 8: Copy the NIFTI fMRI images

Suppose we have the above mentioned scripts in the following path: /path/to/docker/flywheel_challenge. Now create  "input"  and "tpm" folder within the flywheel_challenge. Copy the fMRI images to the input folder. In the segmentation step, we need TPM images to find the gray matter. So copy the TPM.nii to tpm folder.



#### Step 9: Running  the  matlab script in a docker image

Now we have installed MCR and SPM12 in a docker image, this will allow us to run our script without having Matlab installed in our machine.

To run the preprocessing script, type the following command 

        docker run --rm -it -v /path/to/docker/flywheel_challenge:/execute  pipeline


--rm  Automatically remove the container when it exits
-v  Mounting a volume. Here we are mapping the local folder /path/to/docker/flywheel_challenge  to  "execute" folder in the docker image. 
Next we are calling our docker images "pipeline" to run SPM preprocessing. The output images will be found in /path/to/docker/flywheel_challenge






















