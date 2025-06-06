# FD-FACTORY: Large Language Model-based Fuzz Driver Generation for Deep Learning Library APIs

## Overview

**FD-FACTORY** is a LLM-based **fuzz driver generation** tool for **deep learning (DL) libraries**, specifically designed to work with the Atheris fuzzer. The tool leverages **large language models (LLMs)** to automatically generate fuzz drivers for various DL APIs, enabling efficient testing and vulnerability detection.

**Paper**:
Zheng, Tianming, et al. "FD-FACTORY: Large Language Model-based Fuzz Driver Generation for Deep Learning Library APIs." (2025)

**Code**:
The complete code for FD-FACTORY will be available after the paper is accepted. 

## Prerequisites

1. OS: Linux
2. Docker: Required for executing LLM-generated code in an isolated environment to mitigate potential security risks.  
   - Ensure that Docker is installed ([Docker installation guide](https://docs.docker.com/get-docker/)) along with the NVIDIA Container Toolkit ([NVIDIA Docker guide](https://github.com/NVIDIA/nvidia-docker)).  
   - To verify the installation:
     ```bash
     docker run --rm --gpus all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
     ```
   - Note: If your user is not part of the Docker group, you may encounter permission issues. To resolve this, either add your user to the Docker group ([instructions](https://docs.docker.com/engine/install/linux-postinstall/)) or prepend `sudo` to Docker commands (e.g., `sudo docker <CMD>`).


## Setups

**1. Prepare Docker Image**

```bash
# (host machine)

cd scripts/docker

# Change the dockerfile and tag name as needed. 
vim build_image.sh
# Then,
bash build_image.sh 

# Or, directly run the following command to build the image with a specific tag:
docker build --file dockerfile_torch_1_12   --tag fd-factory:torch_1_12    ../../
docker build --file dockerfile_tf_2_10      --tag fd-factory:tf_2_10       ../../

# Check if the image is successfully built
docker images
```

**2. Prepare Docker container**

```bash
# (host machine)

cd scripts/docker

# Change the image and container name as needed.
vim run_container.sh
# Then,
bash run_container.sh
```

Now you should have entered the docker container.

**3. Verify fuzzing environment (*Optional*)**
    
```bash
# (docker container)

cd tests/fuzz
cd check_atheris
bash run.sh
```

Users can run other tests in the `/tests` directory to verify the setup.

## Generate Fuzz Drivers

**1. Run the following command to generate fuzz drivers:**

```bash
# (docker container)

cd /home/FD-FACTORY/scripts/gen_fuzz_drivers/

# To generate fuzz driver for a single API:
bash run_single_api.sh
# To generate fuzz drivers for a API list:
bash run_api_list.sh
```

The generated fuzz drivers will be saved in the `/home/FD-FACTORY/data/fuzz_drivers/{library}/{version}/apis/` directory in the docker container.

**2. Copy fuzz drivers to the host machine:**

```bash
# (host machine)

cd <host>/FD-FACTORY/scripts/gen_fuzz_drivers/

# Change the docker container name as needed.
vim copy_fuzz_drivers.sh
# Then,
bash copy_fuzz_drivers.sh
```

Now, you can view the generated fuzz drivers in `/FD-FACTORY/data/fuzz_drivers/{library}/{version}/apis/` directory.


## Fuzzing

Fuzzing is performed with Atheris.

**1. Start fuzzing:**

```bash
# (docker container)

cd /home/FD-FACTORY/scripts/fuzz/

# Fuzzing a single API:
bash run_single_api.sh
# Fuzzing a API list:
bash run_api_list.sh
```

Fuzzing results will be saved in the `/home/FD-FACTORY/data/fuzzing_results/` directory in the docker container.

**2. Copy fuzzing results to the host machine:**

```bash
# (host machine)

cd <host>/FD-FACTORY/scripts/fuzz/
# Change the docker container name as needed.
vim copy_fuzzing_results.sh
# Then,
bash copy_fuzzing_results.sh
```







## Contact

| Name           | Email Address             |
| -------------- | ------------------------- |
| Tianming Zheng | zhengtianming@sjtu.edu.cn |


## Reference
Zheng, Tianming, et al. "FD-FACTORY: Large Language Model-based Fuzz Driver Generation for Deep Learning Library APIs." (2025)