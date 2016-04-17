
`timescale 1ns / 100ps


// Dependences:
//
// $RTL_DIR/



`define Ndigit              3
`define ACQUISITION_TIME   20


module  MPPC_dark_counter(

   input   clk,
   input   rst,
   input   start,               // push-button or slide switch
   input   disc_pulse,
   output  segA,
   output  segB,
   output  segC,
   output  segD,
   output  segE,
   output  segF,
   output  segG,
   output  segDP,
   output  [`Ndigit-1:0] anode ) ;





   // free-running counter for clock dividers

   reg [26:0] clk_count ;

   always @(posedge clk) begin
      if( rst == 1'b1 )
         clk_count <= 'b0 ;
      else
         clk_count <= clk_count + 1'b1 ;
   end

   wire   clk_time_counter ;
   assign clk_time_counter = clk_count[5] ;


   // single-pulse generator

   reg start_synch_q0, start_synch_q1, start_synch_q2 ;

   always @(posedge clk) begin

      if( rst == 1'b1 ) begin

         start_synch_q0 <= 1'b0 ;
         start_synch_q1 <= 1'b0 ;
         start_synch_q2 <= 1'b0 ;
      end

      else begin
      
         start_synch_q0 <= start ;
         start_synch_q1 <= start_synch_q0 ;
         start_synch_q2 <= start_synch_q0 & (~ start_synch_q1) ;
      end
   end
   
   
   wire start_pulse ;
   assign start_pulse = start_synch_q2 ;



   // register the start flag into a 1-bit register

   reg start_reg ;

   always @(posedge clk ) begin

      if( rst == 1'b1 )   
         start_reg <= 1'b0 ;
      else
         if(start_pulse == 1'b1)
            start_reg <= 1'b1 ;
   end



   // counter that defines the acquisition window

   reg [4:0] time_count ;

   wire [4:0] time_count_max = 5'b11111 ;

   always @(posedge rst or posedge clk_time_counter ) begin

      if( rst == 1'b1 )
         time_count <= 'b0 ;

      else
         if( (start_reg == 1'b1) && (time_count < time_count_max ) )
            time_count <= time_count + 1'b1 ;

   end


   // register the stop flag into a 1-bit register

   reg stop_reg ;

   always @(posedge clk) begin

      if( rst == 1'b1 )   
         stop_reg <= 1'b0 ;
      else
         if(time_count == time_count_max)
            stop_reg <= 1'b1 ;
   end

   
   // combine start/stop flags

   wire    dark_counter_en ;
   assign  dark_counter_en = start_reg & (~stop_reg) ;

   
   // BCD counter
   
   BCD_counter_Ndigit  #(6) dark_counter(

      .clk  (      disc_pulse ),
      .rst  (             rst ),
      .en   ( dark_counter_en )

      ) ;



endmodule
