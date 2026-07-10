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
      $display("[MON] cnt=%0d wptr=%0d full=%0d empty=%0d wr=%0d rd=%0d",
         fif.cnt, fif.wptr, fif.full, fif.empty, fif.wr, fif.rd);
    end
  endtask
endclass
