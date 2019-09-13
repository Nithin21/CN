set ns [new Simulator]
set nf [open sim.nam w]

$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 8ms DropTail
$ns duplex-link-op $n0 $n1 orient down-left
$ns duplex-link $n0 $n2 1Mb 8ms DropTail
$ns duplex-link-op $n0 $n2 orient down-right

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1


set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0

set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1

$ns connect $tcp0 $sink0 
$ns connect $tcp1 $sink1 

set ftp0 [new Application/FTP]
set ftp1 [new Application/FTP]

$ftp0 attach-agent $tcp0
$ftp1 attach-agent $tcp1

$ns at 0.1ms "$ftp0 start"
$ns at 0.2ms "$ftp1 start"
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam sim.nam &
	exit 0 }
$ns at 4ms "finish"
$ns run


