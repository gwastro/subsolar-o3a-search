for i in {0..1200}; do
sleep 0.1
step=25
start=`echo "$step * ($i + 0)" | bc`
end=`echo "$step * ($i + 1)" | bc`
echo $i $start $end

OMP_NUM_THREADS=1 HMR_FILE=../t6/s.hdf \
condor_run -a accounting_group=cbc.test.search -a request_memory=10000 unbuffer python pycbc_brute_bank \
--verbose \
--output-file ss-$i.hdf \
--minimal-match 0.95 \
--tolerance .005 \
--buffer-length 2 \
--sample-rate 2048 \
--tau0-threshold 0.5 \
--approximant TaylorF2e \
--tau0-crawl 5 \
--tau0-start $start \
--tau0-end $end \
--psd-file o3psd.txt \
--min 0.10 0.10   \
--max 0.5    7      \
--params mass1 mass2 \
--seed 1 \
--low-frequency-cutoff 25.0 > $i.out &
done
