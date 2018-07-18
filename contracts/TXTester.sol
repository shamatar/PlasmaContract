pragma solidity ^0.4.24;

import {BankexPlasmaTransaction} from "./PlasmaTransactionLibrary.sol";

contract TXTester {
    constructor() public {

    }

    function parseFromBlock(bytes _plasmaTransaction, bytes _merkleProof, bytes32 _merkleRoot) public view returns (uint32 txNum, uint8 txType, uint numIns, uint numOuts, address sender, bool isWellFormed ) {   
        BankexPlasmaTransaction.PlasmaTransaction memory TX = BankexPlasmaTransaction.signedPlasmaTransactionFromBytes(_plasmaTransaction);
        (bool included, uint256 transactionNumber) = BankexPlasmaTransaction.checkForInclusionIntoBlock(_merkleRoot, _plasmaTransaction, _merkleProof);
        require(included);
        TX.txNumberInBlock = uint32(transactionNumber);
        return (TX.txNumberInBlock, TX.txType, TX.inputs.length, TX.outputs.length, TX.sender, TX.isWellFormed);
    }
    
    function parseTransaction(bytes _plasmaTransaction) public view returns (uint32 txNum, uint8 txType, uint numIns, uint numOuts, address sender, bool isWellFormed ) {   
        BankexPlasmaTransaction.PlasmaTransaction memory TX = BankexPlasmaTransaction.signedPlasmaTransactionFromBytes(_plasmaTransaction);
        return (TX.txNumberInBlock, TX.txType, TX.inputs.length, TX.outputs.length, TX.sender, TX.isWellFormed);
    }

    function getInputInfo(bytes _plasmaTransaction, uint8 _inputNumber) public view returns (uint32 blockNumber, uint32 txNumberInBlock, uint8 outputNumberInTx, uint amount) {   
        BankexPlasmaTransaction.PlasmaTransaction memory TX = BankexPlasmaTransaction.signedPlasmaTransactionFromBytes(_plasmaTransaction);
        BankexPlasmaTransaction.TransactionInput memory input = TX.inputs[_inputNumber];
        return (input.blockNumber, input.txNumberInBlock, input.outputNumberInTX, input.amount);
    }

    function getOutputInfo(bytes _plasmaTransaction, uint8 _outputNumber) public view returns (uint8 outputNumberInTx, address recipient, uint amount) {   
        BankexPlasmaTransaction.PlasmaTransaction memory TX = BankexPlasmaTransaction.signedPlasmaTransactionFromBytes(_plasmaTransaction);
        BankexPlasmaTransaction.TransactionOutput memory output = TX.outputs[_outputNumber];
        return (output.outputNumberInTX, output.recipient, output.amount);
    }
}