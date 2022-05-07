if [batch_mode] {
   # run 10000
   run -all
   quit -f

} else {
   add wave -r tb_top/*
   log -r */*
   # run 10000
   run -all
}

