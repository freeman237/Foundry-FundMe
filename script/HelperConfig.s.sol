// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "lib/foundry-devops/lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.t.sol";

contract HelperConfig is Script {
    // If we are on a local anvil chain, we deploy mocks
    // Otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }
    
    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        });
        return sepoliaConfig;
    }
    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        // Implement Anvil config here
       vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
       vm.stopBroadcast();

       NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
       });
       
       return anvilConfig;
    }
}
