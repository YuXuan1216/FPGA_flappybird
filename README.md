# FPGA_flappybird

### Authors: 108328017 林育萱, 1083210xx 王昱程

#### input/output unit:
- 4 BITS SW，用來控制鳥的方向，S1: 往上，S2: 往下
- 8 DIPSW(藍色)，用來調整遊戲難度(速度)，難度: 1000 > 0100 > 0010 > 0001
- 8x8 LED 矩陣，用來當成遊戲主畫面
<img width="122" alt="image" src="https://user-images.githubusercontent.com/77137768/149675607-1e984da0-c823-47ca-b59d-29ced15710fc.png">
- 7段顯示器，用來計時
- LED 陣列，用來計生命次數(初始為5次)

#### 功能說明:
- 鳥會受重力影響往下掉
- 4 BITS SW 的 S1能讓鳥往上，S2能往下
- 紅色燈為鳥，綠色燈為水管，鳥不能撞到水管、天花板、地板，撞到就扣一次生命(LED 陣列)
- 生命為0時顯示X，代表遊戲結束
- 七段顯示器用來記錄存活時間
- 8 DIPSW(藍色)能夠調整遊戲頻率(水管速度)

#### 程式模組說明:
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
); 

#### Demo video:
