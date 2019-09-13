set ns [new Simulator]
$ns color 1 Red
$ns color 2 Green
set nf [open sim.nam w]

$ns namtrace-all $nf

set n0 [$ns node]
$n0 color green
set n1 [$ns node]
$n1 color red
set n2 [$ns node]
$n2 color blue

$ns duplex-link $n0 $n2 1Mb 8ms DropTail
$ns queue-limit $n0 $n2 5
$ns duplex-link-op $n0 $n2 orient down-right

$ns duplex-link $n1 $n2 1Mb 8ms DropTail
$ns queue-limit $n1 $n2 5
$ns duplex-link-op $n1 $n2 orient down-left

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

$tcp0 set fid_ 2
$tcp1 set fid_ 1

set sink0 [new Agent/TCPSink]
$ns attach-agent $n2 $sink0

set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1

$ns connect $tcp0 $sink0 
$ns connect $tcp1 $sink1 

set ftp0 [new Application/FTP]
set ftp1 [new Application/FTP]

$ftp0 attach-agent $tcp0
$ftp1 attach-agent $tcp1

$ns at 0.1ms "$ftp0 start"
$ns at 0.1ms "$ftp1 start"
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam sim.nam &
	exit 0 }
$ns at 4ms "finish"
$ns run


