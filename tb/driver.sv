class driver;
  virtual fifo_if fif;           // FIFO interface handle to drive DUT signals
  mailbox #(transaction) mbx;   // Mailbox to receive transactions from generator
  transaction datac;            // Local transaction object
  
  // Constructor: initialize mailbox
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  // Reset: assert reset for 5 clock cycles, initialize signals
  task reset();
    fif.rst <= 1'b1;
    fif.wr <= 1'b0;
    fif.rd <= 1'b0;
    fif.din <= 0;
    repeat(5) @(posedge fif.clk);
    fif.rst <= 1'b0;
    $display("[DRV]:reset done");
    $display("--------------------");
  endtask
  task run();
  forever begin
    mbx.get(datac);

    @(posedge fif.clk);
    fif.wr  <= datac.wr && !fif.full;
    fif.rd  <= datac.rd && !fif.empty;
    fif.din <= datac.din;

    @(posedge fif.clk);  // HOLD FOR FULL CYCLE

    fif.wr <= 0;
    fif.rd <= 0;
  end
endtask
  
endclass
