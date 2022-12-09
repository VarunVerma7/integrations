// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CurveFi.sol";
import "../interfaces/cinterface.sol";
import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";

contract CounterTest is Test {
    using SafeERC20 for IERC20;

    Curve3Pool public curve;
    SwapRouterInterface public swapRouter;
    UniswapV2Router public v2router;
    IERC20 public usdc;
    IERC20 public usdt;
    IERC20 public dai;
    IERC20 public weth;
    IERC20 public pool3Lp;
    address public testUser;

    function setUp() public {
        testUser = address(0x7);

        vm.startPrank(testUser);
        vm.rollFork(13848982);
        pool3Lp = IERC20(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
        curve = Curve3Pool(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7);
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        swapRouter = SwapRouterInterface(payable(0xE592427A0AEce92De3Edee1F18E0157C05861564));
        v2router = UniswapV2Router(payable(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
        mintUserTestCoins();
    }

    function mintUserTestCoins() internal {
        dai.approve(address(v2router), type(uint256).max);
        usdc.approve(address(v2router), type(uint256).max);
        dai.approve(address(curve), type(uint256).max);
        usdc.approve(address(curve), type(uint256).max);    
        usdt.safeApprove(address(curve), type(uint256).max);

        console.log(usdt.totalSupply());
        vm.deal(testUser, 1000 ether);

        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = address(usdc);

        v2router.swapETHForExactTokens{value: 3 ether}(3_000 * 1e6, path, testUser, type(uint256).max);
        console.log("USDC BALANCE AFTER SWAP: ", usdc.balanceOf(testUser) / 10e6);

        path[1] = address(usdt);
        v2router.swapETHForExactTokens{value: 3 ether}(3_000 * 1e6, path, testUser, type(uint256).max);
        console.log("USDT BALANCE AFTER SWAP: ", usdt.balanceOf(testUser) / 10e6);

        path[1] = address(dai);
        v2router.swapETHForExactTokens{value: 3 ether}(3_000 * 1e18, path, testUser, type(uint256).max);
        console.log("DAI BALANCE AFTER SWAP: ", dai.balanceOf(testUser) / 10e18);

       uint[3] memory amounts;
       amounts[0] = 300 * 1e18;
       amounts[1] = 300 * 1e6;
       amounts[2] = 300 * 1e6;


        curve.add_liquidity(amounts, 1);
        console.log("LP TOKENS RECEIVED: ", pool3Lp.balanceOf(testUser) / 1e18);
    }

    function testAddLiquid() public {
        console.log(dai.totalSupply());
        console.log(curve.get_dy(1, 2, 3));
    }
}
