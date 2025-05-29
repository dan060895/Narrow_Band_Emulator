module ipm_ipMasterSoC_multislave
#(
    parameter   CONF_WIDTH          = 5,
    parameter   DATA_WIDTH          = 32
)
(
    // Main
    input  wire                       clk,
    input  wire                       rst,
    
    // MCU
    input  wire [3:0]                 addressMCU,
    input  wire                       rstMCU,
    input  wire                       rdMCU,
    input  wire                       wrMCU,
    inout  wire [7:0]                 dataMCU,
    output wire                       intMCU

);

    wire                  w_reset;
    wire [DATA_WIDTH-1:0] w_DataIPtoMCU;
    wire [DATA_WIDTH-1:0] w_DataMCUtoIP;
    wire [CONF_WIDTH-1:0] w_Conf;
    wire                  w_ReadIP;
    wire                  w_WriteIP;
    wire                  w_StartIP;
    wire                  w_INT;

    wire [DATA_WIDTH-1:0] w_dataIn_s0;
    wire                  w_read_s0;
    wire [4:0]            w_config_s0;
    wire                  w_write_s0;
    wire [DATA_WIDTH-1:0] w_dataOut_s0;
    wire                  w_start_s0;
    wire                  w_int_s0;

    wire [DATA_WIDTH-1:0] w_dataIn_s1;
    wire                  w_read_s1;
    wire [4:0]            w_config_s1;
    wire                  w_write_s1;
    wire [DATA_WIDTH-1:0] w_dataOut_s1;
    wire                  w_start_s1;
    wire                  w_int_s1;
 
    wire [DATA_WIDTH-1:0] w_dataIn_s2;
    wire                  w_read_s2;
    wire [4:0]            w_config_s2;
    wire                  w_write_s2;
    wire [DATA_WIDTH-1:0] w_dataOut_s2;
    wire                  w_start_s2;
    wire                  w_int_s2;
 
    wire [DATA_WIDTH-1:0] w_dataIn_s3;
    wire                  w_read_s3;
    wire [4:0]            w_config_s3;
    wire                  w_write_s3;
    wire [DATA_WIDTH-1:0] w_dataOut_s3;
    wire                  w_start_s3;
    wire                  w_int_s3;

    wire [DATA_WIDTH-1:0] w_dataIn_s4;
    wire                  w_read_s4;
    wire [4:0]            w_config_s4;
    wire                  w_write_s4;
    wire [DATA_WIDTH-1:0] w_dataOut_s4;
    wire                  w_start_s4;
    wire                  w_int_s4;
 
    wire [DATA_WIDTH-1:0] w_dataIn_s5;
    wire                  w_read_s5;
    wire [4:0]            w_config_s5;
    wire                  w_write_s5;
    wire [DATA_WIDTH-1:0] w_dataOut_s5;
    wire                  w_start_s5;
    wire                  w_int_s5;

    wire [DATA_WIDTH-1:0] w_dataIn_s6;
    wire                  w_read_s6;
    wire [4:0]            w_config_s6;
    wire                  w_write_s6;
    wire [DATA_WIDTH-1:0] w_dataOut_s6;
    wire                  w_start_s6;
    wire                  w_int_s6;

    wire [DATA_WIDTH-1:0] w_dataIn_s7;
    wire                  w_read_s7;
    wire [4:0]            w_config_s7;
    wire                  w_write_s7;
    wire [DATA_WIDTH-1:0] w_dataOut_s7;
    wire                  w_start_s7;
    wire                  w_int_s7;
 
    wire [DATA_WIDTH-1:0] w_dataIn_s8;
    wire                  w_read_s8;
    wire [4:0]            w_config_s8;
    wire                  w_write_s8;
    wire [DATA_WIDTH-1:0] w_dataOut_s8;
    wire                  w_start_s8;
    wire                  w_int_s8;

    wire [DATA_WIDTH-1:0] w_dataIn_s9;
    wire                  w_read_s9;
    wire [4:0]            w_config_s9;
    wire                  w_write_s9;
    wire [DATA_WIDTH-1:0] w_dataOut_s9;
    wire                  w_start_s9;
    wire                  w_int_s9;

    wire [DATA_WIDTH-1:0] w_dataIn_s10;
    wire                  w_read_s10;
    wire [4:0]            w_config_s10;
    wire                  w_write_s10;
    wire [DATA_WIDTH-1:0] w_dataOut_s10;
    wire                  w_start_s10;
    wire                  w_int_s10;
 


    assign w_reset = rst;
    
    ipm IPM
    (
        .clk_n_Hz           ( clk             ),
        .ipm_RstIn          ( w_reset         ),
        
        // MCU
        .ipmMCUDataInout    ( dataMCU         ),
        .ipmMCUAddrsIn      ( addressMCU      ),
        .ipmMCURdIn         ( rdMCU           ),
        .ipmMCUWrIn         ( wrMCU           ),
        .ipmMCUINTOut       ( intMCU          ),
        
        // IP
        .ipmPIPDataIn       ( w_DataIPtoMCU   ),
        .ipmPIPConfOut      ( w_Conf          ),
        .ipmPIPReadOut      ( w_ReadIP        ),
        .ipmPIPWriteOut     ( w_WriteIP       ),
        .ipmPIPStartOut     ( w_StartIP       ),
        .ipmPIPDataOut      ( w_DataMCUtoIP   ),
        .ipmPIPINTIn        ( w_INT           )
    );

    ip_master_soc_controller IPCORE_MASTER 
    (
        .i_clk              ( clk             ),
        .i_rst_a            ( rst             ),
        .i_en_s             ( 1'b1            ),
  
        .i_data_in          ( w_DataMCUtoIP   ),
        .o_data_out         ( w_DataIPtoMCU   ),
        .i_write            ( w_WriteIP       ),
        .i_read             ( w_ReadIP        ),
        .i_start            ( w_StartIP       ),
        .i_conf_dbus        ( w_Conf          ),
        .o_int_req          ( w_INT           ),
 
        .o_dataInAIP_IP_s0  ( w_dataIn_s0     ),  
        .o_readAIP_IP_s0    ( w_read_s0       ),   
        .o_configAIP_IP_s0  ( w_config_s0     ),  
        .o_writeAIP_IP_s0   ( w_write_s0      ),   
        .i_dataOutAIP_IP_s0 ( w_dataOut_s0    ),
        .i_int_IP_s0        ( w_int_s0        ),
        .o_start_IP_s0      ( w_start_s0      ),  

        .o_dataInAIP_IP_s1  ( w_dataIn_s1     ),  
        .o_readAIP_IP_s1    ( w_read_s1       ),   
        .o_configAIP_IP_s1  ( w_config_s1     ),  
        .o_writeAIP_IP_s1   ( w_write_s1      ),   
        .i_dataOutAIP_IP_s1 ( w_dataOut_s1    ),
        .i_int_IP_s1        ( w_int_s1        ),
        .o_start_IP_s1      ( w_start_s1      ), 

        .o_dataInAIP_IP_s2  ( w_dataIn_s2     ),  
        .o_readAIP_IP_s2    ( w_read_s2       ),   
        .o_configAIP_IP_s2  ( w_config_s2     ),  
        .o_writeAIP_IP_s2   ( w_write_s2      ),   
        .i_dataOutAIP_IP_s2 ( w_dataOut_s2    ),
        .i_int_IP_s2        ( w_int_s2        ),
        .o_start_IP_s2      ( w_start_s2      ),  

        .o_dataInAIP_IP_s3  ( w_dataIn_s3     ),  
        .o_readAIP_IP_s3    ( w_read_s3       ),   
        .o_configAIP_IP_s3  ( w_config_s3     ),  
        .o_writeAIP_IP_s3   ( w_write_s3      ),   
        .i_dataOutAIP_IP_s3 ( w_dataOut_s3    ),
        .i_int_IP_s3        ( w_int_s3        ),
        .o_start_IP_s3      ( w_start_s3      ), 

        .o_dataInAIP_IP_s4  ( w_dataIn_s4     ),  
        .o_readAIP_IP_s4    ( w_read_s4       ),   
        .o_configAIP_IP_s4  ( w_config_s4     ),  
        .o_writeAIP_IP_s4   ( w_write_s4      ),   
        .i_dataOutAIP_IP_s4 ( w_dataOut_s4    ),
        .i_int_IP_s4        ( w_int_s4        ),
        .o_start_IP_s4      ( w_start_s4      ),  

        .o_dataInAIP_IP_s5  ( w_dataIn_s5     ),  
        .o_readAIP_IP_s5    ( w_read_s5       ),   
        .o_configAIP_IP_s5  ( w_config_s5     ),  
        .o_writeAIP_IP_s5   ( w_write_s5      ),   
        .i_dataOutAIP_IP_s5 ( w_dataOut_s5    ),
        .i_int_IP_s5        ( w_int_s5        ),
        .o_start_IP_s5      ( w_start_s5      ), 

        .o_dataInAIP_IP_s6  ( w_dataIn_s6     ),  
        .o_readAIP_IP_s6    ( w_read_s6       ),   
        .o_configAIP_IP_s6  ( w_config_s6     ),  
        .o_writeAIP_IP_s6   ( w_write_s6      ),   
        .i_dataOutAIP_IP_s6 ( w_dataOut_s6    ),
        .i_int_IP_s6        ( w_int_s6        ),
        .o_start_IP_s6      ( w_start_s6      ),  

        .o_dataInAIP_IP_s7  ( w_dataIn_s7     ),  
        .o_readAIP_IP_s7    ( w_read_s7       ),   
        .o_configAIP_IP_s7  ( w_config_s7     ),  
        .o_writeAIP_IP_s7   ( w_write_s7      ),   
        .i_dataOutAIP_IP_s7 ( w_dataOut_s7    ),
        .i_int_IP_s7        ( w_int_s7        ),
        .o_start_IP_s7      ( w_start_s7      ),

        .o_dataInAIP_IP_s8  ( w_dataIn_s8     ),  
        .o_readAIP_IP_s8    ( w_read_s8       ),   
        .o_configAIP_IP_s8  ( w_config_s8     ),  
        .o_writeAIP_IP_s8   ( w_write_s8      ),   
        .i_dataOutAIP_IP_s8 ( w_dataOut_s8    ),
        .i_int_IP_s8        ( w_int_s8        ),
        .o_start_IP_s8      ( w_start_s8      ),

        .o_dataInAIP_IP_s9  ( w_dataIn_s9     ),
        .o_readAIP_IP_s9    ( w_read_s9       ),   
        .o_configAIP_IP_s9  ( w_config_s9     ),  
        .o_writeAIP_IP_s9   ( w_write_s9      ),   
        .i_dataOutAIP_IP_s9 ( w_dataOut_s9    ),
        .i_int_IP_s9        ( w_int_s9        ),
        .o_start_IP_s9      ( w_start_s9      ),

        .o_dataInAIP_IP_s10 ( w_dataIn_s10    ),  
        .o_readAIP_IP_s10   ( w_read_s10      ),   
        .o_configAIP_IP_s10 ( w_config_s10    ),  
        .o_writeAIP_IP_s10  ( w_write_s10     ),   
        .i_dataOutAIP_IP_s10( w_dataOut_s10   ),
        .i_int_IP_s10       ( w_int_s10       ),
        .o_start_IP_s10     ( w_start_s10     )
    );
     






 
endmodule
