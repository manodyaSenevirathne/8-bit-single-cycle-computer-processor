`timescale 1ns/100ps

module data_cache (
    clock,
    reset,
    read,
    write,
    address,
    writedata,
    mem_busywait,
    mem_readdata,
    readdata,
    mem_read,
    mem_write,
    busywait,
    mem_address,
    mem_writedata    
);


    input clock;
    input reset;
    input read;                        
    input write;                       
    input [7:0] address;                
    input [7:0] writedata;              
    input mem_busywait;                
    input [31:0] mem_readdata;         
    output [7:0] readdata;            
    output reg mem_read, mem_write;    
    output reg busywait;             
    output reg [5:0] mem_address;   
    output reg [31:0] mem_writedata;   

    
    /*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    ...
    */

    reg cacheValid [7:0];              
    reg cacheDirty [7:0];             
    reg [2:0] cacheTag [7:0];         
    reg [31:0] cache [7:0];       

    integer i;

    // Reset data cache
    always @ (reset)
    begin
        for(i = 0; i < 8; i++) begin
            cacheValid[i] = 1'd0;
            cacheDirty[i] = 1'd0;
            cacheTag[i] = 3'dx;
            cache[i] = 32'dx;
        end
    end

    wire valid, dirty;      
    wire [2:0] tag;        
    reg [31:0] data;        


    // Decide whether CPU should be stalled in order to perform memory read or write
    always @ (read, write)
    begin
        if (read || write) begin
            busywait = 1'b1;
        end else begin
            busywait = 1'b0;
        end
    end

    always @ (*)
    begin
        #1
        data = cache[address[4:2]];           
    end

    assign #1 valid = cacheValid[address[4:2]];    
    assign #1 dirty = cacheDirty[address[4:2]];   
    assign #1 tag = cacheTag[address[4:2]];        

    wire comparatorsignal; 
    wire hitsignal;        

    // Getting whether tag bits in corresponding index & tag bits given by memory address matches
    assign #0.9 comparatorsignal = (tag == address[7:5]) ? 1 : 0;

	assign hitsignal = comparatorsignal && valid;

    // If it is a hit, CPU should not be stalled. So, mem_busywait should be de-asserted
    always @ (posedge clock)
    if (hitsignal) begin
        busywait = 1'b0;
    end


    // Reading data blocks asynchronously from the cache to send to register file according to the offset, if it is a read hit
    assign #1 readdata = ((address[1:0] == 2'b01) && read && hitsignal) ? data[15:8] :
                         ((address[1:0] == 2'b10) && read && hitsignal) ? data[23:16] :
                         ((address[1:0] == 2'b11) && read && hitsignal) ? data[31:24] : data[7:0];
    
    // Writing data blocks to the cache if it is a 'hit' according to the offset
    always @ (posedge clock)
    begin
        if (hitsignal && write) begin
            #1;
            cacheDirty[address[4:2]] = 1'b1;      

            if (address[1:0] == 2'b00) begin
                cache[address[4:2]][7:0] = writedata;
            end else if (address[1:0] == 2'b01) begin
                cache[address[4:2]][15:8] = writedata;
            end else if (address[1:0] == 2'b10) begin
                cache[address[4:2]][23:16] = writedata;
            end else if (address[1:0] == 2'b11) begin
                cache[address[4:2]][31:24] = writedata;
            end
        end
    end

    /* Cache Controller FSM Start */
    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010, CACHE_UPDATE = 3'b011;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*) begin
        case (state)
            IDLE:
                if ((read || write) && !dirty && !hitsignal)  
                    next_state = MEM_READ;         
                else if ((read || write) && dirty && !hitsignal)
                    next_state = MEM_WRITE;        
                else
                    next_state = IDLE;            
            
            MEM_READ:
                if (mem_busywait)
                    next_state = MEM_READ;         
                else    
                    next_state = CACHE_UPDATE;     

            MEM_WRITE:
                if (mem_busywait)
                    next_state = MEM_WRITE;         
                else    
                    next_state = MEM_READ;          

            CACHE_UPDATE:
                next_state = IDLE;                  
            
        endcase
    end

    // combinational output logic
    always @(state)
    begin
        case(state)
            IDLE: begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 32'dx;
                busywait = 0;
            end
         
            MEM_READ: begin
                mem_read = 1;                      
                mem_write = 0;
                mem_address = {address[7:2]};       
                mem_writedata = 32'dx;
            end
            
            MEM_WRITE: begin
                mem_read = 0;
                mem_write = 1;                     
                mem_address = {tag,address[4:2]};   
                mem_writedata = data;              
            end

            CACHE_UPDATE: begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 32'dx;

                #1
                cache[address[4:2]] = mem_readdata;   
                cacheTag[address[4:2]] = address[7:5];     
                cacheValid[address[4:2]] = 1'b1;           
                cacheDirty[address[4:2]] = 1'b0;           
            end
        endcase
    end

    // sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end
    /* Cache Controller FSM End */
endmodule