`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/6/2023 03:56:05 PM
// Design Name: 
// Module Name: tb_system
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module system_tb; 

    // Tín hiệu đầu vào
    reg clk, rst;
    reg Front_Sensor, Back_Sensor;
    reg [1:0] PWD_1, PWD_2;

    // Tín hiệu đầu ra
    wire GREEN_LED, RED_LED;

    // Gọi module system
    system uut (
        .clk(clk),
        .rst(rst),
        .Front_Sensor(Front_Sensor),
        .Back_Sensor(Back_Sensor),
        .PWD_1(PWD_1),
        .PWD_2(PWD_2),
        .GREEN_LED(GREEN_LED),
        .RED_LED(RED_LED)
    );

    // Tạo clock 10ns (tần số 100MHz)
    always #10 clk = ~clk;

    initial begin
        // Khởi tạo tín hiệu
        clk = 0;
        rst = 0;
        Front_Sensor = 0;
        Back_Sensor = 0;
        PWD_1 = 2'b00;
        PWD_2 = 2'b00;

        #10 rst = 1;
        #10 Front_Sensor = 1;

        #50 PWD_1 = 2'b01; PWD_2 = 2'b10; 

        #50 Back_Sensor = 1; 

        #50 Front_Sensor = 0; Back_Sensor = 0;
        
        #50 Front_Sensor = 1; 
        #50 PWD_1 = 2'b11; PWD_2 = 2'b00; 

        #50 PWD_1 = 2'b01; PWD_2 = 2'b10;

        #50 Back_Sensor = 0; Front_Sensor = 1; 

        #50 Back_Sensor = 1;

        #100 $finish;
    end

    initial begin
        $monitor("Time = %d | State = %b | PWD_1 = %b | PWD_2 = %b | Entrance = %b | Exit = %b | GREEN_LED = %b | RED_LED = %b",
                 $time, uut.current_state, PWD_1, PWD_2, Front_Sensor, Back_Sensor, GREEN_LED, RED_LED);
    end

endmodule
