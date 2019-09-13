set ns [new Simulator]

set nf [open sim.nam w]

$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 80ms DropTail
$ns duplex-link-op $n0 $n1 orient down-right

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam sim.nam &
	exit 0
}

$ns at 0.1ms "$ftp start"
$ns at 4ms "finish"
$ns run
