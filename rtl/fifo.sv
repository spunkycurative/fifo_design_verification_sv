// Code your design here
module fifo(
input clk,rst,wr,rd,
  input [7:0] din,output reg [7:0] dout,
  output full,empty
);
  
  reg [3:0] wptr=0,rptr=0;
  reg [4:0] cnt=0;
  reg [7:0] mem [15:0];
  
  always @(posedge clk)begin
    if(rst==1'b1)
      begin
        wptr<=0;
        rptr<=0;
        cnt<=0;
        
      end
    
    //WRITE ONLY
    if(wr&&!full && !(rd && !empty))
      begin
        mem[wptr]<=din;
        wptr<=wptr+1;
        cnt<=cnt+1;
      end
    
    //READ ONLY
    else if(rd && !empty && !(wr && !full))
      begin
        dout<=mem[rptr];
        rptr<=rptr+1;
        cnt<=cnt-1;
        
      end
    else if(wr && rd && !full && !empty)
      begin
        mem[wptr]<=din;
        dout<=wptr+1;
        rptr<=rptr+1;
        cnt<=cnt;
        
      end 
    
    //READ AND WRITE WITH FULL FIFO
    else if(wr && rd && full)
      begin
        dout<=mem[rptr];
        mem[wptr]<=din;
        wptr<=wptr+1;
        rptr<=rptr+1;
        cnt<=cnt;
      end
    
    //READ AND WRITE WITH EMPTY FIFO
    
    else if(wr && rd && empty)
      begin
        mem[wptr]<=din;
        dout<=mem[rptr];
        wptr<=wptr+1;
        rptr<=rptr+1;
        cnt<=cnt;
      end
    
  end
 
    assign empty = (cnt == 0);
    assign full  = (cnt == 16);
  
endmodule
  
  interface fifo_if;
    
    logic clk,rd,wr;
    logic full,empty;
    logic [7:0] din,dout;
    logic rst;
    
  endinterface
  
