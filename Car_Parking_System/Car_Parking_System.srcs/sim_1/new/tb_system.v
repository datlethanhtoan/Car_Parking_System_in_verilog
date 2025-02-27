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

module tb_system;

    // Inputs
    reg clk;
    reg rst;
    reg Front_Sensor;
    reg Back_Sensor;
    reg [1:0] PWD_1;
    reg [1:0] PWD_2;

    // Outputs
    wire GREEN_LED;
    wire RED_LED;

    // Instantiate the Unit Under Test (UUT)
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

    initial begin
        clk = 0;
        forever #10 clk = ~clk;  
    end

    initial begin
        rst = 0;
        Front_Sensor = 0;
        Back_Sensor = 0;
        PWD_1 = 2'b00;
        PWD_2 = 2'b00;

        #100;
        rst = 1;
        #20;
        Front_Sensor = 1;
        #200;
        Front_Sensor = 0;
        PWD_1 = 2'b01;  
        PWD_2 = 2'b10;

        #200;
        Back_Sensor = 1;
        #100;
        Back_Sensor = 0; 
        $finish;
    end

endmodule  