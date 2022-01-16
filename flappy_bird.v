module flappy_bird(output reg [7:0] DATA_R, DATA_G, DATA_B,
								output reg [6:0] d7_1, 
								output reg d7_dot,
								output reg [2:0] COMM, //控制8X8 LED的S2 S1 S0
								output reg [4:0] Life, //五次生命機會							
								output reg [3:0] COMM_CLK, //七段顯示器的COMM
								output reg EN,
								input CLK, clear, Up, Down,
								input [3:0] Level );
								
	reg [7:0] pipe [7:0];
	reg [7:0] bird [7:0];
	reg [6:0] seg1, seg2, seg3, seg4;
	reg [3:0] bcd_m1, bcd_m2, bcd_s1, bcd_s2;
	reg [2:0] random01, r;
	reg up, down, temp;
	segment7 S2(bcd_s2, A4,B4,C4,D4,E4,F4,G4);
	segment7 S1(bcd_s1, A3,B3,C3,D3,E3,F3,G3);
	segment7 M2(bcd_m2, A2,B2,C2,D2,E2,F2,G2);
	segment7 M1(bcd_m1, A1,B1,C1,D1,E1,F1,G1);
	divfreq div0(CLK, CLK_div);
	divfreq1 div1(CLK, CLK_time);
	divfreq2 div2(CLK, Level, CLK_mv);
	integer height, count, count1;
	integer a, touch;
	

	
	parameter logic [7:0] Type[7:0]='{8'b01110000, 
												 8'b00001110,
												 8'b00111000, 
												 8'b00011100,
												 8'b01110000,
												 8'b00001110,
												 8'b00111000,
												 8'b00011100								 
												 };

		  
//初始值
	initial
		begin
			bcd_m1 = 0;
			bcd_m2 = 0;
			bcd_s1 = 0;
			bcd_s2 = 0;
			d7_dot = 0;
			
			height = 4;
			random01 = (5*random01 + 3)%16;
			r = random01 % 8;
			
			a = 0;
			touch = 0;
			
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			DATA_B = 8'b11111111;
			
			pipe[0] = 8'b11111111;
			pipe[1] = 8'b11111111;
			pipe[2] = 8'b11111111;
			pipe[3] = 8'b11111111;
			pipe[4] = 8'b11111111;
			pipe[5] = 8'b11111111;
			pipe[6] = 8'b11111111;
			pipe[7] = 8'b11111111;
			
			bird[0] = 8'b11111111;
			bird[1] = 8'b11111111;
			bird[2] = 8'b11101111;
			bird[3] = 8'b11111111;
			bird[4] = 8'b11111111;
			bird[5] = 8'b11111111;
			bird[6] = 8'b11111111;
			bird[7] = 8'b11111111;

			count1 = 2'b0;
		end

		
