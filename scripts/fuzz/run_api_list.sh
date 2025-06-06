library="pytorch"
version="1.12"

api="list"
api_list_path="/home/FD-FACTORY/data/knowledge_base/$library/$version/api_list_50.txt"
start_id=0
end_id=49

fuzz_driver_base_path="/home/FD-FACTORY/data/fuzz_drivers/$library/$version/apis/"

timeout=1800 # fuzzing timeout 30min (30*60=1800s)

save_path="/home/FD-FACTORY/data/fuzzing_results/"
log_path="/home/FD-FACTORY/logs/fuzz/"

cd /home/FD-FACTORY/src/fuzz
python3 main.py --library $library \
                --version $version \
                --api $api \
                --api_list_path $api_list_path \
                --start_id $start_id \
                --end_id $end_id \
                --fuzz_driver_base_path $fuzz_driver_base_path \
                --timeout $timeout \
                --save_path $save_path \
                --log_path $log_path