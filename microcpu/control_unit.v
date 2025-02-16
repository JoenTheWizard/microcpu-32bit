module control_unit(
    input      [31:0] instruction,
    input      [7:0]  status_reg,

    output reg [3:0]  alu_op,
    output reg [4:0]  alu_src1,
    output reg [4:0]  alu_src2,
    output reg [4:0]  alu_dest,

    output reg        reg_write_enable,
    output reg        imm,
    output reg [31:0] imm_val,

    //Branching specific output
    output reg        load_pc,
    output reg [31:0] load_pc_val,

    //Read or write memory
    output reg        mem_rd,
    output reg        mem_wr,
    output reg        mem_data_in,

    //Program counter (for CALL/RET)
    output reg        pc_next_enable,
    output reg        alu_next_enable
);

//Function operation
localparam [3:0]
    FUNC_NOP  = 4'b0000,
    FUNC_ADD  = 4'b0001,
    FUNC_SUB  = 4'b0010,
    FUNC_MUL  = 4'b0011,
    FUNC_AND  = 4'b0100,
    FUNC_OR   = 4'b0101,
    FUNC_XOR  = 4'b0110,
    FUNC_XNOR = 4'b0111,
    FUNC_SHL  = 4'b1000,
    FUNC_SHR  = 4'b1001,
    FUNC_INC  = 4'b1010,
    FUNC_DEC  = 4'b1011,
    FUNC_NOT  = 4'b1100;

//Opcode
localparam [5:0]
    NOP  = 6'b000000, //No Operation
    ADD  = 6'b000001, //Addition
    SUB  = 6'b000010, //Subtraction
    MUL  = 6'b000011, //Multiplication
    AND  = 6'b000100, //Bitwise And
    OR   = 6'b000101, //Bitwise Or
    JMP  = 6'b000110, //Jump
    LUI  = 6'b000111, //Load Upper Immediate
    LLI  = 6'b001000, //Load Lower Immediate
    CMP  = 6'b001010, //Compare
    JEQ  = 6'b001011, //Jump If Equal
    LOD  = 6'b001100, //Load From Address
    STR  = 6'b001101, //Store To Address
    XOR  = 6'b001110, //Exclusive Or
    XNOR = 6'b001111, //Exclusive Nor
    SHL  = 6'b010000, //Bit Shift Left
    SHR  = 6'b010001, //Bit Shift Right
    JNE  = 6'b010010, //Jump If Not Equal
    JB   = 6'b010011, //Jump If Greater
    JBE  = 6'b010100, //Jump If Greater Equal
    JL   = 6'b010101, //Jump If Less
    JLE  = 6'b010110, //Jump If Less Equal
    INC  = 6'b010111, //Increment
    DEC  = 6'b011000, //Decrement
    CALL = 6'b011001, //Call
    RET  = 6'b011010, //Return
    NOT  = 6'b011011, //Bitwise Not
    MOV  = 6'b011100, //Move
    JMPR = 6'b011101, //Jump at Register
    JEQR = 6'b011110, //Jump If Equal at Register
    JNER = 6'b011111, //Jump If Not Equal at Register
    JBR  = 6'b100000, //Jump If Greater at Register
    JBER = 6'b100001, //Jump If Greater Equal at Register
    JLR  = 6'b100010, //Jump If Less at Register
    JLER = 6'b100011; //Jump If Less Equal at Register

