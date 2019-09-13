BEGIN{tcp=0;ack=0}
{
if ($1 == "r" && $5 == "ack")
{
	ack++;
}
else if ($1 == "r" && $5 == "tcp")
{
	tcp++;
}
}
END{
	printf("Number of packets sent by TCP = %d \n",tcp);
	printf("Number of packets sent by ACK = %d \n",ack);
}
