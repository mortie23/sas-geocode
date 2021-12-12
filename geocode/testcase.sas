data test1;
	col2='A';
	val=1;
run;

data test2;
	col2='a';
	val2=2;
run;

data test_join;
	merge	test1
			test2;
	by col2;
run;
