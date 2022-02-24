`timescale 1ns/1ns
// `include "filter_jl.v"

module filter_jl_tb ();

// interface signals
reg reg_clk;
reg reg_start;
wire wire_done;


// data signals
reg [7:0] reg_datain;
wire [7:0] wire_dataout;
wire [7:0] wire_acc;


integer i;

// instanciating DUT
filter filter_test(reg_clk, reg_start, reg_done, reg_datain, wire_dataout, wire_acc);

    
initial 
    begin
        // one clock cycle is 4 ns
        // pos cycle = neg cycle = 2ns
        reg_clk = 1;
        forever 
        #2  reg_clk = ~reg_clk;
    end

initial begin
    $monitor (reg_clk, reg_start, reg_done, reg_datain, wire_dataout, wire_acc);
    $dumpfile("filte_jl2.vcd");
    $dumpvars(0, filter_jl_tb);
    // $fwrite();
    i = 0;
    reg_start = 1;
end


// setting up reading data from .dat file
integer               data_file    ; // file handler
integer               scan_file    ; // file handler
reg signed [7:0] captured_data;
`define NULL 0

initial begin 
  data_file = $fopen("input_test2.dat", "r");
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
end

always @(posedge reg_clk) begin
  scan_file = $fscanf(data_file, "%d\n", captured_data); 
  if (!$feof(data_file)) begin
    //use captured_data as wire or reg value;
    // everytime data is read, i will increase 
    // stop simulation when i becomes = 5000ns
     for (i = 0; i < (5000) ; i = i +1) begin
      reg_datain = captured_data;
    end   
  end
end

integer f;
initial begin
  f = $fopen("output_test2.dat","w");
  #(5000); // <== simulation run time
  $fclose(f); 
  $finish; // <== end simulation
end

always @(posedge reg_clk)
begin
  $fwrite(f,"%b\n",wire_dataout);
end

endmodule