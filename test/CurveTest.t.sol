// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CurveFi.sol";
import "../interfaces/cinterface.sol";
import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";

contract CounterTest is Test {
    Curve3Pool public curve;
    SwapRouterInterface public swapRouter;
    IERC20 public usdc;
    IERC20 public usdt;
    IERC20 public dai;
    address public testUser;

    function setUp() public {
        testUser = address(0x7);

        vm.startPrank(testUser);
        vm.rollFork(13848982);
        curve = Curve3Pool(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7);
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        swapRouter = SwapRouterInterface(payable(0xE592427A0AEce92De3Edee1F18E0157C05861564));
        mintUserTestCoins();
    }

    function mintUserTestCoins() internal {
        dai.approve(address(curve), type(uint256).max);
        usdc.approve(address(curve), type(uint256).max);
        // usdt.approve(address(curve), 0);

        console.log(usdt.totalSupply());
        vm.deal(testUser, 1000 ether);

        // acquire coins from Uniswap
    }

    function testAddLiquid() public {
        console.log(dai.totalSupply());
        console.log(curve.get_dy(1, 2, 3));
    }
}