always @(*) begin
    //Begin to check the opcode operands and perform correct operation
    case (instruction[31:26])
        NOP: begin
            //Set output to 0 for NOP
            alu_op           <= FUNC_NOP;
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end 
        ADD: begin
            //Set signals for the ADD instruction
            alu_op           <= FUNC_ADD;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end 
        SUB: begin
            //Set signals for the SUB instruction
            alu_op           <= FUNC_SUB;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        MUL: begin
            //Set signals for the MUL instruction
            alu_op           <= FUNC_MUL;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end 
        AND: begin
            //Set signals for the AND instruction
            alu_op           <= FUNC_AND;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end 
        OR: begin
            //Set signals for the OR instruction
            alu_op           <= FUNC_OR;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        XOR: begin
            //Set signals for the XOR instruction
            alu_op           <= FUNC_XOR;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        XNOR: begin
            //Set signals for the XNOR instruction
            alu_op           <= FUNC_XNOR;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        SHL: begin
            //Set signals for the SHL instruction
            alu_op           <= FUNC_SHL;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        SHR: begin
            //Set signals for the SHR instruction
            alu_op           <= FUNC_SHR;
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= instruction[15:11];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        JMP: begin
            //Set signals for the JMP instruction
            alu_op           <= FUNC_NOP; //Set to NOP since no operation is being done in JMP
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b1;
            load_pc_val      <= instruction[25:0];
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        LUI: begin
            //Set signals for the LUI instruction
            alu_op           <= FUNC_NOP;
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= instruction[25:21];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b1;
            imm_val          <= {instruction[15:0], 16'b0};
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        LLI: begin
            //Set signals for the LLI instruction
            alu_op           <= FUNC_OR;
            alu_src1         <= 5'b0;
            alu_src2         <= instruction[25:21];
            alu_dest         <= instruction[25:21];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b1;
            imm_val          <= {16'b0, instruction[15:0]};
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        CMP: begin
            //Set signals for the CMP instruction
            alu_op           <= FUNC_SUB; //Compare by subtracting
            alu_src1         <= instruction[25:21];
            alu_src2         <= instruction[20:16];
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        JEQ: begin
            //Set signals for the JEQ instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= status_reg[0]; //Jump if equ flag is set
            load_pc_val      <= instruction[25:0];
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        JNE: begin
            //Set signals for the JNE instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= status_reg[1]; //Jump if nequ flag is set
            load_pc_val      <= instruction[25:0];
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        JB: begin
            //Set signals for the JB instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= status_reg[2]; //Jump if bigger flag is set
            load_pc_val      <= instruction[25:0];
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        JBE: begin
            //Set signals for the JBE instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= status_reg[3]; //Jump if bigger equal flag is set
            load_pc_val      <= instruction[25:0];
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        JL: begin
            //Set signals for the JL instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= status_reg[4]; //Jump if less flag is set
            load_pc_val      <= instruction[25:0];
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        JLE: begin
            //Set signals for the JLE instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= status_reg[5]; //Jump if less equal flag is set
            load_pc_val      <= instruction[25:0];
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        LOD: begin 
            //Set signals for the LOD instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[20:16];
            alu_src2         <= 5'b0;
            alu_dest         <= instruction[25:21];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b1;
            mem_data_in      <= 1'b1;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        STR: begin
            //Set signals for the STR instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[20:16];
            alu_src2         <= instruction[25:21];
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b1;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        INC: begin
            //Set signals for the INC instruction
            alu_op           <= FUNC_INC;
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= instruction[25:21];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        DEC: begin
            //Set signals for the DEC instruction
            alu_op           <= FUNC_DEC;
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= instruction[25:21];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        NOT: begin
            //Set signals for the NOT instruction
            alu_op           <= FUNC_NOT;
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= instruction[20:16];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        CALL: begin
            //Set signals for the CALL instruction
            alu_op           <= FUNC_NOP;
            alu_src1         <= 5'b0;
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b11111; //Store address in R31
            load_pc          <= 1'b1;
            load_pc_val      <= instruction[25:0];
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b1;
            alu_next_enable  <= 1'b0;
        end
        RET: begin
            //Set signals for the RET instruction
            alu_op           <= FUNC_NOP;
            alu_src1         <= 5'b11111; //Obtain address in R31
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b1;
        end
        MOV: begin
            //Set signals for the MOV instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= instruction[20:16];
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b1;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b0;
        end
        JMPR: begin
            //Set signals for the JMPR instruction
            alu_op           <= FUNC_NOP; //Set to NOP since no operation is being done in JMP
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= 1'b1;
        end
        JEQR: begin
            //Set signals for the JEQR instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= status_reg[0]; //Jump if equ flag is set
        end
        JNER: begin
            //Set signals for the JNER instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= status_reg[1]; //Jump if nequ flag is set
        end
        JBR: begin
            //Set signals for the JBR instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= status_reg[2]; //Jump if bigger flag is set
        end
        JBER: begin
            //Set signals for the JBER instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= status_reg[3]; //Jump if bigger equal flag is set
        end
        JLR: begin
            //Set signals for the JLR instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= status_reg[4]; //Jump if less flag is set
        end
        JLER: begin
            //Set signals for the JLER instruction
            alu_op           <= FUNC_NOP; //No ALU operation
            alu_src1         <= instruction[25:21];
            alu_src2         <= 5'b0;
            alu_dest         <= 5'b0;
            load_pc          <= 1'b0;
            load_pc_val      <= 26'b0;
            reg_write_enable <= 1'b0;
            imm              <= 1'b0;
            imm_val          <= 32'b0;
            mem_wr           <= 1'b0;
            mem_rd           <= 1'b0;
            mem_data_in      <= 1'b0;
            pc_next_enable   <= 1'b0;
            alu_next_enable  <= status_reg[5]; //Jump if less equal flag is set
        end
    endcase
end

endmodule
