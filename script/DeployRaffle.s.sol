// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";

//import {AddConsumer, CreateSubscription, FundSubscription} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle) {
        HelperConfig helperConfig = new HelperConfig(); // This comes with our mocks!
        (
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinatorV2,
            bytes32 gasLane,
            uint64 subscriptionId,
            uint32 callbackGasLimit
        ) = helperConfig.activeNetworkConfig();
    }
}
