`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/3/2023 09:30:36 AM
// Design Name: 
// Module Name: system
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


module system(
    input clk, rst,
    input Front_Sensor, Back_Sensor,
    input [1:0] PWD_1, PWD_2,
    output wire GREEN_LED, RED_LED
    );
    parameter IDLE = 3'b000;
    parameter WAIT_PWD = 3'b001;
    parameter WRONG_PWD = 3'b010;
    parameter RIGHT_PWD = 3'b011;
    parameter STOP = 3'b100;
    
    reg[2:0] current_state, next_state;
    reg [31:0] counter_wait;
    reg red_temp, green_temp;
    
    always @(posedge clk or negedge rst)begin
        if(~rst)
            current_state = IDLE;
         else
            current_state = next_state;
    end  
      
    //counter_wait
    always @(posedge clk or negedge rst)begin
        if(~rst)
            counter_wait <= 0;
         else if(current_state == WAIT_PWD)
            counter_wait <= counter_wait + 1;
         else
            counter_wait <= 0;
    end    
    
    /// FSM
    always @(*) begin
        case(current_state) 
            IDLE: begin
                if(Front_Sensor == 1)
                    next_state = WAIT_PWD;
                else
                    next_state = IDLE;
            end       
            
            WAIT_PWD: begin
                if(counter_wait <= 3)
                    next_state = WAIT_PWD;
                else begin
                    if((PWD_1 == 2'b01) && (PWD_2 == 2'b10))
                        next_state = RIGHT_PWD;
                    else
                        next_state = WRONG_PWD;
                end
            end
            
            WRONG_PWD: begin
                if((PWD_1 == 2'b01) && (PWD_2 == 2'b10))
                    next_state = RIGHT_PWD;
                else
                    next_state = WRONG_PWD;
            end
            
            RIGHT_PWD: begin
                if((Front_Sensor == 1) && (Back_Sensor == 1))
                    next_state = STOP;
                else if(Back_Sensor == 1)
                    next_state = IDLE;
                else
                    next_state = RIGHT_PWD;
            end
            
            STOP: begin
                if((PWD_1 == 2'b01) && (PWD_2 == 2'b10))
                    next_state = RIGHT_PWD;
                else
                    next_state = STOP;
            end
            
            default: next_state = IDLE;
        endcase
    end

    
    // control led
    
    always @(posedge clk)begin
        case(current_state) 
            IDLE: begin
                green_temp = 1'b0;  //led off
                red_temp = 1'b0;     //led off       
            end       
            WAIT_PWD: begin
                green_temp = 1'b0;
                red_temp = 1'b1;      //led on           
            end
            
            WRONG_PWD: begin
                green_temp = 1'b0;
                red_temp = ~red_temp;  //blinking  led       
            end            
            RIGHT_PWD: begin
                green_temp = ~green_temp;  //blinking  led   
                red_temp = 1'b0;  
            end
            
            STOP: begin
                green_temp = 1'b0;  
                red_temp = ~red_temp;  //blinking  led 
            end
            
        endcase
    end
    
    assign RED_LED = red_temp;
    assign GREEN_LED = green_temp;
    
endmodule
