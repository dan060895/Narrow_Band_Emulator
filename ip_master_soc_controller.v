module ip_master_soc_controller
#(
    // Parameter Declarations
    parameter DATA_WORD = 32
)

(
    // FPGA
    input  wire                 i_clk,
    input  wire                 i_rst_a,
    input  wire                 i_en_s,

    // MCU
    input  wire [4:0]           i_conf_dbus,
    input  wire                 i_read,
    input  wire                 i_write,
    input  wire                 i_start,
    input  wire [DATA_WORD-1:0] i_data_in,
    output wire                 o_int_req,
    output wire [DATA_WORD-1:0] o_data_out, 

    //AIP port 0 
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s0,
    output wire                 o_readAIP_IP_s0,
    output wire [4:0]           o_configAIP_IP_s0,
    output wire                 o_writeAIP_IP_s0,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s0,
    input  wire                 i_int_IP_s0,
    output wire                 o_start_IP_s0,

    //AIP port 1
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s1,
    output wire                 o_readAIP_IP_s1,
    output wire [4:0]           o_configAIP_IP_s1,
    output wire                 o_writeAIP_IP_s1,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s1,
    input  wire                 i_int_IP_s1,
    output wire                 o_start_IP_s1,

    //AIP port 2
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s2,
    output wire                 o_readAIP_IP_s2,
    output wire [4:0]           o_configAIP_IP_s2,
    output wire                 o_writeAIP_IP_s2,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s2,
    input  wire                 i_int_IP_s2,
    output wire                 o_start_IP_s2,

    //AIP port 3
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s3,
    output wire                 o_readAIP_IP_s3,
    output wire [4:0]           o_configAIP_IP_s3,
    output wire                 o_writeAIP_IP_s3,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s3,
    input  wire                 i_int_IP_s3,
    output wire                 o_start_IP_s3,

    //AIP port 4
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s4,
    output wire                 o_readAIP_IP_s4,
    output wire [4:0]           o_configAIP_IP_s4,
    output wire                 o_writeAIP_IP_s4,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s4,
    input  wire                 i_int_IP_s4,
    output wire                 o_start_IP_s4,

    //AIP port 5
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s5,
    output wire                 o_readAIP_IP_s5,
    output wire [4:0]           o_configAIP_IP_s5,
    output wire                 o_writeAIP_IP_s5,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s5,
    input  wire                 i_int_IP_s5,
    output wire                 o_start_IP_s5,

    //AIP port 6
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s6,
    output wire                 o_readAIP_IP_s6,
    output wire [4:0]           o_configAIP_IP_s6,
    output wire                 o_writeAIP_IP_s6,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s6,
    input  wire                 i_int_IP_s6,
    output wire                 o_start_IP_s6,

    //AIP port 7
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s7,
    output wire                 o_readAIP_IP_s7,
    output wire [4:0]           o_configAIP_IP_s7,
    output wire                 o_writeAIP_IP_s7,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s7,
    input  wire                 i_int_IP_s7,
    output wire                 o_start_IP_s7,

    //AIP port 8
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s8,
    output wire                 o_readAIP_IP_s8,
    output wire [4:0]           o_configAIP_IP_s8,
    output wire                 o_writeAIP_IP_s8,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s8,
    input  wire                 i_int_IP_s8,
    output wire                 o_start_IP_s8,
        
    //AIP port 9
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s9,
    output wire                 o_readAIP_IP_s9,
    output wire [4:0]           o_configAIP_IP_s9,
    output wire                 o_writeAIP_IP_s9,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s9,
    input  wire                 i_int_IP_s9,
    output wire                 o_start_IP_s9,

    //AIP port 10
    output wire [DATA_WORD-1:0] o_dataInAIP_IP_s10,
    output wire                 o_readAIP_IP_s10,
    output wire [4:0]           o_configAIP_IP_s10,
    output wire                 o_writeAIP_IP_s10,
    input  wire [DATA_WORD-1:0] i_dataOutAIP_IP_s10,
    input  wire                 i_int_IP_s10,
    output wire                 o_start_IP_10

);
    wire                        w_startIPcore_uP;
    wire [DATA_WORD-1:0]        w_dataInAIP_uP;
    wire [DATA_WORD-1:0]        w_dataOutAIP_uP;
    wire [4:0]                  w_configAIP_uP;
    wire                        w_readAIP_uP;
    wire                        w_writeAIP_uP;
    wire                        w_startIPcore;

    aipCoprocessor INTERFACE_Coprocessor
    (
        .clk                                 ( i_clk             ),
        .rst                                 ( i_rst_a           ),
        .en                                  ( i_en_s            ),
    //-------------------------- To/From NIc --------------------------//
        .configAIP_net                       ( i_conf_dbus       ),   //Used for protocol to determine different actions types
        .readAIP_net                         ( i_read            ),   //Used for protocol to read different information types
        .writeAIP_net                        ( i_write           ),   //Used for protocol to write different information types
        .startAIP_net                        ( i_start           ),   //Used to start the IP-core
        .dataInAIP_net                       ( i_data_in         ),   //different data in information types
        .dataOutAIP_net                      ( o_data_out        ),   //different data out information types
        .intAIP_net                          ( o_int_req         ),   //Interruption request        
    //------------------------ To/From IP-core ------------------------//
        .dataInAIP_uP                        ( w_dataInAIP_uP    ),
        .dataOutAIP_uP                       ( w_dataOutAIP_uP   ),
        .configAIP_uP                        ( w_configAIP_uP    ),
        .readAIP_uP                          ( w_readAIP_uP      ),
        .writeAIP_uP                         ( w_writeAIP_uP     ),
        .startIPcore                         ( w_startIPcore_uP  )
    );
        

    master_nios_multiple_slave u0 (
        .clk_clk                              ( i_clk              ),
        .reset_reset_n                        ( i_rst_a            ),
 
        .aip_up_0_aip_dataout                 ( w_dataOutAIP_uP    ),
        .aip_up_0_aip_config                  ( w_configAIP_uP     ),
        .aip_up_0_aip_datain                  ( w_dataInAIP_uP     ),
        .aip_up_0_aip_read                    ( w_readAIP_uP       ),
        .start_up_external_connection_export  ( w_startIPcore_uP   ),
        .aip_up_0_aip_write                   ( w_writeAIP_uP      ),

        .int_ip_s0_export                     ( i_int_IP_s0        ),                  
        .port_s0_aip_dataout                  ( i_dataOutAIP_IP_s0 ),
        .port_s0_aip_int                      ( 1'b0               ),// Input Int
        .port_s0_aip_config                   ( o_configAIP_IP_s0  ),
        .port_s0_aip_datain                   ( o_dataInAIP_IP_s0  ),
        .port_s0_aip_read                     ( o_readAIP_IP_s0    ),
        .port_s0_aip_start                    ( o_start_IP_s0      ),
        .port_s0_aip_write                    ( o_writeAIP_IP_s0   ),
     
        .int_ip_s1_export                     ( i_int_IP_s1        ),                  
        .port_s1_aip_dataout                  ( i_dataOutAIP_IP_s1 ),
        .port_s1_aip_int                      ( 1'b0               ),// Input Int
        .port_s1_aip_config                   ( o_configAIP_IP_s1  ),
        .port_s1_aip_datain                   ( o_dataInAIP_IP_s1  ),
        .port_s1_aip_read                     ( o_readAIP_IP_s1    ),
        .port_s1_aip_start                    ( o_start_IP_s1      ),
        .port_s1_aip_write                    ( o_writeAIP_IP_s1   ),
  
        .int_ip_s2_export                     ( i_int_IP_s2        ),                    
        .port_s2_aip_dataout                  ( i_dataOutAIP_IP_s2 ),
        .port_s2_aip_int                      ( 1'b0               ),// Input Int
        .port_s2_aip_config                   ( o_configAIP_IP_s2  ),
        .port_s2_aip_datain                   ( o_dataInAIP_IP_s2  ),
        .port_s2_aip_read                     ( o_readAIP_IP_s2    ),
        .port_s2_aip_start                    ( o_start_IP_s2      ),
        .port_s2_aip_write                    ( o_writeAIP_IP_s2   ),

        .int_ip_s3_export                     ( i_int_IP_s3        ),                  
        .port_s3_aip_dataout                  ( i_dataOutAIP_IP_s3 ),
        .port_s3_aip_int                      ( 1'b0               ),// Input Int
        .port_s3_aip_config                   ( o_configAIP_IP_s3  ),
        .port_s3_aip_datain                   ( o_dataInAIP_IP_s3  ),
        .port_s3_aip_read                     ( o_readAIP_IP_s3    ),
        .port_s3_aip_start                    ( o_start_IP_s3      ),
        .port_s3_aip_write                    ( o_writeAIP_IP_s3   ),
     
        .int_ip_s4_export                     ( i_int_IP_s4        ),                  
        .port_s4_aip_dataout                  ( i_dataOutAIP_IP_s4 ),
        .port_s4_aip_int                      ( 1'b0               ),// Input Int
        .port_s4_aip_config                   ( o_configAIP_IP_s4  ),
        .port_s4_aip_datain                   ( o_dataInAIP_IP_s4  ),
        .port_s4_aip_read                     ( o_readAIP_IP_s4    ),
        .port_s4_aip_start                    ( o_start_IP_s4      ),
        .port_s4_aip_write                    ( o_writeAIP_IP_s4   ),
  
        .int_ip_s5_export                     ( i_int_IP_s5        ),                    
        .port_s5_aip_dataout                  ( i_dataOutAIP_IP_s5 ),
        .port_s5_aip_int                      ( 1'b0               ),// Input Int
        .port_s5_aip_config                   ( o_configAIP_IP_s5  ),
        .port_s5_aip_datain                   ( o_dataInAIP_IP_s5  ),
        .port_s5_aip_read                     ( o_readAIP_IP_s5    ),
        .port_s5_aip_start                    ( o_start_IP_s5      ),
        .port_s5_aip_write                    ( o_writeAIP_IP_s5   ),

        .int_ip_s6_export                     ( i_int_IP_s6        ),                  
        .port_s6_aip_dataout                  ( i_dataOutAIP_IP_s6 ),
        .port_s6_aip_int                      ( 1'b0               ),// Input Int
        .port_s6_aip_config                   ( o_configAIP_IP_s6  ),
        .port_s6_aip_datain                   ( o_dataInAIP_IP_s6  ),
        .port_s6_aip_read                     ( o_readAIP_IP_s6    ),
        .port_s6_aip_start                    ( o_start_IP_s6      ),
        .port_s6_aip_write                    ( o_writeAIP_IP_s6   ),
     
        .int_ip_s7_export                     ( i_int_IP_s7        ),                  
        .port_s7_aip_dataout                  ( i_dataOutAIP_IP_s7 ),
        .port_s7_aip_int                      ( 1'b0               ),// Input Int
        .port_s7_aip_config                   ( o_configAIP_IP_s7  ),
        .port_s7_aip_datain                   ( o_dataInAIP_IP_s7  ),
        .port_s7_aip_read                     ( o_readAIP_IP_s7    ),
        .port_s7_aip_start                    ( o_start_IP_s7      ),
        .port_s7_aip_write                    ( o_writeAIP_IP_s7   ),
  
        .int_ip_s8_export                     ( i_int_IP_s8        ),                    
        .port_s8_aip_dataout                  ( i_dataOutAIP_IP_s8 ),
        .port_s8_aip_int                      ( 1'b0               ),// Input Int
        .port_s8_aip_config                   ( o_configAIP_IP_s8  ),
        .port_s8_aip_datain                   ( o_dataInAIP_IP_s8  ),
        .port_s8_aip_read                     ( o_readAIP_IP_s8    ),
        .port_s8_aip_start                    ( o_start_IP_s8      ),
        .port_s8_aip_write                    ( o_writeAIP_IP_s8   ),

        .int_ip_s9_export                     ( i_int_IP_s9        ),                  
        .port_s9_aip_dataout                  ( i_dataOutAIP_IP_s9 ),
        .port_s9_aip_int                      ( 1'b0               ),// Input Int
        .port_s9_aip_config                   ( o_configAIP_IP_s9  ),
        .port_s9_aip_datain                   ( o_dataInAIP_IP_s9  ),
        .port_s9_aip_read                     ( o_readAIP_IP_s9    ),
        .port_s9_aip_start                    ( o_start_IP_s9      ),
        .port_s9_aip_write                    ( o_writeAIP_IP_s9   ),
  
        .int_ip_s10_export                    ( i_int_IP_s10       ),                    
        .port_s10_aip_dataout                 ( i_dataOutAIP_IP_s10),
        .port_s10_aip_int                     ( 1'b0               ),// Input Int
        .port_s10_aip_config                  ( o_configAIP_IP_s10 ),
        .port_s10_aip_datain                  ( o_dataInAIP_IP_s10 ),
        .port_s10_aip_read                    ( o_readAIP_IP_s10   ),
        .port_s10_aip_start                   ( o_start_IP_s10     ),
        .port_s10_aip_write                   ( o_writeAIP_IP_s10  )          
 );











endmodule
