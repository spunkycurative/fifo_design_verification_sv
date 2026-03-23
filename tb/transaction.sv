class transaction;
  //rand bit oper;          // Operation: 1 = write to FIFO, 0 = read from FIFO
  rand bit wr, rd;             // Write/read handshake signals
  rand bit [7:0] din;      // Data to be written into FIFO
  bit [7:0] dout;     // Data read from FIFO
  bit full, empty;        // FIFO status flags indicating full or empty
 constraint wr_rd_c {
    wr dist {1:=50, 0:=50};
    rd dist {1:=50, 0:=50};
  }
endclass
