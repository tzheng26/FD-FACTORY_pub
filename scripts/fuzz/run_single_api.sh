library="pytorch"
version="1.12"

api="torch.add"

fuzz_driver_base_path="/home/FD-FACTORY/data/fuzz_drivers/$library/$version/apis/"

timeout=1800 # fuzzing timeout 30min (30*60=1800s)

save_path="/home/FD-FACTORY/data/fuzzing_results/"
log_path="/home/FD-FACTORY/logs/fuzz/"

cd /home/FD-FACTORY/src/fuzz
python3 main.py --library $library \
                --version $version \
                --api $api \
                --fuzz_driver_base_path $fuzz_driver_base_path \
                --timeout $timeout \
                --save_path $save_path \
                --log_path $log_path
