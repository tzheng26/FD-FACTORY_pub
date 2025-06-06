# Copy the generated fuzz drivers in the docker container to the host machine
if [ ! -d "../../data/fuzz_drivers/" ]; then
  mkdir -p "../../data/fuzz_drivers/"
fi

container_name="fd-factory_torch_1_12"
# container_name="fd-factory_tf_2_10"
docker cp $container_name:/home/FD-FACTORY/data/fuzz_drivers/ ../../data/fuzz_drivers/