//7段顯示器的視覺暫留
always@(posedge CLK_div)
	begin
		//分 十位數
		seg1[0] = A1;
		seg1[1] = B1;
		seg1[2] = C1;
		seg1[3] = D1;
		seg1[4] = E1;
		seg1[5] = F1;
		seg1[6] = G1;
		
		//分 個位數
		seg2[0] = A2;
		seg2[1] = B2;
		seg2[2] = C2;
		seg2[3] = D2;
		seg2[4] = E2;
		seg2[5] = F2;
		seg2[6] = G2;
		
		//秒 十位數
		seg3[0] = A3;
		seg3[1] = B3;
		seg3[2] = C3;
		seg3[3] = D3;
		seg3[4] = E3;
		seg3[5] = F3;
		seg3[6] = G3;
		
		//秒 個位數
		seg4[0] = A4;
		seg4[1] = B4;
		seg4[2] = C4;
		seg4[3] = D4;
		seg4[4] = E4;
		seg4[5] = F4;
		seg4[6] = G4;
		

		
		if(count1 == 2'b11)
			begin
				d7_1 <= seg1;
				COMM_CLK <= 4'b0111;
				count1 <= 2'b00 ;
			end
		else if(count1 == 4'b10)
			begin
				d7_1 <= seg2;
				COMM_CLK <= 4'b1011;
				count1 <= 2'b11;
			end
		else if(count1 == 2'b01)
			begin
				d7_1 <= seg3;
				COMM_CLK <= 4'b1101;
				count1 <= 2'b10;
			end
		else if(count1 == 2'b00)
			begin
				d7_1 <= seg4;
				COMM_CLK <= 4'b1110;
				count1 <= 2'b01;
			end

	end

//計時&進位	
always@(posedge CLK_time, posedge clear)
	begin
		if(clear)
			begin
				bcd_m1 = 3'b0;
				bcd_m2 = 4'b0;
				bcd_s1 = 3'b0;
				bcd_s2 = 4'b0;
			end
		else
			begin
				if(touch < 5)
					begin
						if(bcd_s2 >= 9)
							begin
								bcd_s2 <= 0;
								bcd_s1 <= bcd_s1 + 1;
							end
						else
							bcd_s2 <= bcd_s2 + 1;
						
						if((bcd_s1 == 5) && (bcd_s2==9)) 
							begin
								bcd_s1 <= 0;
								bcd_s2 <= 0;
								bcd_m2 <= bcd_m2 + 1;
								if(bcd_m2 >=9)
									begin
										bcd_m2 <= 0;
										bcd_m1 <= bcd_m1 + 1;
									end
								else
									bcd_m2 <= bcd_m2 + 1;
									
							end
					end
			end
	end
//主畫面的視覺暫留	
always@(posedge CLK_div)
	begin
		if(count >= 7)
			count <= 0;
		else
			count <= (count + 1);
		COMM = 7-count;
		EN = 1'b1;
		if(touch < 5)
			begin
				DATA_G <= pipe[7-count];
				DATA_R <= bird[7-count];
				if(touch == 0)
					Life <= 5'b11111;
				else if(touch == 1)
					Life <= 5'b11110;
				else if(touch == 2)
					Life <= 5'b11100;
				else if(touch == 3)
					Life <= 5'b11000;
				else if(touch == 4)
					Life <= 5'b10000;
				end
		else
			begin
				DATA_R <= pipe[7-count];//bird[height]; //8'b11101111;
				DATA_G <= 8'b11111111;
				Life <= 5'b00000;
			end
	end

	
//遊戲
always@(posedge CLK_mv)
	begin
		
		down = Down;
		up = Up;	
		
		if(clear == 1)
				begin
					touch = 0;
					height = 4;
					a = 0;
					random01 = (5*random01 + 3)%16;
					r = random01 % 8;
					
					pipe[0] = 8'b11111111;
					pipe[1] = 8'b11111111;
					pipe[2] = 8'b11111111;
					pipe[3] = 8'b11111111;
					pipe[4] = 8'b11111111;
					pipe[5] = 8'b11111111;
					pipe[6] = 8'b11111111;
					pipe[7] = 8'b11111111;
					
					bird[0] = 8'b11111111;
					bird[1] = 8'b11111111;
					bird[2] = 8'b11101111;
					bird[3] = 8'b11111111;
					bird[4] = 8'b11111111;
					bird[5] = 8'b11111111;
					bird[6] = 8'b11111111;
					bird[7] = 8'b11111111;
					
				end
////////////////////////////////////////
			//pipe move
		if(touch < 5)
			begin
				if(a == 0)
					begin
						pipe[7-a] = Type[r];
						a = a+1;
					end
				else if (a > 0 && a <= 7)
						begin
							pipe[7-a] = Type[r]; 
							pipe[7-a+1] = 8'b11111111;
							a = a+1;
						end
				else if(a == 8) 
					begin
						pipe[0] = 8'b11111111;
						random01 = (5*random01 + 3)%16;
						r = random01 % 8;
						a = 0;
					end
/////////////////////////////////////////	
			//bird move	
			
				//重力往下掉
				if((up==0) && height!=7)
					begin
						bird[2][height] = 1'b1;
						height = height + 1;
						bird[2][height] = 1'b0;
					end
				else if((up == 1) && (height != 0))
					begin
						bird[2][height] = 1'b1;
						height = height - 1;
					end
					
				if((down == 1) && (height != 7))
					begin
						bird[2][height] = 1'b1;
						height = height + 1;
					end
				bird[2][height] = 1'b0;
				bird[2][height] = 1'b0;
				
				//鳥撞到水管or撞到地板/天花板
				if(pipe[2][height] == 0)
					begin
						touch = touch + 1;
						//水管消失
						pipe[2] = 8'b11111111;
						
						a = 8;
					end
				else if((height==7) | (height==0))
					begin
						touch = touch + 1;
					end
			end
			
		//game over ---> X
		else
			begin
				pipe[0] = 8'b01111110;
				pipe[1] = 8'b10111101;
				pipe[2] = 8'b11011011;
				pipe[3] = 8'b11100111;
				pipe[4] = 8'b11100111;
				pipe[5] = 8'b11011011;
				pipe[6] = 8'b10111101;
				pipe[7] = 8'b01111110;
			end
			
	end
	
endmodule


module segment7(input [3:0] a, output A,B,C,D,E,F,G);
	
	always @(a)
		case(a)
			4'b0000:	{A,B,C,D,E,F,G} = 7'b0000001;
			4'b0001:	{A,B,C,D,E,F,G} = 7'b1001111;
			4'b0010:	{A,B,C,D,E,F,G} = 7'b0010010;
			4'b0011:	{A,B,C,D,E,F,G} = 7'b0000110;
			4'b0100:	{A,B,C,D,E,F,G} = 7'b1001100;
			4'b0101:	{A,B,C,D,E,F,G} = 7'b0100100;
			4'b0110:	{A,B,C,D,E,F,G} = 7'b0100000;
			4'b0111:	{A,B,C,D,E,F,G} = 7'b0001111;
			4'b1000:	{A,B,C,D,E,F,G} = 7'b0000000;
			4'b1001:	{A,B,C,D,E,F,G} = 7'b0000100;
			default: {A,B,C,D,E,F,G} = 7'b1111111;
		endcase
endmodule


		
//視覺暫留除頻器
module divfreq(input CLK, output reg CLK_div);
  reg [24:0] Count;
  always @(posedge CLK)
    begin
      if(Count > 5000)
        begin
          Count <= 25'b0;
          CLK_div <= ~CLK_div;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule

//計時除頻器
module divfreq1(input CLK, output reg CLK_time);
  reg [25:0] Count;
  initial
    begin
      CLK_time = 0;
	 end	
		
  always @(posedge CLK)
    begin
      if(Count > 25000000)
        begin
          Count <= 25'b0;
          CLK_time <= ~CLK_time;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule 

//掉落物&人物移動除頻器
module divfreq2(input CLK, input [3:0] Level , output reg CLK_mv);
  reg [35:0] Count;
  integer freq;
  initial
    begin
      CLK_mv = 0;
	 end	
		
  always @(posedge CLK)
    begin
		if(Level==4'b0000)
			freq = 12500000;
		else if(Level==4'b0001)
			freq = 9000000;
		else if(Level==4'b0010)
			freq = 6000000;
		else if(Level==4'b0100)
			freq = 3000000;
		else if(Level==4'b1000)
			freq = 2500000;	
			
      if(Count > freq)
        begin
          Count <= 35'b0;
          CLK_mv <= ~CLK_mv;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule 