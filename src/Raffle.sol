// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions


// SPDX-License-Identifier: MIT

/**
 * @title Raffle contract
 * @author Yoex
 * @notice Este contrato es una ejemplo copiado del curso de patrick Collins
 * @dev Implements Chainlink VRFv2
 */
pragma solidity ^0.8.18;
contract Raffle { 

    error Raffle__notEnoughtEthSent();

    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    constructor(uint256 entranceFee){
        i_entranceFee = entranceFee;
    }

    
    //Esta funcion external ,y no publica, por que es mas eficiente al nivel de gas y auqnue solo puede ser llamada desde fuera, y no del interior.
    function enterRaffle() external payable{

        if(msg.value < i_entranceFee){
            revert Raffle__notEnoughtEthSent();
        }

        s_players.push(payable(msg.sender)); //Entramos la direccion de la persona de forma payable, para poder enviarle dinero luego en caso de que gane

    }

    function pickWinner() public {

    }

    /*Getter functions*/

    function getEntranceFee() external view returns(uint256){
        return i_entranceFee;
    }

}