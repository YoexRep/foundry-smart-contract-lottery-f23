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

import {VRFCoordinatorV2Interface} from  "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Raffle is VRFConsumerBaseV2 {
    error Raffle__notEnoughtEthSent();
    error Raffle__notEnoughtTimePassed();
        error Raffle__TransferFailed();
            error Raffle_RaffleNotOpen();

        /**Type Declarations */

    enum RaffleState {
        OPEN,
        CALCULATING
    }




    /*STate variables*/

    RaffleState private s_raffleState;
    uint16 private constant  REQUEST_CONFIRMATIONS= 3;
    uint32 private constant NUM_WORDS= 1;

    uint256 private immutable i_entranceFee;
     VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
     bytes32 private immutable i_gasLane;
     uint64 private immutable i_subscriptionId;
      uint32 private immutable i_callbackGasLimit;

    //@dev Duracion de la loteria en segundos
    uint256 private immutable i_interval;

    address payable[] private s_players;


    //Para guardar el ultimo tiempo de la loteria
    uint256 private s_lasTimeStamp;

    address private s_recentWinner;

    /**Events */
    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);

    constructor(uint256 entranceFee, uint256 interval, address vrfCoordinator, bytes32 gasLane , 
    uint64 subscriptionId, uint32 callbackGasLimit) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lasTimeStamp = block.timestamp; // el primera screenshot de timestamp
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId= subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_raffleState = RaffleState.OPEN;
    }

    //Esta funcion external ,y no publica, por que es mas eficiente al nivel de gas y auqnue solo puede ser llamada desde fuera, y no del interior.
    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__notEnoughtEthSent();
        }

        if(s_raffleState != RaffleState.OPEN){
            revert Raffle_RaffleNotOpen();
        }

        s_players.push(payable(msg.sender)); //Entramos la direccion de la persona de forma payable, para poder enviarle dinero luego en caso de que gane

        emit EnteredRaffle(msg.sender);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override{

        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;
        s_raffleState = RaffleState.OPEN;

        s_players = new address payable[](0);//Reseteamos el array antes de enviar el dinero para evitar un reentry attack
        s_lasTimeStamp = block.timestamp;

        (bool success, ) = winner.call{value: address(this).balance}("");
        if(!success){
            revert Raffle__TransferFailed();
        }

        emit PickedWinner(winner);

    }

    function pickWinner() public {
        //Revisar si ya ha pasado el tiempo suficiente

        if ((block.timestamp - s_lasTimeStamp) < i_interval) {
            revert Raffle__notEnoughtTimePassed();
        }
        s_raffleState = RaffleState.CALCULATING;

          uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, //keyHash de la red
            i_subscriptionId, //Subricion id en chain.link
            REQUEST_CONFIRMATIONS, //Cantidad de confirmacion en la blockchain
            i_callbackGasLimit, //La cantidad de gas que esto dispuesto a pagar
            NUM_WORDS // Cantidad de numeros randoms
        );
    }

    /*Getter functions*/

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
