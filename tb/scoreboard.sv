class scoreboard;
  mailbox #(transaction) mbx;
  event next;
  bit [7:0] q[$];
  int err = 0;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
  bit [7:0] exp;
  bit check_next = 0;

  forever begin
    transaction tr;
    mbx.get(tr);

    // WRITE
    if (tr.wr && !tr.full) begin
      q.push_front(tr.din);
      $display("[SCO]: DATA STORED IN QUEUE : %0d", tr.din);
    end

    // CHECK PREVIOUS READ (delayed)
    if (check_next) begin
      if (q.size() == 0) begin
        $error("[SCO] UNDERFLOW");
        err++;
      end else begin
        exp = q.pop_back();
        if (tr.dout !== exp) begin
          $error("[SCO] MISMATCH exp=%0d got=%0d", exp, tr.dout);
          err++;
        end else begin
          $display("[SCO] DATA MATCH");
        end
      end
      check_next = 0;
    end

    // MARK READ FOR NEXT CYCLE
    if (tr.rd && !tr.empty) begin
      check_next = 1;
    end

    ->next;
  end
endtask
endclass
