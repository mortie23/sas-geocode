data test;
	length OrderID 8. OrderDate 8. PizzaID 8. OrderIP $16. OrderPhone $10. monthnum 8.;
	format OrderDate date9. OrderMonth monyy.;
	array seasons {12} s1-s12;
	s1=1.1; s2=1.2; s3=1.1; s4=1.5; s5=1.6; s6=1.8; s7=1.8; s8=1.7; s9=1.4; s10=1.3; s11=0.9; s12=0.8;
	OrderID=0;
	do OrderDate='01jan2000'd to '31dec2019'd;
		OrderMonth=intnx('month',OrderDate,0);
		do PizzaID=1 to 2;
			ordervalid=1;
			do while (ordervalid);
				monthnum=month(OrderDate);
				probabilty=uniform(1)*seasons(monthnum)*((year(OrderDate)-2000)/10+1);
				if probabilty < 0.1 then 
					ordervalid=0;
				OrderID=OrderID+1;
				OrderIP=put(uniform(1)*1000,3.)||'.'||put(uniform(1)*1000,3.)||'.'||put(uniform(1)*1000,3.)||'.'||put(uniform(1)*1000,3.);
				OrderPhone='04'||put(uniform(1)*100000000,z8.);
				output;
			end;
		end;
	end;
run;
proc summary data=test nway missing;
	class OrderMonth;
	output out=test_sum;
run;