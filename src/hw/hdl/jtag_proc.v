`timescale 1 ns / 1 ps

module jtag_proc # (
  parameter integer C_TCK_CLOCK_RATIO = 8
) (
  input  wire        clk_i,
  input  wire        reset_i,
  input  wire        en_i,
  output reg         done_o,
  input  wire [31:0] length_i,
  input  wire [31:0] tms_vec_i,
  input  wire [31:0] tdi_vec_i,
  output wire [31:0] tod_vec_o,
  output wire        tck_o,
  output wire        tms_o,
  output wire        tdi_o,
  input  wire        tdo_i       
);

localparam Ideal_lk = 3'b001 ;
localparam TCKL_lk  = 3'b010 ;
localparam TCKH_lk  = 3'b100 ;           

reg [2:0]    state, next_state;
reg          en_r;
wire         en_edge;
reg          tck_en;
reg          tck_r;
reg          done_r;
reg [7:0]    tck_cnt;
reg [31:0]   bit_cnt;
reg [31:0]   tms_r;
reg [31:0]   tdi_r;
reg [31:0]   tdo_capture;

reg [0:0]    tdo_buffer [31:0];
reg [4:0]    index;

wire         tck_pulse;
wire [31:0]  tdo_capture2;

always @(posedge clk_i) begin: state_transfer
  if (reset_i == 1'b1) begin
    state <= Ideal_lk;
    en_r  <= 1'b0;
  end else begin
    state <= next_state;
    en_r  <= en_i;
  end
end

assign en_edge = en_i && !en_r;

always @(state or en_edge or bit_cnt or tck_pulse) begin 
  next_state = state;
  tck_en     = 1'b0;
  done_r     = 1'b0;
  
  case (state)
    Ideal_lk: begin
      if (en_edge == 1'b1) begin
        next_state = TCKL_lk;
        tck_en = 1'b1;
      end
    end
    
    TCKL_lk: begin
      tck_en = 1'b1;
      if (tck_pulse == 1'b1) begin
        next_state = TCKH_lk;
      end else begin
        next_state = TCKL_lk;
      end
    end
    
    TCKH_lk: begin
      tck_en = 1'b1;
      if (tck_pulse == 1'b1) begin
        if (bit_cnt == 0) begin
          next_state = Ideal_lk;
          done_r     = 1'b1;
        end else begin
          next_state = TCKL_lk;
        end
      end else begin
        next_state = TCKH_lk;
      end
    end
    
    default : begin
      next_state = Ideal_lk;
    end
  endcase
end

always @(posedge clk_i) begin
   if (reset_i == 1'b1) begin
    tck_cnt <= 0;
    bit_cnt <= 0;
    index     <= 0;
   end else begin
    if (en_edge == 1'b1) begin
    tck_cnt <= 0;
    bit_cnt <= length_i-1;
    index     <= 0;
   end else if (tck_en == 1'b1) begin
    if (tck_cnt == (C_TCK_CLOCK_RATIO/2)-1) begin
     tck_cnt <= 0;
    end else begin
     tck_cnt <= tck_cnt + 1;
    end
    //
    if (state == TCKH_lk && tck_pulse) begin
     bit_cnt <= bit_cnt - 1;
     index     <= index + 1;
    end
   end
   end
end

assign tck_pulse = (tck_cnt == (C_TCK_CLOCK_RATIO/2)-1) ? 1'b1 : 1'b0;

always @(posedge clk_i) begin
   if (reset_i == 1'b1) begin
   tck_r       <= 1'b0;
   tms_r  <= 0;
   tdi_r  <= 0;
   tdo_capture <= 0;
   done_o        <= 1'b0;
   end else begin
   done_o <= done_r;
   if (en_edge == 1'b1) begin
   tck_r       <= 1'b0;
   tms_r  <= tms_vec_i;
   tdi_r  <= tdi_vec_i;
   tdo_capture <= 0;
   end else if (tck_en == 1'b1) begin
   if (tck_pulse == 1'b1) begin
    tck_r <= ~tck_r;
    if (state == TCKH_lk) begin
    tms_r  <= {1'b0, tms_r[31:1]};
    tdi_r  <= {1'b0, tdi_r[31:1]};
    tdo_capture <= {tdo_capture[30:0], tdo_i};
    end else begin
    tdo_buffer[index] <= tdo_i;
    end
   end
   end else begin
   tms_r <= 0;
   tdi_r <= 0;
   end
   end
end

genvar i;

generate 
for (i=0; i < 32; i = i + 1) begin : array
assign tdo_capture2[i] = tdo_buffer[i];
end
endgenerate

//  assign tms_o = tms_r[0] ? 1'bZ : 1'b0;
assign tms_o = tms_r[0];
//      OBUFT u0_OBUFT (
//          .O (tms_o) ,
//          .I (1'b0) ,
//          .T (~tms_r[0])
//     );

//   assign tdi_o = tdi_r[0] ? 1'bZ : 1'b0;
assign tdi_o = tdi_r[0];
//      OBUFT u1_OBUFT (
//           .O (tdi_o) ,
//           .I (1'b0) ,
//           .T (~tdi_r[0])
//      );

//   assign tck_o = tck_r ? 1'bZ : 1'b0;
assign tck_o = tck_r;
//      OBUFT u_OBUFT (
//           .O (tck_o) ,
//           .I (1'b0) ,
//           .T (~tck_r)
//      );
assign tod_vec_o = tdo_capture2;


endmodule
