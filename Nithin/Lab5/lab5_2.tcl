set ns [new Simulator]
set nf [open lab5_2.nam w]
set nt [open lab5_2.tr w]
$ns namtrace-all $nf
$ns trace-all $nt

for {set i 0} {$i < 6} {incr i} {
set n($i) [$ns node]
}

$ns color 1 Red
$ns color 2 Green

for {set i 0} {$i < 5} {incr i} {
$ns duplex-link $n($i) $n([expr $i+1]) 1Mb 10ms DropTail
}
$ns duplex-link $n(0) $n(5) 1Mb 10ms DropTail

set err [new ErrorModel]
$err set rate 0.99 $n(3) $n(4)
$err ranvar [new RandomVariable/Uniform]
$err drop-target [new Agent/Null]
$ns lossmodel $err $n(2) $n(3)

set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink
$ns connect $tcp $sink

set udp [new Agent/UDP]
$ns attach-agent $n(1) $udp
set null [new Agent/Null]
$ns attach-agent $n(5) $null
$ns connect $udp $null

set ftp [new Application/FTP]
$ftp attach-agent $tcp
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$tcp set fid_ 2
$udp set fid_ 1

proc finish {} {
	global ns nf nt
	$ns flush-trace
	close $nf
	close $nt
	exec nam lab5_2.nam &
	set tcpsize [exec sh f1.sh]
	set tcpnum [exec sh f2.sh]
	set udpsize [exec sh f3.sh]
	set udpnum [exec sh f4.sh]
	set time_of_exec 124.00

	puts "Througput of TCP is [expr $tcpsize * $tcpnum / $time_of_exec] bytes per sec \n"
	puts "Througput of UDP is [expr $udpsize * $udpnum / $time_of_exec] bytes per sec \n"
	exit 0
	}

$ns at 0.0ms "$ftp start"
$ns at 0.0ms "$cbr start"
$ns at 124ms "finish"
$ns run
