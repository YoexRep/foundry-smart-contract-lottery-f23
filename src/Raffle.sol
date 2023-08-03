// SPDX-License-Identifier: MIT

/**
 * @title Raffle contract
 * @author Yoex
 * @notice Este contrato es una ejemplo copiado del curso de patrick Collins
 * @dev Implements Chainlink VRFv2
 */
pragma solidity ^0.8.18;
contract Raffle { 

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee){
        i_entranceFee = entranceFee;
    }

    
    function enterRaffle() public payable{

    }

    function pickWinner() public {

    }

    /*Getter functions*/

    function getEntranceFee() external view returns(uint256){
        return i_entranceFee;
    }

}