
module tb;
  fifo_if fif();        // Instantiate FIFO interface
  fifo dut(
  fif.clk, fif.rst, fif.wr, fif.rd,
  fif.din, fif.dout,
  fif.full, fif.empty,fif.cnt_dbg,fif.wptr_dbg,fif.rptr_dbg
);
  // FIFO DUT
  initial fif.clk = 0;
  always #10 fif.clk = ~fif.clk;  // 50MHz clock
  
  environment env;
  fifo_assertions asrt(fif);
  
  initial begin
    env = new(fif);
    env.gen.count = 200;
    env.run();
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb);
    #10000;
    $stop;
  end
endmodule
  
  
