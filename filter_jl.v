// combined module decleration
module filter(

        // Interface signals
        input clk,
        input start,
        output reg done,


        // Data Signals
        input  [7:0] data_in,
        output reg [7:0] data_out,
        output reg [7:0] accumul_value

    );

    // Coefficient Storage
    reg signed [7:0] coeff [15:0];
    reg signed [7:0] data  [15:0];

    // Counter for iterating through coefficients.
    reg [3:0] count;

    // Accumulator
    reg signed [17:0] acc;

    // State machine signals
    localparam IDLE = 0;
    localparam RUN  = 1;
    reg state;

    // creating new varible to initialize 
    // the data buffer
    integer temp;

    initial begin
        coeff[0] = -1;
        coeff[1] = 0;
        coeff[2] = 3;
        coeff[3] = 12;
        coeff[4] = 29;
        coeff[5] = 52;
        coeff[6] = 74;
        coeff[7] = 87;
        coeff[8] = 87;
        coeff[9] = 74;
        coeff[10] = 52;
        coeff[11] = 29;
        coeff[12] = 12;
        coeff[13] = 3;
        coeff[14] = 0;
        coeff[15] = -1;

        // initilaizing data buffer to 0 and the state to IDLE for simulation
        state = IDLE;
        for (temp = 0;temp < 16 ; temp = temp +1) begin
            data[temp] = 8'b0;
            
        end

    end


    // the incoming data on the input port is stored 
    // in a data buffer register
    // this also provides the delay required for the FIR 
    // filter to be multiplied with the coefficients
    always @(posedge clk) begin : capture
        integer i;
        if (start) begin
        for (i = 0; i < 15 ; i = i+1) begin
                data[i+1] <= data[i];
            end
            data[0] <= data_in;
        end
    end


    // the filter SM starts when the State is IDLE
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                done <= 1'b0;
                if (start) begin
                    count <= 15;
                    acc   <= 0;
                    state <= RUN;
                end
            end
            RUN: begin
                count <= count - 1'b1;
                // direct form I realization, 
                // the filter coeff and data are multiplied
                acc   <= acc + data[count] * coeff[count];
                if (count == 0) begin
                    state <= IDLE;
                    done  <= 1'b1;
                end
            end
        endcase
    end



    // the accumulator accounts for multiplication overflow, 
    always @(posedge clk) begin
        if (done) begin
            // Saturate if necessary
            if (acc >= 2 ** 16) begin
                data_out <= 127;
            end else if (acc < -(2 ** 16)) begin
                data_out <= -128;
            end else begin
                data_out <= acc[16:9];
            end
        end
    end
endmodule