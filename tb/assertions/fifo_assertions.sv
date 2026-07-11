//----------------Assertion Module--------------------//
module fifo_assertions(fifo_if fif);
  
property p_overflow_does_not_change_count;
  @(posedge fif.clk)
  disable iff(fif.rst)
  (fif.wr && fif.full && !fif.rd)
  |=> fif.cnt_dbg == $past(fif.cnt_dbg);
endproperty

assert property(p_overflow_does_not_change_count)
  else
    $error("FIFO count changed during overflow");
    
property p_underflow_does_not_change_count;
  @(posedge fif.clk)
  disable iff(fif.rst)
  (fif.rd && fif.empty && !fif.wr)
  |=> fif.cnt_dbg == $past(fif.cnt_dbg);
endproperty

assert property(p_underflow_does_not_change_count);
      
      property full_empty_never_high_together;
        @(posedge fif.clk)
        disable iff(fif.rst)
        !(fif.full && fif.empty);
      endproperty
      
      assert property(full_empty_never_high_together)
        else
          $error("full and empty high together");
        
        property p_reset_makes_fifo_empty;
          @(posedge fif.clk)
          fif.rst |=> fif.empty;
        endproperty
        
        assert property(p_reset_makes_fifo_empty);
          
        property p_reset_clears_full;
          @(posedge fif.clk)
          fif.rst |=> !fif.full;
        endproperty
          
          assert property(p_reset_clears_full);
            
        property p_cnt_max;
          @(posedge fif.clk)
          disable iff(fif.rst)
          fif.cnt_dbg<=16;
        endproperty
            
            assert property(p_cnt_max)
              else
                $error("count exceeded fifo depth");
              
        property p_empty_flag;
          @(posedge fif.clk)
          disable iff(fif.rst)
          (fif.cnt_dbg==0) |-> fif.empty;
        endproperty
              assert property(p_empty_flag);
                
        property p_full_flag;
          @(posedge fif.clk)
          disable iff(fif.rst)
          (fif.cnt_dbg==16) |-> fif.full;
        endproperty
                assert property(p_full_flag);
       
        property p_write_increments_cnt;
          @(posedge fif.clk)
          disable iff(fif.rst)
          (fif.wr && !fif.full && !fif.rd) |=> fif.cnt_dbg==$past(fif.cnt_dbg)+1; 
        endproperty
                  assert property (p_write_increments_cnt);
                    
        property p_read_decrements_cnt;
          @(posedge fif.clk)
          disable iff(fif.rst)
          (fif.rd && !fif.empty && !fif.wr) |=> fif.cnt_dbg==$past(fif.cnt_dbg)-1;
        endproperty
                    
                    assert property (p_read_decrements_cnt);
                      
        property p_simultaneous_read_write;
          @(posedge fif.clk)
          disable iff(fif.rst)
          (fif.rd && fif.wr && !fif.empty && !fif.full) |=> fif.cnt_dbg==$past(fif.cnt_dbg);
        endproperty
                      
                      assert property (p_simultaneous_read_write);  
                        
       property p_wptr_increments;
         @(posedge fif.clk)
         disable iff(fif.rst)
         (fif.wr && !fif.full && !fif.rd) |=> fif.wptr_dbg==$past(fif.wptr_dbg)+1;
       endproperty
                        
                        assert property (p_wptr_increments);
  
       property p_rptr_increments;
         @(posedge fif.clk)
         disable iff(fif.rst)
         (fif.rd && !fif.empty && !fif.wr) |=> fif.rptr_dbg==$past(fif.rptr_dbg)+1;
       endproperty
                          
                          assert property (p_rptr_increments);                      
                            
                          
endmodule

