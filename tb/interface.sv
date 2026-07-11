 
  interface fifo_if;
    
    logic clk,rd,wr;
    logic full,empty;
    logic [7:0] din,dout;
    logic rst;
    logic [4:0] cnt_dbg;
    logic [3:0] wptr_dbg;
    logic [3:0] rptr_dbg;
    
  endinterface
  
