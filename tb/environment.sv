class environment;

  generator  gen;
  driver     drv;
  monitor    mon;
  scoreboard sco;

  mailbox #(transaction) gdmbx;
  mailbox #(transaction) msmbx;

  event nextgs;

  virtual fifo_if fif;

  function new(virtual fifo_if fif);

    this.fif = fif;

    gdmbx = new();
    msmbx = new();

    gen = new(gdmbx);
    drv = new(gdmbx);
    mon = new(msmbx);
    sco = new(msmbx);

    drv.fif = fif;
    mon.fif = fif;

    gen.next = nextgs;
    sco.next = nextgs;

  endfunction


  task pre_test();
    drv.reset();
  endtask


  task test();

    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_none

  endtask


  task post_test();

    // Wait until generator finishes
    @gen.done;

    // Allow remaining transactions to complete
    repeat (50)
      @(posedge fif.clk);

    $display("---------------------------------------");
    $display("Simulation Completed");
    $display("Scoreboard Errors = %0d", sco.err);
    $display("---------------------------------------");

    $finish;

  endtask


  task run();

    pre_test();

    test();

    post_test();

  endtask

endclass
