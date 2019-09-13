BEGIN{drop=0}
{
if ($1 == "d" && $5 == "tcp")
{
	drop++;
}
}
END{
	printf("Number of packets droped = %d \n",drop);
	
}
