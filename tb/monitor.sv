class monitor;
  virtual fifo_if fif;
  mailbox #(transaction) mbx;
  transaction tr;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    forever begin
      @(posedge fif.clk);
      #1;
      //no write when full without read
      assert(!(fif.wr && fif.full && !fif.rd))
       else $error("[ASSERT]:fifo overflow:write when ful");
      assert(!(fif.rd && fif.empty))
      else $error("[ASSERT]:fifo underflow:read when empty");
      tr = new();
      tr.wr    = fif.wr;
      tr.rd    = fif.rd;
      tr.din   = fif.din;
      tr.dout  = fif.dout;
      tr.full  = fif.full;
      tr.empty = fif.empty;
      mbx.put(tr);

      $display("[MON]: wr=%0d rd=%0d din=%0d dout=%0d full=%0d empty=%0d",
               tr.wr, tr.rd, tr.din, tr.dout, tr.full, tr.empty);
    end
  endtask
endclass
