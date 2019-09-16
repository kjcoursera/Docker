# This is an user guide to run SPM12 script on a Docker image - SPM preprocessing pipeline

#### SPM(Statistical Parametric Mapping)

Functional magnetic resonance imaging (fMRI), which allows researchers to observe neural activity during functional neuroimaging experiments. Before we statistically measure the changes in the brain  hemodynamics,the data has to be corrected for noise and artefacts. SPM is one of the popular fMRI tool to preprocess and analyze the brain images. SPM toolbox is run under MATLAB environment. In this guide, we are going to discuss how we preprocess the fmri data in a docker image by installing Matlab compiler and stand alone version of SPM. Once we have the docker image with matlab compiler and SPM, any one can run the preprocessing pipeline in any environement without the need of matlab. 



## What is Docker?
Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package. More information about Docker can be found in the below links

    https://opensource.com/resources/what-docker
    https://docs.docker.com/engine/docker-overview/


Let us create a SPM preprocessing pipeline in SPM12/MATLAB and see how we can run this function on a Docker.


#### Step 1: Files needed to run SPM preprocessing script using a Docker image

    1. SPM preprocessing batch script         - created in matlab/spm12
    2. Docker file 										        - to install Matlab compiler runtime and standalone SPM
    3. JSON (JavaScript Object Notation) file - to configure parameters and pass it to the bash/shell script (This is more like a control file)
    4. bash/shell script                      - to get the configured parameters and to run the preprocessing within the Docker image

#### Step 2: SPM script - simple preprocessing pipeline
Open Matlab and add SPM12 in Matlab command terminal/window. First, let us create a batch script to preprocess the fMRI data using batch GUI. We will add the following steps.

    1. Realignment - correct the head motion
    2. Coregister  - register to high-resolution structural image
    3. Segment     - to find the gray matter and get deformation fields
    4. Deformation - apply deformation field to register to MNI space
    5. Smoothing   - to lower the noise or to increase SNR

Save this script as a function with any input arguments.  This example preprocessing script is called as " spm_preproce_pipeline.m".

    function spm_preproce_pipeline(data_path, anat, numpasses, voxelsize,smooth)

To run the above function, we need following 5 parameters as input arguments. 

    1. data_ path  -  where the data is located
    2. anat        -  structural data - with the file path and file name
    3. numpasses   -  specification in realignment, i.e whether to register to first or mean image. It should be a binary value
    4. voxel size  -  voxel size for normalized images; a single digit
    5. smooth      -  smoothing factor; a single digit

#### Step 3: JSON file
The following parameters needs to be passed to the function as simple data structure in JSON format.
For example, we have a parameter called numpasses in our preprocessing function. This parameter excepts 0 or 1 as a value, we can refer this param as a boolean variable. In JSON structure, we can write this as:
        
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

Shell script is used for two purposes: 
    1. Getting the input arguments either from JSON file or defining within the shell script 
    2. Executing the SPM preprocessing script 

The file here we used is run.sh. The next step is to install Docker App before creating Docker file.

#### Step 5: Install the Docker Desktop App

Depending on the Operating System, install Docker on your system after creating an account in Docker webpage

    1. To create an account : https://hub.docker.com/
    2. Install Docker depending on OS 

        a.Linux:  https://docs.docker.com/install/linux/docker-ce/ubuntu/
        b.Mac: https://docs.docker.com/docker-for-mac/
        c.Windows: https://docs.docker.com/docker-for-windows/


#### Step 6: Create a Docker file

A Docker file is a text document that contains all the commands a user could call on the command line to assemble an image.(https://docs.docker.com)

Our docker file should have the following sections:

    1. Matlab Compiler Runtime (MCR) installation 
    2. SPM12 standalone installation 
    3. To run the shell script thereby we are running the pipeline.

Lets go through each of these above steps in detail.

1. MCR installation:

To run a matlab-based script, we need to build a Docker image that contains Matlab Compiler Runtime (MCR).
Either we can pull the prebuilt version of MCR Docker image from a docker hub or build using the Docker file. There are several Docker files available on GitHub. I used the Docker file available on Flywheel Docker hub. (https://github.com/flywheel-apps/matlab-mcr/tree/master/2018b). 
Copy the  Docker file from the mentioned GitHub link to your local folder where your binary file resides.

2. SPM12 - a stand alone version:

A Docker file to install SPM12 standalone is available in https://github.com/spm/spm-docker. This Docker file comes with both matlab(MCR) and SPM12 installation.  For MCR installation, we can use either the one, which is available on Flywheel Docker page, or the one provided by SPM developers.

3. Add shell script 

Add the shell script, so we can run the preprocessing pipeline.

#### Step 7: Building a Docker image

Run this command in the terminal to build a Docker image

        docker build . -t "user-defined name of the image"
        for example:
        docker build . -t pipeline

This will create a "pipeline" Docker image and we can verify this by typing the following command in the terminal

        Docker images


#### Step 8: Copy the fMRI NIFTI images

Suppose we have the above-mentioned scripts in the following path: /path/to/docker/flywheel_challenge. Now its time to copy the fMRI images to the designated folders. Create two folders named as  "input"  and "tpm" folder within the flywheel challenge. Copy the fMRI images to the input folder. In the segmentation step, we need TPM images to find the gray matter. So copy the TPM.nii to tpm folder.

#### Step 9: Run the script in a Docker image

Now we have installed MCR and SPM12 in a Docker image, this will allow us to run our script without having Matlab installed in our machine.

To run the preprocessing script, type the following command 

        docker run --rm -it -v /path/to/docker/flywheel_challenge:/execute  pipeline

--rm  Automatically remove the container when it exits
-v  Mounting a volume. Here we are mapping the local folder /path/to/docker/flywheel_challenge to  "execute" folder in the Docker image. 
Next, we are calling our Docker images "pipeline" to run SPM preprocessing. 

The output images will be found in /path/to/docker/flywheel_challenge. We can use freely available fMRI tools like Mango, fslview to view the final output.