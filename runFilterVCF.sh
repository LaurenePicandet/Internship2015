export ANDURIL_HOME=/home/picandet/anduril
/home/picandet/anduril/bin/anduril run /home/picandet/SCRIPTS/FilterVCF.and -d exec -b /home/picandet/anduril/bundles/microarray -b /home/picandet/anduril/bundles/anima1 --threads 3 --java-heap 6000 "$@"
  
