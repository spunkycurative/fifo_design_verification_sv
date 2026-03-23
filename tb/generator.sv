
class generator;
  mailbox #(transaction) mbx;
  int count;
  event next, done;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    repeat(count) begin
      transaction tr = new();          // NEW object each time
      assert(tr.randomize()) else $error("randomization failed");
      mbx.put(tr);
      $display("[GEN]: wr=%0d rd=%0d din=%0d", tr.wr, tr.rd, tr.din);
      @(next);
    end
    ->done;
  endtask
endclass
