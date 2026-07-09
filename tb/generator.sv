class generator;
  mailbox #(transaction) mbx;
  int count;
  event next, done;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();

  transaction tr;

  for(int i=0;i<16;i++) begin

    tr = new();

    tr.wr  = 1;
    tr.rd  = 0;
    tr.din = $urandom;

    $display("[GEN] WRITE %0d DATA=%0d",i,tr.din);

    mbx.put(tr);

    @(next);

  end

  // 17th write (Overflow)

  tr = new();

  tr.wr  = 1;
  tr.rd  = 0;
  tr.din = 8'hAA;

  $display("[GEN] OVERFLOW WRITE");

  mbx.put(tr);

  @(next);

  ->done;

endtask
  
endclass
