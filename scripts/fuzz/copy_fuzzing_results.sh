# Copy the generated fuzzing results in the docker container to the host machine
if [ ! -d "../../data/fuzzing_results/" ]; then
  mkdir -p "../../data/fuzzing_results/"
fi

container_name="fd-factory_torch_1_12"
# container_name="fd-factory_tf_2_10"
docker cp $container_name:/home/FD-FACTORY/data/fuzzing_results/ ../../data/fuzzing_results/