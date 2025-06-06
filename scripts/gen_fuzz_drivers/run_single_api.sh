library="pytorch"
version="1.12"

# API information
api="torch.add"
knowledge_base_path="/home/FD-FACTORY/data/knowledge_base/$library/$version/"

# llm configurations and prompt templates
llm_configs="/home/FD-FACTORY/src/gen_fuzz_drivers/agents/llm_configs_and_prompt_tmpls.yaml"

# Code execution environment (Two options: local, docker)
# (1) Run in a local environment or within an already accessed container environment.
env="local" 
# (2) Create a temporary Docker container when executing code is necessary
# env="docker"
# docker_image="fd-factory:latest"

# Experiment configurations
repeat=1 # best 6
max_debug_attempts=5 # best 5
timeout=60

save_path="/home/FD-FACTORY/data/fuzz_drivers/"
log_path="/home/FD-FACTORY/logs/gen_fuzz_drivers/"

cd /home/FD-FACTORY/src/gen_fuzz_drivers/
python3 main.py --library $library \
                --version $version \
                --api $api \
                --knowledge_base_path $knowledge_base_path \
                --llm_configs $llm_configs \
                --env $env \
                --repeat $repeat \
                --max_debug_attempts $max_debug_attempts \
                --timeout $timeout \
                --save_path $save_path \
                --log_path $log_path
                