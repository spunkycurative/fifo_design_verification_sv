class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  mailbox #(transaction) gdmbx;   // Mailbox generator-drivers
  mailbox #(transaction) msmbx;   // Monitor-scoreboard mailbox
  event nextgs;
  virtual fifo_if fif;
  
  // Constructor: create all components and connect mailboxes & interface
  function new(virtual fifo_if fif);
    gdmbx = new();
    gen = new(gdmbx);
    drv = new(gdmbx);
    msmbx = new();
    mon = new(msmbx);
    sco = new(msmbx);
    this.fif = fif;
    drv.fif = fif;
    mon.fif = fif;
    gen.next = nextgs;
    sco.next = nextgs;
  endfunction
  
  task pre_test();
    drv.reset();     // Call driver reset at test start
  endtask
  
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any          // Run all components in parallel
  endtask
  
  task post_test();
    wait(gen.done.triggered);  // Wait until generator is done
    $display("---------------------------------------------");
    $display("Error Count : %0d", sco.err);
    $display("---------------------------------------------");
    $finish();
  endtask
  
  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass
