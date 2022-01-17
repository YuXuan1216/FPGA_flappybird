# FPGA_flappybird

### Authors: 108328017 林育萱, 108321060 王昱程

#### input/output unit:
- 4 BITS SW，用來控制鳥的方向，S1: 往上，S2: 往下，S4: clear <br>
<img width="200" alt="image" src="https://github.com/YuXuan1216/FPGA_flappybird/blob/main/img/img5.jpg"><br>
- 8 DIPSW(紅色)，用來調整遊戲難度(速度)，難度: 1000 > 0100 > 0010 > 0001 > 0000 <br>
<img width="200" alt="image" src="https://github.com/YuXuan1216/FPGA_flappybird/blob/main/img/img4.jpg"> <br>
- 8x8 LED 矩陣，用來當成遊戲主畫面 <br>
<img width="200" alt="image" src="https://github.com/YuXuan1216/FPGA_flappybird/blob/main/img/img1.jpg"> <br>
- 7段顯示器，用來計時 <br>
<img width="200" alt="image" src="https://github.com/YuXuan1216/FPGA_flappybird/blob/main/img/img2.jpg"> <br>
- LED 陣列，用來計生命次數(初始為5次) <br>
<img width="200" alt="image" src="https://github.com/YuXuan1216/FPGA_flappybird/blob/main/img/img3.jpg"> <br>

#### 功能說明:
- 鳥會受重力影響往下掉
- 4 BITS SW 的 S1能讓鳥往上，S2能往下
- 紅色燈為鳥，綠色燈為水管，鳥不能撞到水管、天花板、地板，撞到就扣一次生命(LED 陣列)
- 生命為0時顯示X，代表遊戲結束
- 七段顯示器用來記錄存活時間
- 8 DIPSW(紅色)能夠調整遊戲頻率(水管速度)

#### 程式模組說明:

- **主程式** <br>
**內部包含 初始化、七段顯示器的視覺暫留、計時、主畫面的視覺暫留、遊戲的控制(鳥移動、水管移動)** <br>
module flappy_bird( <br>
output reg [7:0] DATA_R, DATA_G, DATA_B,  //紅，藍，綠燈<br>
output reg [6:0] d7_1,  //七段顯示器 <br>
output reg d7_dot, //七段顯示器中間的點 <br>
output reg [2:0] COMM, //控制8X8 LED的S2 S1 S0 <br>
output reg [4:0] Life, //五次生命機會 <br>					
output reg [3:0] COMM_CLK, //七段顯示器的COMM <br>
output reg EN, //8x8 LED的EN <br> 
input CLK, clear, Up, Down, //時脈，初始化，控制鳥向上，控制鳥向下 <br>
input [3:0] Level  //遊戲難度 <br>
); <br>

- **時間轉7段顯示器** <br>
module segment7(input [3:0] a, output A,B,C,D,E,F,G); <br>

- **視覺暫留除頻器** <br>
module divfreq(input CLK, output reg CLK_div); <br>

- **計時除頻器** <br>
module divfreq1(input CLK, output reg CLK_time); <br>

- **pipe & bird 移動除頻器** <br>
module divfreq2(input CLK, input [3:0] Level , output reg CLK_mv); <br>

#### Demo video: (影片連結至google drive)
<a href="https://drive.google.com/file/d/1bemiqWMOaZ0BtUVvmuVjIuR3JXAzb-wW/view?usp=sharing" title="Demo Video"><img width="200" alt="image" src="https://github.com/YuXuan1216/FPGA_flappybird/blob/main/img/img6.png"> <br>
