///----------------------------------------------------------------------
//--SAYEH(Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// SayehTest

`timescale 1 ns /1 ns

module SayehTest();

reg clk, ExternalReset, MemDataready;
reg [15:0]	MemoryData;
wire [15:0] Databus, Addressbus;
wire ReadMem, WriteMem, ReadIO, WriteIO;

reg [15:0] SayehRAM [0:1023];

integer memout;

initial begin : IOfiles
  memout = $fopen ("OutputRAM.hex");
  $readmemh ("SayehRAM.hex", SayehRAM);
  clk = 0;
  ExternalReset = 0;
  MemDataready = 0;
  MemoryData = 16'bZ;
end

always #20 clk = ~clk;

integer i;
initial begin : RunCPU
  #05 ExternalReset = 1;
  #81 ExternalReset = 0;
  #370000;
  for (i=0; i<= 1023; i=i+1) 
    $fdisplay (memout, "%h: %h", i, SayehRAM[i]);
  $stop;
end

always @(negedge clk) begin : MemoryRead
  if (ReadMem) begin
    #1
    MemDataready = 1;
    MemoryData = SayehRAM [Addressbus];
  end else begin
    #1
    MemDataready = 0;
    MemoryData = 16'hZZZZ;
  end
end

//always @(negedge clk) begin 
//  #1;
//  if (WriteMem) begin
//    #1
//    SayehRAM [Addressbus] = Databus;
//    $display ($time, "ns \t %h : %h", Addressbus, Databus);
//  end
//end

always @(negedge clk) begin : MemoryWrite 
  #1 if (WriteMem) #1 SayehRAM [Addressbus] = Databus;
end

assign Databus = MemoryData;

Sayeh U1 (clk, ReadMem, WriteMem, ReadIO, WriteIO,
	      Databus, Addressbus, ExternalReset, MemDataready);

endmodule